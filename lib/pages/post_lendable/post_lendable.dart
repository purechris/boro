import 'package:verleihapp/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:verleihapp/utils/location_utils.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:verleihapp/pages/post_lendable_success.dart';
import 'package:verleihapp/services/lendable_service.dart';
import 'package:verleihapp/services/file_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/services/group_service.dart';
import 'package:verleihapp/models/group_model.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/pages/post_lendable/components/post_image_picker.dart';
import 'package:verleihapp/pages/post_lendable/components/post_details_form.dart';
import 'package:verleihapp/pages/post_lendable/components/post_visibility_section.dart';
import 'package:verleihapp/pages/post_lendable/components/post_location_form.dart';

class PostLendablePage extends StatefulWidget {
  final LendableModel? lendable;
  
  const PostLendablePage({super.key, this.lendable});

  @override
  State<PostLendablePage> createState() => _PostLendablePageState();
}

class _PostLendablePageState extends State<PostLendablePage> {
  // Services
  final LendableService _lendableService = LendableService();
  final FileService _fileService = FileService();
  final UserService _userService = UserService();
  final GroupService _groupService = GroupService();
  
  // Formularfelder
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final FocusNode _postalCodeFocusNode = FocusNode();
  String? _selectedCategoryName;
  XFile? _selectedImage;
  String? imageUrl;
  String? imageFileName;
  bool _isSaving = false;
  bool _isLoading = false; // Neu: Ladezustand für initiale Daten
  bool _useCustomLocation = false;
  String _selectedCountryCode = 'DE';
  String? _resolvedCity;
  double? _latitude;
  double? _longitude;
  bool _isFetchingLocation = false;

  // Kategorien und Typen
  List<CategoryModel> _categories = [];
  String _selectedLendableType = LendableType.offer.value;
  String? _selectedVisibility = VisibilityMode.indirectContacts.value;

  // Gruppen-Sichtbarkeit
  String _selectedGroupVisibility = AppConstants.filterAll;
  List<String> _selectedGroupIds = [];
  List<GroupModel> _userGroups = [];
  bool _isLoadingGroups = true;

  // UI-Konstanten
  static const double _spacing = 16.0;
  static const double _bottomSpacing = 24.0;
  static const double _horizontalPadding = 16.0;

  // Fehlermeldungen

