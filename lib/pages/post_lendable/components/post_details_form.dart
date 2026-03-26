import 'package:flutter/material.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/category_model.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Form fields for item details (title, category, type, description).
class PostDetailsForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String? selectedCategoryName;
  final List<CategoryModel> categories;
  final String selectedLendableType;
  final Function(String?) onCategoryChanged;
  final Function(String?) onLendableTypeChanged;

  const PostDetailsForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedCategoryName,
    required this.categories,
    required this.selectedLendableType,
    required this.onCategoryChanged,
    required this.onLendableTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLendableTypeField(context),
        const SizedBox(height: 16),
        _buildTitleField(context),
        const SizedBox(height: 16),
        _buildCategoryField(context),
        const SizedBox(height: 16),
        _buildDescriptionField(context),
      ],
    );
  }

  Widget _buildLendableTypeField(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.offerTypeFormLabel,
        border: const OutlineInputBorder(),
      ),
      initialValue: selectedLendableType,
      items: LendableModel.getLendableTypes(context).map((option) {
        return DropdownMenuItem<String>(
          value: option['value']!,
          child: Text(option['displayForm']!),
        );
      }).toList(),
      onChanged: onLendableTypeChanged,
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.title,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => _validateTitle(value, context),
    );
  }

  String? _validateTitle(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.titleRequired;
    } else if (value.length < 5) {
      return AppLocalizations.of(context)!.titleMinLength;
    } else if (value.length > 50) {
      return AppLocalizations.of(context)!.titleMaxLength;
    }
    return null;
  }

  Widget _buildCategoryField(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.category,
        border: const OutlineInputBorder(),
      ),
      initialValue: selectedCategoryName,
      items: categories.map((CategoryModel category) {
        return DropdownMenuItem<String>(
          value: category.name,
          child: Text(category.getLocalizedName(context)),
        );
      }).toList(),
      onChanged: onCategoryChanged,
      validator: (value) => _validateCategory(value, context),
    );
  }

  String? _validateCategory(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.selectCategory;
    }
    return null;
  }

  Widget _buildDescriptionField(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.optionalDescription,
        border: const OutlineInputBorder(),
      ),
      minLines: 3,
      maxLines: 10,
      validator: (value) => _validateDescription(value, context),
    );
  }

  String? _validateDescription(String? value, BuildContext context) {
    if (value != null && value.length > 500) {
      return AppLocalizations.of(context)!.descriptionMaxLength;
    }
    return null;
  }
}
