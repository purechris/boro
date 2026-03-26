import 'package:flutter/material.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class CategoryModel {
  String name;
  String iconPath;

  CategoryModel({
    required this.name,
    required this.iconPath,
  });

  /// Get the localized name for this category.
  /// The name field remains unchanged (German name from the database).
  String getLocalizedName(BuildContext context) {
    return CategoryModel.getLocalizedNameForCategory(context, name);
  }

  /// Static method to convert a category name (German from DB) to its localized name.
  static String getLocalizedNameForCategory(BuildContext context, String categoryName) {
    final l10n = AppLocalizations.of(context)!;
    switch (categoryName) {
      case 'Camping':
        return l10n.categoryCamping;
      case 'Fahrrad':
        return l10n.categoryFahrrad;
      case 'Werkzeug':
        return l10n.categoryWerkzeug;
      case 'Reisen':
        return l10n.categoryReisen;
      case 'Haushalt':
        return l10n.categoryHaushalt;
      case 'Musik':
        return l10n.categoryMusik;
      case 'Bücher':
        return l10n.categoryBuecher;
      case 'Sport':
        return l10n.categorySport;
      case 'Küche':
        return l10n.categoryKueche;
      case 'Spiele':
        return l10n.categorySpiele;
      case 'Fotografie':
        return l10n.categoryFotografie;
      case 'Umzug':
        return l10n.categoryUmzug;
      case 'Technik':
        return l10n.categoryTechnik;
      case 'Sonstiges':
        return l10n.categorySonstiges;
      default:
        return categoryName; // Fallback: original name if no translation found
    }
  }

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: 'Camping', 
        iconPath: 'assets/icons/camping-tent-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Fahrrad', 
        iconPath: 'assets/icons/bike-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Werkzeug', 
        iconPath: 'assets/icons/tools-hammer-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Reisen', 
        iconPath: 'assets/icons/travel-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Haushalt', 
        iconPath: 'assets/icons/light-bulb-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Technik', 
        iconPath: 'assets/icons/computer-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Musik', 
        iconPath: 'assets/icons/speaker-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Bücher', 
        iconPath: 'assets/icons/book-opened-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Sport', 
        iconPath: 'assets/icons/tennis-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Küche', 
        iconPath: 'assets/icons/kitchen-cooker-utensils-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Spiele', 
        iconPath: 'assets/icons/board-games-set-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Fotografie', 
        iconPath: 'assets/icons/camera-svgrepo-com.svg'
      )
    );

    categories.add(
      CategoryModel(
        name: 'Umzug', 
        iconPath: 'assets/icons/transporter-svgrepo-com.svg'
      )
    );

    // Kategorie "Sonstiges"
    categories.add(
      CategoryModel(
        name: 'Sonstiges', 
        iconPath: 'assets/icons/box-svgrepo-com.svg'
      )
    );
    

    return categories;
  }
}