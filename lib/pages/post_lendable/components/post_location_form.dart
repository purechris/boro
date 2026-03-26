import 'package:flutter/material.dart';
import 'package:verleihapp/utils/location_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Location fields for the post lendable page.
class PostLocationForm extends StatelessWidget {
  final bool useCustomLocation;
  final String selectedCountryCode;
  final TextEditingController postalCodeController;
  final TextEditingController locationController;
  final FocusNode postalCodeFocusNode;
  final bool isFetchingLocation;
  final Function(bool) onUseCustomLocationChanged;
  final Function(String?) onCountryCodeChanged;
  final Function(String) onPostalCodeChanged;
  final VoidCallback onTriggerLocationLookup;

  const PostLocationForm({
    super.key,
    required this.useCustomLocation,
    required this.selectedCountryCode,
    required this.postalCodeController,
    required this.locationController,
    required this.postalCodeFocusNode,
    required this.isFetchingLocation,
    required this.onUseCustomLocationChanged,
    required this.onCountryCodeChanged,
    required this.onPostalCodeChanged,
    required this.onTriggerLocationLookup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLocationToggle(context),
        if (useCustomLocation) ...[
          const SizedBox(height: 16),
          _buildPostalCodeRow(context),
          const SizedBox(height: 16),
          _buildLocationField(context),
        ],
      ],
    );
  }

  Widget _buildLocationToggle(BuildContext context) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.differentLocation),
      subtitle: Text(
        AppLocalizations.of(context)!.differentLocationHint,
        style: const TextStyle(fontSize: 12),
      ),
      value: useCustomLocation,
      onChanged: onUseCustomLocationChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLocationField(BuildContext context) {
    return IgnorePointer(
      child: TextFormField(
        controller: locationController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.cityLocation,
          border: const OutlineInputBorder(),
          helperText: AppLocalizations.of(context)!.optionalLocationHint,
          fillColor: Colors.grey[100],
          filled: true,
        ),
      ),
    );
  }

  Widget _buildPostalCodeRow(BuildContext context) {
    // Sort country codes: DE first, then alphabetically
    final sortedCountryCodes = LocationUtils.supportedCountries.keys.toList()
      ..sort((a, b) {
        if (a == 'DE') return -1;
        if (b == 'DE') return 1;
        return a.compareTo(b);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                focusNode: postalCodeFocusNode,
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
                      : IconButton(
                          icon: const Icon(Icons.search),
                          tooltip: AppLocalizations.of(context)!.search,
                          onPressed: isFetchingLocation ? null : onTriggerLocationLookup,
                        ),
                ),
                keyboardType: TextInputType.text,
                onChanged: onPostalCodeChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
