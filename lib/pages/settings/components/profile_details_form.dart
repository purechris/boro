import 'package:flutter/material.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Form fields for profile details (name, description, contact).
class ProfileDetailsForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController contactController;

  const ProfileDetailsForm({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.contactController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNameField(context),
        const SizedBox(height: 16),
        _buildDescriptionField(context),
        const SizedBox(height: 16),
        _buildContactField(context),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.displayName,
        border: const OutlineInputBorder(),
        helperText: AppLocalizations.of(context)!.displayNameUnique,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context)!.nameRequired;
        }
        if (value.trim().length > 20) {
          return AppLocalizations.of(context)!.nameMaxLength;
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.aboutMe,
        border: const OutlineInputBorder(),
      ),
      minLines: 3,
      maxLines: 10,
      validator: (value) {
        if (value != null && value.length > 500) {
          return AppLocalizations.of(context)!.descriptionMaxLength;
        }
        return null;
      },
    );
  }

  Widget _buildContactField(BuildContext context) {
    return TextFormField(
      controller: contactController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.contact,
        border: const OutlineInputBorder(),
        helperText: AppLocalizations.of(context)!.contactHint,
      ),
    );
  }
}