  @override
  void initState() {
    super.initState();
    _postalCodeFocusNode.addListener(_onPostalCodeFocusChange);
    _setupInitialData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _postalCodeController.dispose();
    _postalCodeFocusNode.removeListener(_onPostalCodeFocusChange);
    _postalCodeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _setupInitialData() async {
    _categories = CategoryModel.getCategories();
    
    if (widget.lendable != null) {
      setState(() => _isLoading = true);
      try {
        // Frischen Stand aus der Datenbank laden, um alle Felder (inkl. Gruppen) zu haben
        final fullLendable = await _lendableService.getLendable(widget.lendable!.id);
        
        if (mounted) {
          setState(() {
            _titleController.text = fullLendable.title;
            _descriptionController.text = fullLendable.description;
            _locationController.text = fullLendable.city;
            _postalCodeController.text = fullLendable.postalCode ?? '';
            _selectedCountryCode = fullLendable.countryCode ?? 'DE';
            _useCustomLocation = (fullLendable.postalCode != null && fullLendable.postalCode!.isNotEmpty);
            _selectedCategoryName = fullLendable.category;
            _selectedLendableType = fullLendable.type;
            _selectedVisibility = fullLendable.visibility;
            _selectedGroupVisibility = fullLendable.groupVisibility;
            _selectedGroupIds = List<String>.from(fullLendable.groupIds);
            imageUrl = fullLendable.imageUrl;
            imageFileName = fullLendable.imageFileName;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
        }
      }
    }
    
    // Gruppen parallel oder danach laden
    _loadUserGroups();
  }

  void _onPostalCodeChanged(String value) {
    if (value.trim().length < 3) {
      _clearLocationFields();
    }
  }

  Future<void> _fetchLocationData(String countryCode, String postalCode) async {
    setState(() => _isFetchingLocation = true);
    try {
      final data = await LocationUtils.fetchLocationData(countryCode, postalCode);
      if (!mounted) return;
      if (data != null) {
        setState(() {
          _resolvedCity = data.city;
          _latitude = data.latitude;
          _longitude = data.longitude;
          _locationController.text = _resolvedCity ?? '';
        });
      } else {
        _clearLocationFields();
      }
    } catch (e) {
      if (mounted && e.toString().contains('XMLHttpRequest')) {
        SnackbarUtils.showError(
          context, 
          AppLocalizations.of(context)!.errorOccurred
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

  void _clearLocationFields() {
    if (!mounted) return;
    setState(() {
      _resolvedCity = null;
      _latitude = null;
      _longitude = null;
      _locationController.clear();
    });
  }

  void _onPostalCodeFocusChange() {
    if (!_postalCodeFocusNode.hasFocus) {
      _triggerLocationLookup();
    }
  }

  void _triggerLocationLookup() {
    final trimmed = _postalCodeController.text.trim();
    if (trimmed.length < 3) {
      _clearLocationFields();
      return;
    }
    _fetchLocationData(_selectedCountryCode, trimmed);
  }

  Future<void> _loadUserGroups() async {
    try {
      final userId = _userService.getCurrentUserId();
      final groups = await _groupService.getUserGroups(userId);
      if (mounted) {
        setState(() {
          _userGroups = groups;
          _isLoadingGroups = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingGroups = false);
      }
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      imageUrl = null;
      imageFileName = null;
    });
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Prüfung auf Bewegtbilder (Videos, animierte GIFs)
        final String extension = image.path.split('.').last.toLowerCase();
        if (['mp4', 'mov', 'avi', 'gif', 'hevc'].contains(extension)) {
          if (mounted) {
            SnackbarUtils.showError(context, AppLocalizations.of(context)!.invalidImageType);
          }
          return;
        }

        // Prüfung auf Dateigröße (15 MB)
        final bytes = await image.readAsBytes();
        if (bytes.length > 15 * 1024 * 1024) {
          if (mounted) {
            SnackbarUtils.showError(context, AppLocalizations.of(context)!.fileTooLarge);
          }
          return;
        }

        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.lendable == null ? AppLocalizations.of(context)!.addArticle : AppLocalizations.of(context)!.editArticle),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: true,
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(_horizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostImagePicker(
                      selectedImage: _selectedImage,
                      imageUrl: imageUrl,
                      onPickImage: _pickImage,
                      onClearImage: _clearImage,
                    ),
                    const SizedBox(height: _spacing),
                    PostDetailsForm(
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      selectedCategoryName: _selectedCategoryName,
                      categories: _categories,
                      selectedLendableType: _selectedLendableType,
                      onCategoryChanged: (newValue) => setState(() => _selectedCategoryName = newValue),
                      onLendableTypeChanged: (newValue) => setState(() => _selectedLendableType = newValue!),
                    ),
                    const SizedBox(height: _spacing),
                    PostVisibilitySection(
                      selectedVisibility: _selectedVisibility,
                      selectedGroupVisibility: _selectedGroupVisibility,
                      selectedGroupIds: _selectedGroupIds,
                      userGroups: _userGroups,
                      isLoadingGroups: _isLoadingGroups,
                      onVisibilityChanged: (newValue) => setState(() => _selectedVisibility = newValue),
                      onGroupVisibilityChanged: (value) {
                        setState(() {
                          _selectedGroupVisibility = value!;
                          if (_selectedGroupVisibility != VisibilityMode.specific.value) {
                            _selectedGroupIds.clear();
                          }
                        });
                      },
                      onGroupSelectionChanged: (groupId, selected) {
                        setState(() {
                          if (selected) {
                            _selectedGroupIds.add(groupId);
                          } else {
                            _selectedGroupIds.remove(groupId);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: _spacing),
                    PostLocationForm(
                      useCustomLocation: _useCustomLocation,
                      selectedCountryCode: _selectedCountryCode,
                      postalCodeController: _postalCodeController,
                      locationController: _locationController,
                      postalCodeFocusNode: _postalCodeFocusNode,
                      isFetchingLocation: _isFetchingLocation,
                      onUseCustomLocationChanged: (bool value) {
                        setState(() {
                          _useCustomLocation = value;
                          if (!value) {
                            _postalCodeController.clear();
                            _locationController.clear();
                            _resolvedCity = null;
                            _latitude = null;
                            _longitude = null;
                          }
                        });
                      },
                      onCountryCodeChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCountryCode = val);
                          if (_postalCodeController.text.isNotEmpty) {
                            _fetchLocationData(val, _postalCodeController.text);
                          }
                        }
                      },
                      onPostalCodeChanged: _onPostalCodeChanged,
                      onTriggerLocationLookup: _triggerLocationLookup,
                    ),
                    const SizedBox(height: _bottomSpacing),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _userService.isDemoUser() ? null : (_isSaving ? null : _submitForm),
        child: _isSaving 
            ? Text(AppLocalizations.of(context)!.saving) 
            : Text(widget.lendable == null ? AppLocalizations.of(context)!.add : AppLocalizations.of(context)!.save),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Validierung für spezifische Gruppen
    if (_selectedGroupVisibility == 'specific' && _selectedGroupIds.isEmpty) {
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.selectAtLeastOneGroup);
      return;
    }

    setState(() => _isSaving = true);
    
    try {
      final userId = _userService.getCurrentUserId();
      final lendableId = widget.lendable?.id ?? const Uuid().v4();
      
      String? finalImageUrl = imageUrl;
      String? finalImageFileName = imageFileName;

      // 1. Zuerst das Bild hochladen, falls ein neues ausgewählt wurde
      if (_selectedImage != null) {
        try {
          final result = await _fileService.uploadLendableImage(
            _selectedImage!, 
            userId, 
            lendableId
          );
          finalImageUrl = result.url;
          finalImageFileName = result.fileName;
        } catch (e) {
          if (mounted) {
            SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
          }
          if (mounted) {
            setState(() => _isSaving = false);
          }
          return; // Abbruch, wenn Upload fehlschlägt
        }
      }

      // 2. Dann den Artikel erstellen oder aktualisieren
      final lendable = LendableModel(
        id: lendableId,
        title: _titleController.text,
        description: _descriptionController.text,
        city: _locationController.text,
        category: _selectedCategoryName ?? '',
        type: _selectedLendableType,
        visibility: _selectedVisibility ?? 'indirect-contacts',
        groupVisibility: _selectedGroupVisibility,
        groupIds: _selectedGroupIds,
        userId: userId,
        imageUrl: finalImageUrl ?? '',
        imageFileName: finalImageFileName ?? '',
        created: widget.lendable?.created ?? DateTime.now().toUtc(),
        borrowedBy: widget.lendable?.borrowedBy,
        countryCode: _useCustomLocation ? _selectedCountryCode : null,
        postalCode: _useCustomLocation ? _postalCodeController.text.trim() : null,
        latitude: _useCustomLocation ? _latitude : null,
        longitude: _useCustomLocation ? _longitude : null,
      );

      if (widget.lendable == null) {
        await _lendableService.addLendable(lendable);
      } else {
        await _lendableService.updateLendable(lendable);
      }

      if (mounted) {
        NavigationUtils.navigateToReplacement(context, PostLendableSuccessPage());
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}