import 'package:flutter/material.dart';
import 'package:verleihapp/utils/location_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Location fields for the edit profile page.
///
/// Only the postal code and country are shown; the resolved city is stored
/// internally and saved to the profile, but not displayed. The lookup only
/// happens when the user saves the form; if it fails, the caller shows a
/// toast instead of an inline warning here, so this widget stays layout-stable.
class ProfileLocationForm extends StatelessWidget {
  final String selectedCountryCode;
  final TextEditingController postalCodeController;
  final bool isFetchingLocation;
  final Function(String?) onCountryCodeChanged;
  final Function(String) onPostalCodeChanged;

  const ProfileLocationForm({
    super.key,
    required this.selectedCountryCode,
    required this.postalCodeController,
    required this.isFetchingLocation,
    required this.onCountryCodeChanged,
    required this.onPostalCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPostalCodeRow(context);
  }

  Widget _buildPostalCodeRow(BuildContext context) {
    final sortedCountryCodes = LocationUtils.supportedCountries.keys.toList()
      ..sort((a, b) {
        if (a == 'DE') return -1;
        if (b == 'DE') return 1;
        return a.compareTo(b);
      });

    return Row(
      children: [
        SizedBox(
          width: 95,
          child: DropdownButtonFormField<String>(
            initialValue: selectedCountryCode,
            selectedItemBuilder: (BuildContext context) {
              return sortedCountryCodes.map<Widget>((String key) {
                return Text(key);
              }).toList();
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.country,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            ),
            items: sortedCountryCodes.map((code) {
              return DropdownMenuItem(
                value: code,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 300),
                  child: Text(
                    '$code (${LocationUtils.getCountryName(context, code)})',
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ),
              );
            }).toList(),
            onChanged: onCountryCodeChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: postalCodeController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.postalCode,
              border: const OutlineInputBorder(),
              suffixIcon: isFetchingLocation
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
            keyboardType: TextInputType.text,
            onChanged: onPostalCodeChanged,
          ),
        ),
      ],
    );
  }
}
