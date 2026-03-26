import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// Der Titel der App
  ///
  /// In de, this message translates to:
  /// **'Boro'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In de, this message translates to:
  /// **'Ausloggen'**
  String get logout;

  /// No description provided for @delete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @lendTo.
  ///
  /// In de, this message translates to:
  /// **'Verleihen an...'**
  String get lendTo;

  /// No description provided for @retrieveItem.
  ///
  /// In de, this message translates to:
  /// **'Zurückholen'**
  String get retrieveItem;

  /// No description provided for @retrieveItemQuestion.
  ///
  /// In de, this message translates to:
  /// **'Zurückholen?'**
  String get retrieveItemQuestion;

  /// No description provided for @lendToTitle.
  ///
  /// In de, this message translates to:
  /// **'Verleihen an...'**
  String get lendToTitle;

  /// No description provided for @lendToHint.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get lendToHint;

  /// No description provided for @enterBorrowerName.
  ///
  /// In de, this message translates to:
  /// **'Bitte einen Namen eingeben'**
  String get enterBorrowerName;

  /// No description provided for @markAsReturned.
  ///
  /// In de, this message translates to:
  /// **'Als zurückgegeben markieren'**
  String get markAsReturned;

  /// No description provided for @borrowedBadge.
  ///
  /// In de, this message translates to:
  /// **'VERLIEHEN'**
  String get borrowedBadge;

  /// No description provided for @borrowedBy.
  ///
  /// In de, this message translates to:
  /// **'Verliehen an {name}'**
  String borrowedBy(String name);

  /// No description provided for @error.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get error;

  /// No description provided for @noItemsFound.
  ///
  /// In de, this message translates to:
  /// **'Keine Artikel gefunden.'**
  String get noItemsFound;

  /// No description provided for @profileEdit.
  ///
  /// In de, this message translates to:
  /// **'Profil bearbeiten'**
  String get profileEdit;

  /// No description provided for @passwordChange.
  ///
  /// In de, this message translates to:
  /// **'Passwort ändern'**
  String get passwordChange;

  /// No description provided for @category.
  ///
  /// In de, this message translates to:
  /// **'Kategorie'**
  String get category;

  /// No description provided for @description.
  ///
  /// In de, this message translates to:
  /// **'Beschreibung'**
  String get description;

  /// No description provided for @location.
  ///
  /// In de, this message translates to:
  /// **'Ort'**
  String get location;

  /// No description provided for @saving.
  ///
  /// In de, this message translates to:
  /// **'Wird gespeichert...'**
  String get saving;

  /// No description provided for @add.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get add;

  /// No description provided for @loading.
  ///
  /// In de, this message translates to:
  /// **'Lädt...'**
  String get loading;

  /// No description provided for @articleDelete.
  ///
  /// In de, this message translates to:
  /// **'Artikel löschen'**
  String get articleDelete;

  /// No description provided for @noUserDataAvailable.
  ///
  /// In de, this message translates to:
  /// **'Keine Benutzerdaten verfügbar.'**
  String get noUserDataAvailable;

  /// No description provided for @errorLoadingUser.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Laden des Benutzers'**
  String errorLoadingUser(String error);

  /// No description provided for @errorLoadingData.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Laden der Daten'**
  String get errorLoadingData;

  /// No description provided for @noDataFound.
  ///
  /// In de, this message translates to:
  /// **'Keine Daten gefunden'**
  String get noDataFound;

  /// No description provided for @addFriends.
  ///
  /// In de, this message translates to:
  /// **'Freunde hinzufügen'**
  String get addFriends;

  /// No description provided for @addFriendsNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt Freunde hinzufügen'**
  String get addFriendsNow;

  /// No description provided for @removeFriendConfirm.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du diesen Freund wirklich entfernen?'**
  String get removeFriendConfirm;

  /// No description provided for @cancelFriendRequestConfirm.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du diese Freundschaftsanfrage wirklich stornieren?'**
  String get cancelFriendRequestConfirm;

  /// No description provided for @rejectFriendRequestConfirm.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du diese Freundschaftsanfrage wirklich ablehnen?'**
  String get rejectFriendRequestConfirm;

  /// No description provided for @selectCategory.
  ///
  /// In de, this message translates to:
  /// **'Bitte eine Kategorie auswählen'**
  String get selectCategory;

  /// No description provided for @descriptionMaxLength.
  ///
  /// In de, this message translates to:
  /// **'Die Beschreibung darf höchstens 500 Zeichen lang sein'**
  String get descriptionMaxLength;

  /// No description provided for @optional.
  ///
  /// In de, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @optionalLocation.
  ///
  /// In de, this message translates to:
  /// **'Ort (optional)'**
  String get optionalLocation;

  /// No description provided for @optionalLocationHint.
  ///
  /// In de, this message translates to:
  /// **''**
  String get optionalLocationHint;

  /// No description provided for @optionalDescription.
  ///
  /// In de, this message translates to:
  /// **'Beschreibung (optional)'**
  String get optionalDescription;

  /// No description provided for @profileIncomplete.
  ///
  /// In de, this message translates to:
  /// **'Dein Profil ist noch unvollständig. Füge jetzt weitere Infos hinzu!'**
  String get profileIncomplete;

  /// No description provided for @aboutMe.
  ///
  /// In de, this message translates to:
  /// **'Über mich'**
  String get aboutMe;

  /// No description provided for @cityLocation.
  ///
  /// In de, this message translates to:
  /// **'Stadt/Ort (automatisch ermittelt)'**
  String get cityLocation;

  /// No description provided for @cityLocationHint.
  ///
  /// In de, this message translates to:
  /// **''**
  String get cityLocationHint;

  /// No description provided for @cityNoNumbers.
  ///
  /// In de, this message translates to:
  /// **'Der Ort darf keine Zahl sein'**
  String get cityNoNumbers;

  /// No description provided for @contact.
  ///
  /// In de, this message translates to:
  /// **'Kontaktmöglichkeit'**
  String get contact;

  /// No description provided for @contactHint.
  ///
  /// In de, this message translates to:
  /// **'z. B. E-Mail-Adresse oder Telefonnummer'**
  String get contactHint;

  /// No description provided for @profileSaving.
  ///
  /// In de, this message translates to:
  /// **'Profil wird gespeichert...'**
  String get profileSaving;

  /// No description provided for @feedback.
  ///
  /// In de, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @feedbackTitle.
  ///
  /// In de, this message translates to:
  /// **'Wir freuen uns über dein Feedback!'**
  String get feedbackTitle;

  /// No description provided for @feedbackMessage.
  ///
  /// In de, this message translates to:
  /// **'Deine Meinung ist uns wichtig und hilft uns, die App weiter zu verbessern. Melde dich gern bei uns, wenn Fehler auftreten, Übersetzungen verbessert werden können oder wenn du Verbesserungsvorschläge/Funktionswünsche hast.'**
  String get feedbackMessage;

  /// No description provided for @contactUs.
  ///
  /// In de, this message translates to:
  /// **'Kontaktiere uns:'**
  String get contactUs;

  /// No description provided for @copyEmailHint.
  ///
  /// In de, this message translates to:
  /// **'Kopiere die E-Mail-Adresse und schreibe uns eine Nachricht.'**
  String get copyEmailHint;

  /// No description provided for @supportDeveloper.
  ///
  /// In de, this message translates to:
  /// **'Entwickler unterstützen'**
  String get supportDeveloper;

  /// No description provided for @legal.
  ///
  /// In de, this message translates to:
  /// **'Rechtliches'**
  String get legal;

  /// No description provided for @privacyPolicy.
  ///
  /// In de, this message translates to:
  /// **'Datenschutzerklärung'**
  String get privacyPolicy;

  /// No description provided for @imprint.
  ///
  /// In de, this message translates to:
  /// **'Impressum'**
  String get imprint;

  /// No description provided for @account.
  ///
  /// In de, this message translates to:
  /// **'Konto'**
  String get account;

  /// No description provided for @changePassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort ändern'**
  String get changePassword;

  /// No description provided for @passwordReset.
  ///
  /// In de, this message translates to:
  /// **'Passwort zurücksetzen'**
  String get passwordReset;

  /// No description provided for @linkCouldNotOpen.
  ///
  /// In de, this message translates to:
  /// **'Link konnte nicht geöffnet werden: {url}'**
  String linkCouldNotOpen(String url);

  /// No description provided for @navStart.
  ///
  /// In de, this message translates to:
  /// **'Start'**
  String get navStart;

  /// No description provided for @navFavorites.
  ///
  /// In de, this message translates to:
  /// **'Favoriten'**
  String get navFavorites;

  /// No description provided for @navLend.
  ///
  /// In de, this message translates to:
  /// **'Verleihen'**
  String get navLend;

  /// No description provided for @navFriends.
  ///
  /// In de, this message translates to:
  /// **'Freunde'**
  String get navFriends;

  /// No description provided for @navMine.
  ///
  /// In de, this message translates to:
  /// **'Meins'**
  String get navMine;

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get language;

  /// No description provided for @languageGerman.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageEnglish.
  ///
  /// In de, this message translates to:
  /// **'Englisch'**
  String get languageEnglish;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @register.
  ///
  /// In de, this message translates to:
  /// **'Registrieren'**
  String get register;

  /// No description provided for @signIn.
  ///
  /// In de, this message translates to:
  /// **'Einloggen'**
  String get signIn;

  /// No description provided for @tryDemo.
  ///
  /// In de, this message translates to:
  /// **'Demo ausprobieren'**
  String get tryDemo;

  /// No description provided for @demoModeReadOnly.
  ///
  /// In de, this message translates to:
  /// **'Im Demo-Modus ist diese Aktion deaktiviert'**
  String get demoModeReadOnly;

  /// No description provided for @slide1Text.
  ///
  /// In de, this message translates to:
  /// **'Teile deine Sachen mit Freunden und Familie'**
  String get slide1Text;

  /// No description provided for @slide2Text.
  ///
  /// In de, this message translates to:
  /// **'Verleihe Werkzeug, Campingausrüstung und mehr'**
  String get slide2Text;

  /// No description provided for @slide3Text.
  ///
  /// In de, this message translates to:
  /// **'Spare Geld und schone die Umwelt'**
  String get slide3Text;

  /// No description provided for @emailAddress.
  ///
  /// In de, this message translates to:
  /// **'E-Mail Adresse'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get password;

  /// No description provided for @passwordForgotten.
  ///
  /// In de, this message translates to:
  /// **'Passwort vergessen?'**
  String get passwordForgotten;

  /// No description provided for @reset.
  ///
  /// In de, this message translates to:
  /// **'Zurücksetzen'**
  String get reset;

  /// No description provided for @noAccountYet.
  ///
  /// In de, this message translates to:
  /// **'Du hast noch keinen Account? '**
  String get noAccountYet;

  /// No description provided for @accountAlreadyExists.
  ///
  /// In de, this message translates to:
  /// **'Konto bereits vorhanden? '**
  String get accountAlreadyExists;

  /// No description provided for @displayName.
  ///
  /// In de, this message translates to:
  /// **'Anzeigename'**
  String get displayName;

  /// No description provided for @displayNameHint.
  ///
  /// In de, this message translates to:
  /// **'Dieser Name wird anderen Nutzern angezeigt'**
  String get displayNameHint;

  /// No description provided for @displayNameRequired.
  ///
  /// In de, this message translates to:
  /// **'Anzeigename ist erforderlich'**
  String get displayNameRequired;

  /// No description provided for @displayNameMinLength.
  ///
  /// In de, this message translates to:
  /// **'Der Anzeigename muss mindestens 3 Zeichen lang sein'**
  String get displayNameMinLength;

  /// No description provided for @emailRequired.
  ///
  /// In de, this message translates to:
  /// **'E-Mail-Adresse ist erforderlich'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In de, this message translates to:
  /// **'Bitte gültige E-Mail-Adresse eingeben'**
  String get emailInvalid;

  /// No description provided for @passwordMinLength.
  ///
  /// In de, this message translates to:
  /// **'Mindestens 8 Zeichen, max 72. Muss Großbuchstaben, Kleinbuchstaben und Ziffern enthalten.'**
  String get passwordMinLength;

  /// No description provided for @passwordRequired.
  ///
  /// In de, this message translates to:
  /// **'Passwort ist erforderlich'**
  String get passwordRequired;

  /// No description provided for @passwordMinLengthError.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort muss mindestens 8 Zeichen lang sein'**
  String get passwordMinLengthError;

  /// No description provided for @passwordMaxLengthError.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort darf höchstens 72 Zeichen lang sein'**
  String get passwordMaxLengthError;

  /// No description provided for @passwordMissingLowercase.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort muss mindestens einen Kleinbuchstaben (a-z) enthalten'**
  String get passwordMissingLowercase;

  /// No description provided for @passwordMissingUppercase.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort muss mindestens einen Großbuchstaben (A-Z) enthalten'**
  String get passwordMissingUppercase;

  /// No description provided for @passwordMissingDigits.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort muss mindestens eine Ziffer (0-9) enthalten'**
  String get passwordMissingDigits;

  /// No description provided for @passwordTooShort.
  ///
  /// In de, this message translates to:
  /// **'Zu kurz'**
  String get passwordTooShort;

  /// No description provided for @passwordTooLong.
  ///
  /// In de, this message translates to:
  /// **'Zu lang (max 72 Zeichen)'**
  String get passwordTooLong;

  /// No description provided for @passwordNeedsLowercase.
  ///
  /// In de, this message translates to:
  /// **'Benötigt Kleinbuchstaben'**
  String get passwordNeedsLowercase;

  /// No description provided for @passwordNeedsUppercase.
  ///
  /// In de, this message translates to:
  /// **'Benötigt Großbuchstaben'**
  String get passwordNeedsUppercase;

  /// No description provided for @passwordNeedsDigits.
  ///
  /// In de, this message translates to:
  /// **'Benötigt Ziffer'**
  String get passwordNeedsDigits;

  /// No description provided for @emailAndPasswordRequired.
  ///
  /// In de, this message translates to:
  /// **'E-Mail Adresse und Passwort sind erforderlich'**
  String get emailAndPasswordRequired;

  /// No description provided for @lendNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt Artikel verleihen'**
  String get lendNow;

  /// No description provided for @createFirstItems.
  ///
  /// In de, this message translates to:
  /// **'Erstelle deine ersten 3 Artikel, die du verleihen möchtest! Oder füge Freunde hinzu, um dein Netzwerk zu erweitern!'**
  String get createFirstItems;

  /// No description provided for @noResultsFound.
  ///
  /// In de, this message translates to:
  /// **'Keine Ergebnisse gefunden'**
  String get noResultsFound;

  /// No description provided for @tryOtherSearchTerms.
  ///
  /// In de, this message translates to:
  /// **'Versuche es mit anderen Suchbegriffen oder Filtereinstellungen'**
  String get tryOtherSearchTerms;

  /// No description provided for @searchResults.
  ///
  /// In de, this message translates to:
  /// **'Suchergebnisse'**
  String get searchResults;

  /// No description provided for @quickFilter.
  ///
  /// In de, this message translates to:
  /// **'Schnellfilter'**
  String get quickFilter;

  /// No description provided for @categories.
  ///
  /// In de, this message translates to:
  /// **'Kategorien'**
  String get categories;

  /// No description provided for @search.
  ///
  /// In de, this message translates to:
  /// **'Suchen...'**
  String get search;

  /// No description provided for @searchItems.
  ///
  /// In de, this message translates to:
  /// **'Artikel durchsuchen'**
  String get searchItems;

  /// No description provided for @app.
  ///
  /// In de, this message translates to:
  /// **'App'**
  String get app;

  /// No description provided for @myProfile.
  ///
  /// In de, this message translates to:
  /// **'Mein Profil'**
  String get myProfile;

  /// No description provided for @myAds.
  ///
  /// In de, this message translates to:
  /// **'Meine Anzeigen'**
  String get myAds;

  /// No description provided for @editProfileTooltip.
  ///
  /// In de, this message translates to:
  /// **'Profil bearbeiten'**
  String get editProfileTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settingsTooltip;

  /// No description provided for @articleDeletedSuccess.
  ///
  /// In de, this message translates to:
  /// **'Artikel erfolgreich gelöscht'**
  String get articleDeletedSuccess;

  /// No description provided for @addArticle.
  ///
  /// In de, this message translates to:
  /// **'Artikel hinzufügen'**
  String get addArticle;

  /// No description provided for @editArticle.
  ///
  /// In de, this message translates to:
  /// **'Artikel bearbeiten'**
  String get editArticle;

  /// No description provided for @title.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get title;

  /// No description provided for @titleRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte einen Titel eingeben'**
  String get titleRequired;

  /// No description provided for @titleMinLength.
  ///
  /// In de, this message translates to:
  /// **'Der Titel muss mindestens 5 Zeichen lang sein'**
  String get titleMinLength;

  /// No description provided for @titleMaxLength.
  ///
  /// In de, this message translates to:
  /// **'Der Titel darf höchstens 50 Zeichen lang sein'**
  String get titleMaxLength;

  /// No description provided for @visibility.
  ///
  /// In de, this message translates to:
  /// **'Sichtbarkeit'**
  String get visibility;

  /// No description provided for @friendsOfFriends.
  ///
  /// In de, this message translates to:
  /// **'Freunde von Freunden'**
  String get friendsOfFriends;

  /// No description provided for @directFriends.
  ///
  /// In de, this message translates to:
  /// **'Direkte Freunde'**
  String get directFriends;

  /// No description provided for @private.
  ///
  /// In de, this message translates to:
  /// **'Privat'**
  String get private;

  /// No description provided for @version.
  ///
  /// In de, this message translates to:
  /// **'Version {version} ({platform})'**
  String version(String version, String platform);

  /// No description provided for @web.
  ///
  /// In de, this message translates to:
  /// **'Web'**
  String get web;

  /// No description provided for @android.
  ///
  /// In de, this message translates to:
  /// **'Android'**
  String get android;

  /// No description provided for @noFavoritesYet.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Favoriten vorhanden. Durchsuche die Artikel und füge deine Favoriten hinzu!'**
  String get noFavoritesYet;

  /// No description provided for @addFirstItems.
  ///
  /// In de, this message translates to:
  /// **'Füge deine ersten 3 Artikel hinzu, die du verleihen möchtest!'**
  String get addFirstItems;

  /// No description provided for @displayNameUnique.
  ///
  /// In de, this message translates to:
  /// **'Der Name sollte für deine Freunde eindeutig sein'**
  String get displayNameUnique;

  /// No description provided for @nameRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte einen Namen eingeben'**
  String get nameRequired;

  /// No description provided for @nameMinLength.
  ///
  /// In de, this message translates to:
  /// **'Der Name muss mindestens 5 Zeichen lang sein'**
  String get nameMinLength;

  /// No description provided for @nameMaxLength.
  ///
  /// In de, this message translates to:
  /// **'Der Name darf höchstens 20 Zeichen lang sein'**
  String get nameMaxLength;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In de, this message translates to:
  /// **'Profil erfolgreich aktualisiert'**
  String get profileUpdatedSuccess;

  /// No description provided for @friends.
  ///
  /// In de, this message translates to:
  /// **'Freunde'**
  String get friends;

  /// No description provided for @yourFriends.
  ///
  /// In de, this message translates to:
  /// **'Deine Freunde'**
  String get yourFriends;

  /// No description provided for @addFriendsTab.
  ///
  /// In de, this message translates to:
  /// **'Freunde hinzufügen'**
  String get addFriendsTab;

  /// No description provided for @friendCodeOrEmail.
  ///
  /// In de, this message translates to:
  /// **'Freundescode oder E-Mail Adresse'**
  String get friendCodeOrEmail;

  /// No description provided for @yourFriendCode.
  ///
  /// In de, this message translates to:
  /// **'Dein Freundescode zum Teilen'**
  String get yourFriendCode;

  /// No description provided for @share.
  ///
  /// In de, this message translates to:
  /// **'Teilen'**
  String get share;

  /// No description provided for @copy.
  ///
  /// In de, this message translates to:
  /// **'Kopieren'**
  String get copy;

  /// No description provided for @removeFriend.
  ///
  /// In de, this message translates to:
  /// **'Freund entfernen'**
  String get removeFriend;

  /// No description provided for @removeFriendTitle.
  ///
  /// In de, this message translates to:
  /// **'Freund entfernen'**
  String get removeFriendTitle;

  /// No description provided for @remove.
  ///
  /// In de, this message translates to:
  /// **'Entfernen'**
  String get remove;

  /// No description provided for @cancelRequest.
  ///
  /// In de, this message translates to:
  /// **'Anfrage stornieren'**
  String get cancelRequest;

  /// No description provided for @cancelRequestTitle.
  ///
  /// In de, this message translates to:
  /// **'Anfrage stornieren'**
  String get cancelRequestTitle;

  /// No description provided for @receivedRequests.
  ///
  /// In de, this message translates to:
  /// **'Empfangene Freundschaftsanfragen'**
  String get receivedRequests;

  /// No description provided for @sentRequests.
  ///
  /// In de, this message translates to:
  /// **'Gesendete Freundschaftsanfragen'**
  String get sentRequests;

  /// No description provided for @rejectRequest.
  ///
  /// In de, this message translates to:
  /// **'Anfrage ablehnen'**
  String get rejectRequest;

  /// No description provided for @rejectRequestTitle.
  ///
  /// In de, this message translates to:
  /// **'Anfrage ablehnen'**
  String get rejectRequestTitle;

  /// No description provided for @accept.
  ///
  /// In de, this message translates to:
  /// **'Annehmen'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In de, this message translates to:
  /// **'Ablehnen'**
  String get reject;

  /// No description provided for @requestSent.
  ///
  /// In de, this message translates to:
  /// **'Freundschaftsanfrage wurde gesendet!'**
  String get requestSent;

  /// No description provided for @requestAccepted.
  ///
  /// In de, this message translates to:
  /// **'Freundschaftsanfrage angenommen'**
  String get requestAccepted;

  /// No description provided for @requestRejected.
  ///
  /// In de, this message translates to:
  /// **'Freundschaftsanfrage abgelehnt'**
  String get requestRejected;

  /// No description provided for @requestCancelled.
  ///
  /// In de, this message translates to:
  /// **'Freundschaftsanfrage storniert'**
  String get requestCancelled;

  /// No description provided for @shareFriendCodeText.
  ///
  /// In de, this message translates to:
  /// **'Teile deinen Freundescode z. B. in einer Gruppe mit Freunden, Kollegen oder Nachbarn, um dein Netzwerk zu erweitern!'**
  String get shareFriendCodeText;

  /// No description provided for @friendCodeCopied.
  ///
  /// In de, this message translates to:
  /// **'Freundescode in die Zwischenablage kopiert'**
  String get friendCodeCopied;

  /// No description provided for @noAdsYet.
  ///
  /// In de, this message translates to:
  /// **'Keine Anzeigen vorhanden'**
  String get noAdsYet;

  /// No description provided for @userHasNoAds.
  ///
  /// In de, this message translates to:
  /// **'Dieser Benutzer hat noch keine Anzeigen erstellt'**
  String get userHasNoAds;

  /// No description provided for @currentAds.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Anzeigen'**
  String get currentAds;

  /// No description provided for @profile.
  ///
  /// In de, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @friend.
  ///
  /// In de, this message translates to:
  /// **'Befreundet'**
  String get friend;

  /// No description provided for @requestPending.
  ///
  /// In de, this message translates to:
  /// **'Anfrage ausstehend'**
  String get requestPending;

  /// No description provided for @addAsFriend.
  ///
  /// In de, this message translates to:
  /// **'Als Freund hinzufügen'**
  String get addAsFriend;

  /// No description provided for @filter.
  ///
  /// In de, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @resetFilters.
  ///
  /// In de, this message translates to:
  /// **'Zurücksetzen'**
  String get resetFilters;

  /// No description provided for @sorting.
  ///
  /// In de, this message translates to:
  /// **'Sortierung'**
  String get sorting;

  /// No description provided for @newest.
  ///
  /// In de, this message translates to:
  /// **'Neueste zuerst'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In de, this message translates to:
  /// **'Älteste zuerst'**
  String get oldest;

  /// No description provided for @alphabetical.
  ///
  /// In de, this message translates to:
  /// **'Alphabetisch'**
  String get alphabetical;

  /// No description provided for @all.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get all;

  /// No description provided for @country.
  ///
  /// In de, this message translates to:
  /// **'Land'**
  String get country;

  /// No description provided for @country_DE.
  ///
  /// In de, this message translates to:
  /// **'Deutschland'**
  String get country_DE;

  /// No description provided for @country_AT.
  ///
  /// In de, this message translates to:
  /// **'Österreich'**
  String get country_AT;

  /// No description provided for @country_CH.
  ///
  /// In de, this message translates to:
  /// **'Schweiz'**
  String get country_CH;

  /// No description provided for @country_GB.
  ///
  /// In de, this message translates to:
  /// **'United Kingdom'**
  String get country_GB;

  /// No description provided for @country_IE.
  ///
  /// In de, this message translates to:
  /// **'Irland'**
  String get country_IE;

  /// No description provided for @country_US.
  ///
  /// In de, this message translates to:
  /// **'USA'**
  String get country_US;

  /// No description provided for @country_CA.
  ///
  /// In de, this message translates to:
  /// **'Kanada'**
  String get country_CA;

  /// No description provided for @country_AU.
  ///
  /// In de, this message translates to:
  /// **'Australien'**
  String get country_AU;

  /// No description provided for @country_NZ.
  ///
  /// In de, this message translates to:
  /// **'Neuseeland'**
  String get country_NZ;

  /// No description provided for @country_NO.
  ///
  /// In de, this message translates to:
  /// **'Norwegen'**
  String get country_NO;

  /// No description provided for @country_SE.
  ///
  /// In de, this message translates to:
  /// **'Schweden'**
  String get country_SE;

  /// No description provided for @country_PL.
  ///
  /// In de, this message translates to:
  /// **'Polen'**
  String get country_PL;

  /// No description provided for @country_CZ.
  ///
  /// In de, this message translates to:
  /// **'Tschechien'**
  String get country_CZ;

  /// No description provided for @country_NL.
  ///
  /// In de, this message translates to:
  /// **'Niederlande'**
  String get country_NL;

  /// No description provided for @country_BE.
  ///
  /// In de, this message translates to:
  /// **'Belgien'**
  String get country_BE;

  /// No description provided for @country_LU.
  ///
  /// In de, this message translates to:
  /// **'Luxemburg'**
  String get country_LU;

  /// No description provided for @country_FR.
  ///
  /// In de, this message translates to:
  /// **'Frankreich'**
  String get country_FR;

  /// No description provided for @country_IT.
  ///
  /// In de, this message translates to:
  /// **'Italien'**
  String get country_IT;

  /// No description provided for @country_ES.
  ///
  /// In de, this message translates to:
  /// **'Spanien'**
  String get country_ES;

  /// No description provided for @selectCountry.
  ///
  /// In de, this message translates to:
  /// **'Land auswählen'**
  String get selectCountry;

  /// No description provided for @differentLocation.
  ///
  /// In de, this message translates to:
  /// **'Alternativer Standort'**
  String get differentLocation;

  /// No description provided for @differentLocationHint.
  ///
  /// In de, this message translates to:
  /// **'Aktivieren, wenn der Artikel an einem anderen Ort steht als dein Profil-Standort.'**
  String get differentLocationHint;

  /// No description provided for @postalCode.
  ///
  /// In de, this message translates to:
  /// **'Postleitzahl'**
  String get postalCode;

  /// No description provided for @postalCodeOptional.
  ///
  /// In de, this message translates to:
  /// **'Postleitzahl (optional)'**
  String get postalCodeOptional;

  /// No description provided for @postalCodeFilterLabel.
  ///
  /// In de, this message translates to:
  /// **'Postleitzahl'**
  String get postalCodeFilterLabel;

  /// No description provided for @postalCodeFilterHint.
  ///
  /// In de, this message translates to:
  /// **'Z. B. 10115'**
  String get postalCodeFilterHint;

  /// No description provided for @maxDistanceLabel.
  ///
  /// In de, this message translates to:
  /// **'Maximale Entfernung'**
  String get maxDistanceLabel;

  /// No description provided for @distanceFilterTooltip.
  ///
  /// In de, this message translates to:
  /// **'Ausgehend von deinem Profil-Standort'**
  String get distanceFilterTooltip;

  /// No description provided for @distanceUnlimited.
  ///
  /// In de, this message translates to:
  /// **'Egal'**
  String get distanceUnlimited;

  /// No description provided for @distanceFilterLabel.
  ///
  /// In de, this message translates to:
  /// **'Entfernung'**
  String get distanceFilterLabel;

  /// No description provided for @distanceFilterValue.
  ///
  /// In de, this message translates to:
  /// **'{distance} km'**
  String distanceFilterValue(int distance);

  /// No description provided for @resetPasswordTitle.
  ///
  /// In de, this message translates to:
  /// **'Passwort zurücksetzen'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In de, this message translates to:
  /// **'Gib deine E-Mail-Adresse ein, um einen 6-stelligen Code zum Zurücksetzen deines Passworts zu erhalten.'**
  String get resetPasswordDescription;

  /// No description provided for @emailRequiredForReset.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib deine E-Mail-Adresse ein'**
  String get emailRequiredForReset;

  /// No description provided for @emailInvalidForReset.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib eine gültige E-Mail-Adresse ein'**
  String get emailInvalidForReset;

  /// No description provided for @sendCode.
  ///
  /// In de, this message translates to:
  /// **'Code senden'**
  String get sendCode;

  /// No description provided for @currentPassword.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Passwort'**
  String get currentPassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib dein aktuelles Passwort ein'**
  String get currentPasswordRequired;

  /// No description provided for @newPassword.
  ///
  /// In de, this message translates to:
  /// **'Neues Passwort'**
  String get newPassword;

  /// No description provided for @newPasswordRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib ein neues Passwort ein'**
  String get newPasswordRequired;

  /// No description provided for @confirmPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort bestätigen'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte bestätige dein neues Passwort'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In de, this message translates to:
  /// **'Die Passwörter stimmen nicht überein'**
  String get passwordsDoNotMatch;

  /// No description provided for @newPasswordSameAsOld.
  ///
  /// In de, this message translates to:
  /// **'Das neue Passwort muss sich vom alten unterscheiden'**
  String get newPasswordSameAsOld;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In de, this message translates to:
  /// **'Passwort erfolgreich geändert'**
  String get passwordChangedSuccess;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In de, this message translates to:
  /// **'Das aktuelle Passwort ist nicht korrekt'**
  String get currentPasswordIncorrect;

  /// No description provided for @userNotFound.
  ///
  /// In de, this message translates to:
  /// **'Benutzer nicht gefunden'**
  String get userNotFound;

  /// No description provided for @profileLoadError.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Laden des Profils'**
  String get profileLoadError;

  /// No description provided for @userCouldNotBeLoaded.
  ///
  /// In de, this message translates to:
  /// **'Der Benutzer konnte nicht geladen werden'**
  String get userCouldNotBeLoaded;

  /// No description provided for @offerType.
  ///
  /// In de, this message translates to:
  /// **'Angebotsart'**
  String get offerType;

  /// No description provided for @allOfferTypes.
  ///
  /// In de, this message translates to:
  /// **'Alle Angebotsarten'**
  String get allOfferTypes;

  /// No description provided for @selectSorting.
  ///
  /// In de, this message translates to:
  /// **'Bitte eine Sortierung auswählen'**
  String get selectSorting;

  /// No description provided for @selectType.
  ///
  /// In de, this message translates to:
  /// **'Bitte einen Typ auswählen'**
  String get selectType;

  /// No description provided for @applyFilter.
  ///
  /// In de, this message translates to:
  /// **'Filter anwenden'**
  String get applyFilter;

  /// No description provided for @enterCode.
  ///
  /// In de, this message translates to:
  /// **'Code eingeben'**
  String get enterCode;

  /// No description provided for @codeSentToEmail.
  ///
  /// In de, this message translates to:
  /// **'Ein 6-stelliger Code wurde an {email} gesendet. Bitte überprüfe dein Postfach.'**
  String codeSentToEmail(String email);

  /// No description provided for @verifyCode.
  ///
  /// In de, this message translates to:
  /// **'Code verifizieren'**
  String get verifyCode;

  /// No description provided for @enterFullCode.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib den vollständigen 6-stelligen Code ein'**
  String get enterFullCode;

  /// No description provided for @codeVerifiedMessage.
  ///
  /// In de, this message translates to:
  /// **'Bitte gebe ein neues Passwort ein. Der Code wurde erfolgreich verifiziert.'**
  String get codeVerifiedMessage;

  /// No description provided for @supportDeveloperTitle.
  ///
  /// In de, this message translates to:
  /// **'Unterstütze den Entwickler!'**
  String get supportDeveloperTitle;

  /// No description provided for @supportDeveloperText.
  ///
  /// In de, this message translates to:
  /// **'Wenn dir die App gefällt, kannst du mich mit einer Spende unterstützen :) Deine Unterstützung hilft mir, die Serverkosten zu decken und die App weiterzuentwickeln. Klicke auf den Button, um eine Spende über PayPal zu tätigen.'**
  String get supportDeveloperText;

  /// No description provided for @paypalDonateLink.
  ///
  /// In de, this message translates to:
  /// **'PayPal Spendenlink'**
  String get paypalDonateLink;

  /// No description provided for @thanksForSupport.
  ///
  /// In de, this message translates to:
  /// **'Danke für deine Unterstützung!'**
  String get thanksForSupport;

  /// No description provided for @offerTypeOffer.
  ///
  /// In de, this message translates to:
  /// **'Verleihe'**
  String get offerTypeOffer;

  /// No description provided for @offerTypeOfferCard.
  ///
  /// In de, this message translates to:
  /// **'Zu verleihen'**
  String get offerTypeOfferCard;

  /// No description provided for @offerTypeFree.
  ///
  /// In de, this message translates to:
  /// **'Verschenke'**
  String get offerTypeFree;

  /// No description provided for @offerTypeFreeCard.
  ///
  /// In de, this message translates to:
  /// **'Zu verschenken'**
  String get offerTypeFreeCard;

  /// No description provided for @offerTypeSearch.
  ///
  /// In de, this message translates to:
  /// **'Suche'**
  String get offerTypeSearch;

  /// No description provided for @offerTypeSearchCard.
  ///
  /// In de, this message translates to:
  /// **'Gesuch'**
  String get offerTypeSearchCard;

  /// No description provided for @offerTypeSell.
  ///
  /// In de, this message translates to:
  /// **'Verkaufe'**
  String get offerTypeSell;

  /// No description provided for @offerTypeSellCard.
  ///
  /// In de, this message translates to:
  /// **'Zu verkaufen'**
  String get offerTypeSellCard;

  /// No description provided for @newBadge.
  ///
  /// In de, this message translates to:
  /// **'NEU'**
  String get newBadge;

  /// No description provided for @badgeTopLenderTitle.
  ///
  /// In de, this message translates to:
  /// **'Top Verleiher'**
  String get badgeTopLenderTitle;

  /// No description provided for @badgeTopLenderDescription.
  ///
  /// In de, this message translates to:
  /// **'Mindestens 3 Artikel eingestellt'**
  String get badgeTopLenderDescription;

  /// No description provided for @badgeEarlyUserTitle.
  ///
  /// In de, this message translates to:
  /// **'Supporter'**
  String get badgeEarlyUserTitle;

  /// No description provided for @badgeEarlyUserDescription.
  ///
  /// In de, this message translates to:
  /// **'Von Anfang an dabei'**
  String get badgeEarlyUserDescription;

  /// No description provided for @badgeTopNetworkedTitle.
  ///
  /// In de, this message translates to:
  /// **'Gut vernetzt'**
  String get badgeTopNetworkedTitle;

  /// No description provided for @badgeTopNetworkedDescription.
  ///
  /// In de, this message translates to:
  /// **'5 oder mehr direkte Freunde'**
  String get badgeTopNetworkedDescription;

  /// No description provided for @details.
  ///
  /// In de, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @categoryLabel.
  ///
  /// In de, this message translates to:
  /// **'Kategorie:'**
  String get categoryLabel;

  /// No description provided for @offerTypeLabel.
  ///
  /// In de, this message translates to:
  /// **'Angebotstyp:'**
  String get offerTypeLabel;

  /// No description provided for @offerTypeFormLabel.
  ///
  /// In de, this message translates to:
  /// **'Angebotstyp'**
  String get offerTypeFormLabel;

  /// No description provided for @articleLocationLabel.
  ///
  /// In de, this message translates to:
  /// **'Artikelstandort:'**
  String get articleLocationLabel;

  /// No description provided for @postedOnLabel.
  ///
  /// In de, this message translates to:
  /// **'Eingestellt am:'**
  String get postedOnLabel;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In de, this message translates to:
  /// **'- Keine Beschreibung vorhanden -'**
  String get noDescriptionAvailable;

  /// No description provided for @memberSince.
  ///
  /// In de, this message translates to:
  /// **'Mitglied seit'**
  String get memberSince;

  /// No description provided for @week.
  ///
  /// In de, this message translates to:
  /// **'Woche'**
  String get week;

  /// No description provided for @weeks.
  ///
  /// In de, this message translates to:
  /// **'Wochen'**
  String get weeks;

  /// No description provided for @month.
  ///
  /// In de, this message translates to:
  /// **'Monat'**
  String get month;

  /// No description provided for @months.
  ///
  /// In de, this message translates to:
  /// **'Monaten'**
  String get months;

  /// No description provided for @year.
  ///
  /// In de, this message translates to:
  /// **'Jahr'**
  String get year;

  /// No description provided for @years.
  ///
  /// In de, this message translates to:
  /// **'Jahren'**
  String get years;

  /// No description provided for @people.
  ///
  /// In de, this message translates to:
  /// **'Personen'**
  String get people;

  /// No description provided for @direct.
  ///
  /// In de, this message translates to:
  /// **'direkt'**
  String get direct;

  /// No description provided for @indirect.
  ///
  /// In de, this message translates to:
  /// **'indirekt'**
  String get indirect;

  /// No description provided for @mutualFriends.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsame Freunde: '**
  String get mutualFriends;

  /// No description provided for @categoryCamping.
  ///
  /// In de, this message translates to:
  /// **'Camping'**
  String get categoryCamping;

  /// No description provided for @categoryFahrrad.
  ///
  /// In de, this message translates to:
  /// **'Fahrrad'**
  String get categoryFahrrad;

  /// No description provided for @categoryWerkzeug.
  ///
  /// In de, this message translates to:
  /// **'Werkzeug'**
  String get categoryWerkzeug;

  /// No description provided for @categoryReisen.
  ///
  /// In de, this message translates to:
  /// **'Reisen'**
  String get categoryReisen;

  /// No description provided for @categoryHaushalt.
  ///
  /// In de, this message translates to:
  /// **'Haushalt'**
  String get categoryHaushalt;

  /// No description provided for @categoryMusik.
  ///
  /// In de, this message translates to:
  /// **'Musik'**
  String get categoryMusik;

  /// No description provided for @categoryBuecher.
  ///
  /// In de, this message translates to:
  /// **'Bücher'**
  String get categoryBuecher;

  /// No description provided for @categorySport.
  ///
  /// In de, this message translates to:
  /// **'Sport'**
  String get categorySport;

  /// No description provided for @categoryKueche.
  ///
  /// In de, this message translates to:
  /// **'Küche'**
  String get categoryKueche;

  /// No description provided for @categorySpiele.
  ///
  /// In de, this message translates to:
  /// **'Spiele'**
  String get categorySpiele;

  /// No description provided for @categoryFotografie.
  ///
  /// In de, this message translates to:
  /// **'Fotografie'**
  String get categoryFotografie;

  /// No description provided for @categoryUmzug.
  ///
  /// In de, this message translates to:
  /// **'Umzug'**
  String get categoryUmzug;

  /// No description provided for @categoryTechnik.
  ///
  /// In de, this message translates to:
  /// **'Technik'**
  String get categoryTechnik;

  /// No description provided for @categorySonstiges.
  ///
  /// In de, this message translates to:
  /// **'Sonstiges'**
  String get categorySonstiges;

  /// No description provided for @articleSavedSuccessTitle.
  ///
  /// In de, this message translates to:
  /// **'Supi!'**
  String get articleSavedSuccessTitle;

  /// No description provided for @articleSavedSuccessMessage.
  ///
  /// In de, this message translates to:
  /// **'Dein Eintrag wurde erfolgreich gespeichert! :)'**
  String get articleSavedSuccessMessage;

  /// No description provided for @continueButton.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get continueButton;

  /// No description provided for @visibilityLabel.
  ///
  /// In de, this message translates to:
  /// **'Sichtbarkeit:'**
  String get visibilityLabel;

  /// No description provided for @deleteArticleConfirm.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du diesen Artikel wirklich löschen?'**
  String get deleteArticleConfirm;

  /// No description provided for @errorOccurred.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein Fehler aufgetreten'**
  String get errorOccurred;

  /// No description provided for @emailNotConfirmed.
  ///
  /// In de, this message translates to:
  /// **'Bitte bestätige deine E-Mail-Adresse, um dich anzumelden.'**
  String get emailNotConfirmed;

  /// No description provided for @invalidCredentials.
  ///
  /// In de, this message translates to:
  /// **'Ungültige E-Mail-Adresse oder Passwort'**
  String get invalidCredentials;

  /// No description provided for @invalidImageType.
  ///
  /// In de, this message translates to:
  /// **'Bewegtbilder (Videos, GIFs) werden nicht unterstützt'**
  String get invalidImageType;

  /// No description provided for @fileTooLarge.
  ///
  /// In de, this message translates to:
  /// **'Das Bild ist zu groß. Maximale Größe: 15MB'**
  String get fileTooLarge;

  /// No description provided for @noInternetConnection.
  ///
  /// In de, this message translates to:
  /// **'Keine Internetverbindung'**
  String get noInternetConnection;

  /// No description provided for @retry.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get retry;

  /// No description provided for @invalidOrExpiredCode.
  ///
  /// In de, this message translates to:
  /// **'Ungültiger oder abgelaufener Code'**
  String get invalidOrExpiredCode;

  /// No description provided for @tooManyRegistrationAttempts.
  ///
  /// In de, this message translates to:
  /// **'Zu viele Registrierungsversuche. Bitte versuche es später erneut.'**
  String get tooManyRegistrationAttempts;

  /// No description provided for @passwordDoesNotMeetRequirements.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort erfüllt nicht die Anforderungen.'**
  String get passwordDoesNotMeetRequirements;

  /// No description provided for @cannotSendRequestToSelf.
  ///
  /// In de, this message translates to:
  /// **'Du kannst dir nicht selbst eine Freundschaftsanfrage senden'**
  String get cannotSendRequestToSelf;

  /// No description provided for @userNotFoundByEmail.
  ///
  /// In de, this message translates to:
  /// **'Kein Benutzer mit dieser E-Mail-Adresse gefunden'**
  String get userNotFoundByEmail;

  /// No description provided for @userNotFoundByFriendCode.
  ///
  /// In de, this message translates to:
  /// **'Kein Benutzer mit diesem Freundescode gefunden'**
  String get userNotFoundByFriendCode;

  /// No description provided for @friendRequestAlreadyExists.
  ///
  /// In de, this message translates to:
  /// **'Es existiert bereits eine offene Freundschaftsanfrage'**
  String get friendRequestAlreadyExists;

  /// No description provided for @confirmationEmailSent.
  ///
  /// In de, this message translates to:
  /// **'Eine Bestätigungs-E-Mail wurde an {email} gesendet. Bitte überprüfe dein Postfach.'**
  String confirmationEmailSent(String email);

  /// No description provided for @articleRemovedFromFavorites.
  ///
  /// In de, this message translates to:
  /// **'Artikel aus Favoriten entfernt'**
  String get articleRemovedFromFavorites;

  /// No description provided for @articleAddedToFavorites.
  ///
  /// In de, this message translates to:
  /// **'Artikel zu Favoriten hinzugefügt'**
  String get articleAddedToFavorites;

  /// No description provided for @errorLoadingArticle.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Laden des Artikels'**
  String get errorLoadingArticle;

  /// No description provided for @articleCouldNotBeLoaded.
  ///
  /// In de, this message translates to:
  /// **'Der Artikel konnte nicht geladen werden'**
  String get articleCouldNotBeLoaded;

  /// No description provided for @articleNotFound.
  ///
  /// In de, this message translates to:
  /// **'Artikel nicht gefunden'**
  String get articleNotFound;

  /// No description provided for @noImageAvailable.
  ///
  /// In de, this message translates to:
  /// **'Kein Bild verfügbar'**
  String get noImageAvailable;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get languageSettingsTitle;

  /// No description provided for @languageSettingsDescription.
  ///
  /// In de, this message translates to:
  /// **'Die Sprache wird auf Basis der Systemeinstellungen gewählt.'**
  String get languageSettingsDescription;

  /// No description provided for @languageSettingsAvailableLanguages.
  ///
  /// In de, this message translates to:
  /// **'Verfügbare Sprachen:'**
  String get languageSettingsAvailableLanguages;

  /// No description provided for @languageSettingsEnglish.
  ///
  /// In de, this message translates to:
  /// **'Englisch'**
  String get languageSettingsEnglish;

  /// No description provided for @languageSettingsGerman.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get languageSettingsGerman;

  /// No description provided for @navCommunity.
  ///
  /// In de, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// No description provided for @community.
  ///
  /// In de, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @groups.
  ///
  /// In de, this message translates to:
  /// **'Gruppen'**
  String get groups;

  /// No description provided for @addFriendOrGroup.
  ///
  /// In de, this message translates to:
  /// **'Freund oder Gruppe hinzufügen'**
  String get addFriendOrGroup;

  /// No description provided for @friendCodeOrGroupCode.
  ///
  /// In de, this message translates to:
  /// **'Freundescode oder Gruppencode'**
  String get friendCodeOrGroupCode;

  /// No description provided for @enterFriendOrGroupCode.
  ///
  /// In de, this message translates to:
  /// **'Freundescode oder Gruppencode eingeben'**
  String get enterFriendOrGroupCode;

  /// No description provided for @pendingRequests.
  ///
  /// In de, this message translates to:
  /// **'Offene Anfragen'**
  String get pendingRequests;

  /// No description provided for @noFriendsYet.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Freunde'**
  String get noFriendsYet;

  /// No description provided for @noGroupsYet.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Gruppen'**
  String get noGroupsYet;

  /// No description provided for @createGroup.
  ///
  /// In de, this message translates to:
  /// **'Gruppe erstellen'**
  String get createGroup;

  /// No description provided for @groupName.
  ///
  /// In de, this message translates to:
  /// **'Gruppenname'**
  String get groupName;

  /// No description provided for @groupDescription.
  ///
  /// In de, this message translates to:
  /// **'Gruppenbeschreibung'**
  String get groupDescription;

  /// No description provided for @groupCode.
  ///
  /// In de, this message translates to:
  /// **'Gruppencode'**
  String get groupCode;

  /// No description provided for @groupCodeCopied.
  ///
  /// In de, this message translates to:
  /// **'Gruppencode kopiert'**
  String get groupCodeCopied;

  /// No description provided for @renewGroupCode.
  ///
  /// In de, this message translates to:
  /// **'Gruppencode erneuern'**
  String get renewGroupCode;

  /// No description provided for @groupCodeRenewed.
  ///
  /// In de, this message translates to:
  /// **'Gruppencode erneuert'**
  String get groupCodeRenewed;

  /// No description provided for @members.
  ///
  /// In de, this message translates to:
  /// **'Mitglieder'**
  String get members;

  /// No description provided for @noMembers.
  ///
  /// In de, this message translates to:
  /// **'Keine Mitglieder'**
  String get noMembers;

  /// No description provided for @groupItems.
  ///
  /// In de, this message translates to:
  /// **'Artikel der Gruppe'**
  String get groupItems;

  /// No description provided for @admin.
  ///
  /// In de, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @makeAdmin.
  ///
  /// In de, this message translates to:
  /// **'Zum Admin ernennen'**
  String get makeAdmin;

  /// No description provided for @removeMember.
  ///
  /// In de, this message translates to:
  /// **'Mitglied entfernen'**
  String get removeMember;

  /// No description provided for @removeMemberTitle.
  ///
  /// In de, this message translates to:
  /// **'Mitglied entfernen'**
  String get removeMemberTitle;

  /// No description provided for @removeMemberConfirm.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du dieses Mitglied wirklich entfernen?'**
  String get removeMemberConfirm;

  /// No description provided for @memberRemoved.
  ///
  /// In de, this message translates to:
  /// **'Mitglied entfernt'**
  String get memberRemoved;

  /// No description provided for @adminChanged.
  ///
  /// In de, this message translates to:
  /// **'Admin geändert'**
  String get adminChanged;

  /// No description provided for @deleteGroup.
  ///
  /// In de, this message translates to:
  /// **'Gruppe löschen'**
  String get deleteGroup;

  /// No description provided for @deleteGroupTitle.
  ///
  /// In de, this message translates to:
  /// **'Gruppe löschen'**
  String get deleteGroupTitle;

  /// No description provided for @deleteGroupConfirm.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du diese Gruppe wirklich löschen?'**
  String get deleteGroupConfirm;

  /// No description provided for @leave.
  ///
  /// In de, this message translates to:
  /// **'Verlassen'**
  String get leave;

  /// No description provided for @leaveGroup.
  ///
  /// In de, this message translates to:
  /// **'Gruppe verlassen'**
  String get leaveGroup;

  /// No description provided for @leaveGroupTitle.
  ///
  /// In de, this message translates to:
  /// **'Gruppe verlassen'**
  String get leaveGroupTitle;

  /// No description provided for @leaveGroupConfirm.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du diese Gruppe wirklich verlassen?'**
  String get leaveGroupConfirm;

  /// No description provided for @leaveGroupSuccess.
  ///
  /// In de, this message translates to:
  /// **'Du hast die Gruppe verlassen'**
  String get leaveGroupSuccess;

  /// No description provided for @groupDeleted.
  ///
  /// In de, this message translates to:
  /// **'Gruppe gelöscht'**
  String get groupDeleted;

  /// No description provided for @groupCreated.
  ///
  /// In de, this message translates to:
  /// **'Gruppe erstellt'**
  String get groupCreated;

  /// No description provided for @groupUpdatedSuccess.
  ///
  /// In de, this message translates to:
  /// **'Gruppe erfolgreich aktualisiert'**
  String get groupUpdatedSuccess;

  /// No description provided for @groupNotFound.
  ///
  /// In de, this message translates to:
  /// **'Gruppe nicht gefunden'**
  String get groupNotFound;

  /// No description provided for @editGroup.
  ///
  /// In de, this message translates to:
  /// **'Gruppe bearbeiten'**
  String get editGroup;

  /// No description provided for @groupNameRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Gruppennamen ein'**
  String get groupNameRequired;

  /// No description provided for @selectIcon.
  ///
  /// In de, this message translates to:
  /// **'Icon auswählen'**
  String get selectIcon;

  /// No description provided for @addFriend.
  ///
  /// In de, this message translates to:
  /// **'Freund hinzufügen'**
  String get addFriend;

  /// No description provided for @joinGroup.
  ///
  /// In de, this message translates to:
  /// **'Gruppe beitreten'**
  String get joinGroup;

  /// No description provided for @create.
  ///
  /// In de, this message translates to:
  /// **'Erstellen'**
  String get create;

  /// No description provided for @demoMode.
  ///
  /// In de, this message translates to:
  /// **'DEMO-MODUS'**
  String get demoMode;

  /// No description provided for @demoBannerClickToExit.
  ///
  /// In de, this message translates to:
  /// **'Demo-Modus (Klicken zum Beenden)'**
  String get demoBannerClickToExit;

  /// No description provided for @selectAtLeastOneGroup.
  ///
  /// In de, this message translates to:
  /// **'Bitte wähle mindestens eine Gruppe aus.'**
  String get selectAtLeastOneGroup;

  /// No description provided for @groupNameTooLong.
  ///
  /// In de, this message translates to:
  /// **'Der Gruppenname ist zu lang (max. 20 Zeichen)'**
  String get groupNameTooLong;

  /// No description provided for @renewGroupCodeConfirm.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du den Gruppencode wirklich erneuern? Der alte Code wird danach sofort ungültig und neue Mitglieder können ihm nicht mehr beitreten.'**
  String get renewGroupCodeConfirm;

  /// No description provided for @enterGroupCode.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Gruppencode ein'**
  String get enterGroupCode;

  /// No description provided for @joinGroupSuccess.
  ///
  /// In de, this message translates to:
  /// **'Du bist der Gruppe beigetreten'**
  String get joinGroupSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
