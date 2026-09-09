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
  final _contactController = TextEditingController();
  final _postalCodeController = TextEditingController();

  // State
  XFile? _selectedImage;
  String? imageUrl;
  bool _isSaving = false;
  String _selectedCountryCode = 'DE';
  String? _resolvedCity;
  double? _latitude;
  double? _longitude;
  bool _isFetchingLocation = false;
  bool _locationLookupFailed = false;
  // UI Constants
  static const _padding = 16.0;
  static const _spacing = 16.0;

  // Error Messages

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _postalCodeController.dispose();
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
          _resolvedCity = user.city;
          _contactController.text = user.telephone ?? '';
          _postalCodeController.text = user.postalCode ?? '';
          _selectedCountryCode = user.countryCode ?? 'DE';
          _latitude = user.latitude;
          _longitude = user.longitude;
          imageUrl = user.imageUrl;
        });
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    }
  }

  bool get _isLocationResolved {
    return _postalCodeController.text.trim().isEmpty || _latitude != null;
  }

  void _onPostalCodeChanged(String value) {
    if (_latitude != null || _longitude != null || _resolvedCity != null || _locationLookupFailed) {
      setState(() {
        _resolvedCity = null;
        _latitude = null;
        _longitude = null;
        _locationLookupFailed = false;
      });
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
          _locationLookupFailed = false;
        });
      } else {
        setState(() {
          _resolvedCity = null;
          _latitude = null;
          _longitude = null;
          _locationLookupFailed = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _locationLookupFailed = true);
        if (e.toString().contains('XMLHttpRequest')) {
          SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final trimmedPostalCode = _postalCodeController.text.trim();
    if (trimmedPostalCode.isNotEmpty && _latitude == null) {
      await _fetchLocationData(_selectedCountryCode, trimmedPostalCode);
    }

    if (!mounted) return;
    if (!_isLocationResolved) {
      setState(() => _isSaving = false);
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.postalCodeNotResolved);
      return;
    }

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
        city: _resolvedCity ?? '',
        telephone: _contactController.text,
        imageUrl: newImageUrl,
        created: currentUser.created,
        friendCode: currentUser.friendCode,
        countryCode: _selectedCountryCode,
        postalCode: trimmedPostalCode,
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

  Future<void> _showImageSourcePicker() async {
    final source = await _showSourceBottomSheet();
    if (source == null) return;
    await _pickImageFromSource(source);
  }

  Future<ImageSource?> _showSourceBottomSheet() {
    final localizations = AppLocalizations.of(context)!;
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(localizations.imageSourceCamera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(localizations.imageSourceGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        final String extension = image.path.split('.').last.toLowerCase();
        if (['mp4', 'mov', 'avi', 'gif', 'hevc'].contains(extension)) {
          if (mounted) {
            SnackbarUtils.showError(context, AppLocalizations.of(context)!.invalidImageType);
          }
          return;
        }
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
                  onPickImage: _showImageSourcePicker,
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
                  isFetchingLocation: _isFetchingLocation,
                  onCountryCodeChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCountryCode = val;
                        _resolvedCity = null;
                        _latitude = null;
                        _longitude = null;
                        _locationLookupFailed = false;
                      });
                    }
                  },
                  onPostalCodeChanged: _onPostalCodeChanged,
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
