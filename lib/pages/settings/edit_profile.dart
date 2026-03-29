import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verleihapp/utils/location_utils.dart';
import 'package:verleihapp/services/file_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/pages/settings/components/profile_avatar_picker.dart';
import 'package:verleihapp/pages/settings/components/profile_details_form.dart';
import 'package:verleihapp/pages/settings/components/profile_location_form.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Services
  final UserService _userService = UserService();
  final FileService _fileService = FileService();
  final ImagePicker _imagePicker = ImagePicker();

  // Form
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final FocusNode _postalCodeFocusNode = FocusNode();

  // State
  XFile? _selectedImage;
  String? imageUrl;
  bool _isSaving = false;
  String _selectedCountryCode = 'DE';
  String? _resolvedCity;
  double? _latitude;
  double? _longitude;
  bool _isFetchingLocation = false;
  // UI Constants
  static const _padding = 16.0;
  static const _spacing = 16.0;

  // Error Messages

  @override
  void initState() {
    super.initState();
    _postalCodeFocusNode.addListener(_onPostalCodeFocusChange);
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _postalCodeController.dispose();
    _postalCodeFocusNode.removeListener(_onPostalCodeFocusChange);
    _postalCodeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _userService.getCurrentUser();
      if (!mounted) return;
      if (user != null) {
        setState(() {
          _nameController.text = user.firstName;
          _descriptionController.text = user.description ?? '';
          _locationController.text = user.city ?? '';
          _contactController.text = user.telephone ?? '';
          _postalCodeController.text = user.postalCode ?? '';
          _selectedCountryCode = user.countryCode ?? 'DE';
          imageUrl = user.imageUrl;
        });
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    }
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
          AppLocalizations.of(context)!.errorOccurred,
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final currentUser = await _userService.getCurrentUser();
      if (!mounted) return;
      if (currentUser == null) throw Exception('User data could not be retrieved');

      String newImageUrl = await _handleImageUpload(currentUser);
      if (!mounted) return;

      final updatedUser = UserModel(
        id: currentUser.id,
        firstName: _nameController.text.trim(),
        description: _descriptionController.text,
        city: _locationController.text,
        telephone: _contactController.text,
        imageUrl: newImageUrl,
        created: currentUser.created,
        friendCode: currentUser.friendCode,
        countryCode: _selectedCountryCode,
        postalCode: _postalCodeController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
      );

      await _userService.updateUser(updatedUser);
      if (!mounted) return;
      
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.profileUpdatedSuccess);
      NavigationUtils.navigateBack(context);
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

  Future<String> _handleImageUpload(UserModel currentUser) async {
    String newImageUrl = imageUrl ?? '';

    if (_selectedImage != null || imageUrl == null) {
      if (currentUser.imageUrl != null && currentUser.imageUrl!.isNotEmpty) {
        await _fileService.deleteProfileImage(currentUser.id!);
      }
    }

    if (_selectedImage != null) {
      newImageUrl = await _fileService.uploadProfileImage(_selectedImage!);
    }

    return newImageUrl;
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
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

        setState(() => _selectedImage = image);
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
        title: Text(AppLocalizations.of(context)!.profileEdit),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(_padding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileAvatarPicker(
                  selectedImage: _selectedImage,
                  imageUrl: imageUrl,
                  onPickImage: _pickImage,
                  onClearImage: () => setState(() {
                    _selectedImage = null;
                    imageUrl = null;
                  }),
                ),
                const SizedBox(height: 20),
                ProfileDetailsForm(
                  nameController: _nameController,
                  descriptionController: _descriptionController,
                  contactController: _contactController,
                ),
                const SizedBox(height: _spacing),
                ProfileLocationForm(
                  selectedCountryCode: _selectedCountryCode,
                  postalCodeController: _postalCodeController,
                  locationController: _locationController,
                  postalCodeFocusNode: _postalCodeFocusNode,
                  isFetchingLocation: _isFetchingLocation,
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
                const SizedBox(height: 24),
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
            ? Text(AppLocalizations.of(context)!.profileSaving) 
            : Text(AppLocalizations.of(context)!.save),
      ),
    );
  }
}