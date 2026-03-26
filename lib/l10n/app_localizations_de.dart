// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Boro';

  @override
  String get login => 'Anmelden';

  @override
  String get logout => 'Ausloggen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get lendTo => 'Verleihen an...';

  @override
  String get retrieveItem => 'Zurückholen';

  @override
  String get retrieveItemQuestion => 'Zurückholen?';

  @override
  String get lendToTitle => 'Verleihen an...';

  @override
  String get lendToHint => 'Name';

  @override
  String get enterBorrowerName => 'Bitte einen Namen eingeben';

  @override
  String get markAsReturned => 'Als zurückgegeben markieren';

  @override
  String get borrowedBadge => 'VERLIEHEN';

  @override
  String borrowedBy(String name) {
    return 'Verliehen an $name';
  }

  @override
  String get error => 'Fehler';

  @override
  String get noItemsFound => 'Keine Artikel gefunden.';

  @override
  String get profileEdit => 'Profil bearbeiten';

  @override
  String get passwordChange => 'Passwort ändern';

  @override
  String get category => 'Kategorie';

  @override
  String get description => 'Beschreibung';

  @override
  String get location => 'Ort';

  @override
  String get saving => 'Wird gespeichert...';

  @override
  String get add => 'Hinzufügen';

  @override
  String get loading => 'Lädt...';

  @override
  String get articleDelete => 'Artikel löschen';

  @override
  String get noUserDataAvailable => 'Keine Benutzerdaten verfügbar.';

  @override
  String errorLoadingUser(String error) {
    return 'Fehler beim Laden des Benutzers';
  }

  @override
  String get errorLoadingData => 'Fehler beim Laden der Daten';

  @override
  String get noDataFound => 'Keine Daten gefunden';

  @override
  String get addFriends => 'Freunde hinzufügen';

  @override
  String get addFriendsNow => 'Jetzt Freunde hinzufügen';

  @override
  String get removeFriendConfirm =>
      'Möchtest du diesen Freund wirklich entfernen?';

  @override
  String get cancelFriendRequestConfirm =>
      'Möchtest du diese Freundschaftsanfrage wirklich stornieren?';

  @override
  String get rejectFriendRequestConfirm =>
      'Möchtest du diese Freundschaftsanfrage wirklich ablehnen?';

  @override
  String get selectCategory => 'Bitte eine Kategorie auswählen';

  @override
  String get descriptionMaxLength =>
      'Die Beschreibung darf höchstens 500 Zeichen lang sein';

  @override
  String get optional => 'optional';

  @override
  String get optionalLocation => 'Ort (optional)';

  @override
  String get optionalLocationHint => '';

  @override
  String get optionalDescription => 'Beschreibung (optional)';

  @override
  String get profileIncomplete =>
      'Dein Profil ist noch unvollständig. Füge jetzt weitere Infos hinzu!';

  @override
  String get aboutMe => 'Über mich';

  @override
  String get cityLocation => 'Stadt/Ort (automatisch ermittelt)';

  @override
  String get cityLocationHint => '';

  @override
  String get cityNoNumbers => 'Der Ort darf keine Zahl sein';

  @override
  String get contact => 'Kontaktmöglichkeit';

  @override
  String get contactHint => 'z. B. E-Mail-Adresse oder Telefonnummer';

  @override
  String get profileSaving => 'Profil wird gespeichert...';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackTitle => 'Wir freuen uns über dein Feedback!';

  @override
  String get feedbackMessage =>
      'Deine Meinung ist uns wichtig und hilft uns, die App weiter zu verbessern. Melde dich gern bei uns, wenn Fehler auftreten, Übersetzungen verbessert werden können oder wenn du Verbesserungsvorschläge/Funktionswünsche hast.';

  @override
  String get contactUs => 'Kontaktiere uns:';

  @override
  String get copyEmailHint =>
      'Kopiere die E-Mail-Adresse und schreibe uns eine Nachricht.';

  @override
  String get supportDeveloper => 'Entwickler unterstützen';

  @override
  String get legal => 'Rechtliches';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get imprint => 'Impressum';

  @override
  String get account => 'Konto';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get passwordReset => 'Passwort zurücksetzen';

  @override
  String linkCouldNotOpen(String url) {
    return 'Link konnte nicht geöffnet werden: $url';
  }

  @override
  String get navStart => 'Start';

  @override
  String get navFavorites => 'Favoriten';

  @override
  String get navLend => 'Verleihen';

  @override
  String get navFriends => 'Freunde';

  @override
  String get navMine => 'Meins';

  @override
  String get language => 'Sprache';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get settings => 'Einstellungen';

  @override
  String get register => 'Registrieren';

  @override
  String get signIn => 'Einloggen';

  @override
  String get tryDemo => 'Demo ausprobieren';

  @override
  String get demoModeReadOnly => 'Im Demo-Modus ist diese Aktion deaktiviert';

  @override
  String get slide1Text => 'Teile deine Sachen mit Freunden und Familie';

  @override
  String get slide2Text => 'Verleihe Werkzeug, Campingausrüstung und mehr';

  @override
  String get slide3Text => 'Spare Geld und schone die Umwelt';

  @override
  String get emailAddress => 'E-Mail Adresse';

  @override
  String get password => 'Passwort';

  @override
  String get passwordForgotten => 'Passwort vergessen?';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get noAccountYet => 'Du hast noch keinen Account? ';

  @override
  String get accountAlreadyExists => 'Konto bereits vorhanden? ';

  @override
  String get displayName => 'Anzeigename';

  @override
  String get displayNameHint => 'Dieser Name wird anderen Nutzern angezeigt';

  @override
  String get displayNameRequired => 'Anzeigename ist erforderlich';

  @override
  String get displayNameMinLength =>
      'Der Anzeigename muss mindestens 3 Zeichen lang sein';

  @override
  String get emailRequired => 'E-Mail-Adresse ist erforderlich';

  @override
  String get emailInvalid => 'Bitte gültige E-Mail-Adresse eingeben';

  @override
  String get passwordMinLength =>
      'Mindestens 8 Zeichen, max 72. Muss Großbuchstaben, Kleinbuchstaben und Ziffern enthalten.';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get passwordMinLengthError =>
      'Das Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get passwordMaxLengthError =>
      'Das Passwort darf höchstens 72 Zeichen lang sein';

  @override
  String get passwordMissingLowercase =>
      'Das Passwort muss mindestens einen Kleinbuchstaben (a-z) enthalten';

  @override
  String get passwordMissingUppercase =>
      'Das Passwort muss mindestens einen Großbuchstaben (A-Z) enthalten';

  @override
  String get passwordMissingDigits =>
      'Das Passwort muss mindestens eine Ziffer (0-9) enthalten';

  @override
  String get passwordTooShort => 'Zu kurz';

  @override
  String get passwordTooLong => 'Zu lang (max 72 Zeichen)';

  @override
  String get passwordNeedsLowercase => 'Benötigt Kleinbuchstaben';

  @override
  String get passwordNeedsUppercase => 'Benötigt Großbuchstaben';

  @override
  String get passwordNeedsDigits => 'Benötigt Ziffer';

  @override
  String get emailAndPasswordRequired =>
      'E-Mail Adresse und Passwort sind erforderlich';

  @override
  String get lendNow => 'Jetzt Artikel verleihen';

  @override
  String get createFirstItems =>
      'Erstelle deine ersten 3 Artikel, die du verleihen möchtest! Oder füge Freunde hinzu, um dein Netzwerk zu erweitern!';

  @override
  String get noResultsFound => 'Keine Ergebnisse gefunden';

  @override
  String get tryOtherSearchTerms =>
      'Versuche es mit anderen Suchbegriffen oder Filtereinstellungen';

  @override
  String get searchResults => 'Suchergebnisse';

  @override
  String get quickFilter => 'Schnellfilter';

  @override
  String get categories => 'Kategorien';

  @override
  String get search => 'Suchen...';

  @override
  String get searchItems => 'Artikel durchsuchen';

  @override
  String get app => 'App';

  @override
  String get myProfile => 'Mein Profil';

  @override
  String get myAds => 'Meine Anzeigen';

  @override
  String get editProfileTooltip => 'Profil bearbeiten';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get articleDeletedSuccess => 'Artikel erfolgreich gelöscht';

  @override
  String get addArticle => 'Artikel hinzufügen';

  @override
  String get editArticle => 'Artikel bearbeiten';

  @override
  String get title => 'Titel';

  @override
  String get titleRequired => 'Bitte einen Titel eingeben';

  @override
  String get titleMinLength => 'Der Titel muss mindestens 5 Zeichen lang sein';

  @override
  String get titleMaxLength => 'Der Titel darf höchstens 50 Zeichen lang sein';

  @override
  String get visibility => 'Sichtbarkeit';

  @override
  String get friendsOfFriends => 'Freunde von Freunden';

  @override
  String get directFriends => 'Direkte Freunde';

  @override
  String get private => 'Privat';

  @override
  String version(String version, String platform) {
    return 'Version $version ($platform)';
  }

  @override
  String get web => 'Web';

  @override
  String get android => 'Android';

  @override
  String get noFavoritesYet =>
      'Noch keine Favoriten vorhanden. Durchsuche die Artikel und füge deine Favoriten hinzu!';

  @override
  String get addFirstItems =>
      'Füge deine ersten 3 Artikel hinzu, die du verleihen möchtest!';

  @override
  String get displayNameUnique =>
      'Der Name sollte für deine Freunde eindeutig sein';

  @override
  String get nameRequired => 'Bitte einen Namen eingeben';

  @override
  String get nameMinLength => 'Der Name muss mindestens 5 Zeichen lang sein';

  @override
  String get nameMaxLength => 'Der Name darf höchstens 20 Zeichen lang sein';

  @override
  String get profileUpdatedSuccess => 'Profil erfolgreich aktualisiert';

  @override
  String get friends => 'Freunde';

  @override
  String get yourFriends => 'Deine Freunde';

  @override
  String get addFriendsTab => 'Freunde hinzufügen';

  @override
  String get friendCodeOrEmail => 'Freundescode oder E-Mail Adresse';

  @override
  String get yourFriendCode => 'Dein Freundescode zum Teilen';

  @override
  String get share => 'Teilen';

  @override
  String get copy => 'Kopieren';

  @override
  String get removeFriend => 'Freund entfernen';

  @override
  String get removeFriendTitle => 'Freund entfernen';

  @override
  String get remove => 'Entfernen';

  @override
  String get cancelRequest => 'Anfrage stornieren';

  @override
  String get cancelRequestTitle => 'Anfrage stornieren';

  @override
  String get receivedRequests => 'Empfangene Freundschaftsanfragen';

  @override
  String get sentRequests => 'Gesendete Freundschaftsanfragen';

  @override
  String get rejectRequest => 'Anfrage ablehnen';

  @override
  String get rejectRequestTitle => 'Anfrage ablehnen';

  @override
  String get accept => 'Annehmen';

  @override
  String get reject => 'Ablehnen';

  @override
  String get requestSent => 'Freundschaftsanfrage wurde gesendet!';

  @override
  String get requestAccepted => 'Freundschaftsanfrage angenommen';

  @override
  String get requestRejected => 'Freundschaftsanfrage abgelehnt';

  @override
  String get requestCancelled => 'Freundschaftsanfrage storniert';

  @override
  String get shareFriendCodeText =>
      'Teile deinen Freundescode z. B. in einer Gruppe mit Freunden, Kollegen oder Nachbarn, um dein Netzwerk zu erweitern!';

  @override
  String get friendCodeCopied => 'Freundescode in die Zwischenablage kopiert';

  @override
  String get noAdsYet => 'Keine Anzeigen vorhanden';

  @override
  String get userHasNoAds => 'Dieser Benutzer hat noch keine Anzeigen erstellt';

  @override
  String get currentAds => 'Aktuelle Anzeigen';

  @override
  String get profile => 'Profil';

  @override
  String get friend => 'Befreundet';

  @override
  String get requestPending => 'Anfrage ausstehend';

  @override
  String get addAsFriend => 'Als Freund hinzufügen';

  @override
  String get filter => 'Filter';

  @override
  String get resetFilters => 'Zurücksetzen';

  @override
  String get sorting => 'Sortierung';

  @override
  String get newest => 'Neueste zuerst';

  @override
  String get oldest => 'Älteste zuerst';

  @override
  String get alphabetical => 'Alphabetisch';

  @override
  String get all => 'Alle';

  @override
  String get country => 'Land';

  @override
  String get country_DE => 'Deutschland';

  @override
  String get country_AT => 'Österreich';

  @override
  String get country_CH => 'Schweiz';

  @override
  String get country_GB => 'United Kingdom';

  @override
  String get country_IE => 'Irland';

  @override
  String get country_US => 'USA';

  @override
  String get country_CA => 'Kanada';

  @override
  String get country_AU => 'Australien';

  @override
  String get country_NZ => 'Neuseeland';

  @override
  String get country_NO => 'Norwegen';

  @override
  String get country_SE => 'Schweden';

  @override
  String get country_PL => 'Polen';

  @override
  String get country_CZ => 'Tschechien';

  @override
  String get country_NL => 'Niederlande';

  @override
  String get country_BE => 'Belgien';

  @override
  String get country_LU => 'Luxemburg';

  @override
  String get country_FR => 'Frankreich';

  @override
  String get country_IT => 'Italien';

  @override
  String get country_ES => 'Spanien';

  @override
  String get selectCountry => 'Land auswählen';

  @override
  String get differentLocation => 'Alternativer Standort';

  @override
  String get differentLocationHint =>
      'Aktivieren, wenn der Artikel an einem anderen Ort steht als dein Profil-Standort.';

  @override
  String get postalCode => 'Postleitzahl';

  @override
  String get postalCodeOptional => 'Postleitzahl (optional)';

  @override
  String get postalCodeFilterLabel => 'Postleitzahl';

  @override
  String get postalCodeFilterHint => 'Z. B. 10115';

  @override
  String get maxDistanceLabel => 'Maximale Entfernung';

  @override
  String get distanceFilterTooltip => 'Ausgehend von deinem Profil-Standort';

  @override
  String get distanceUnlimited => 'Egal';

  @override
  String get distanceFilterLabel => 'Entfernung';

  @override
  String distanceFilterValue(int distance) {
    return '$distance km';
  }

  @override
  String get resetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get resetPasswordDescription =>
      'Gib deine E-Mail-Adresse ein, um einen 6-stelligen Code zum Zurücksetzen deines Passworts zu erhalten.';

  @override
  String get emailRequiredForReset => 'Bitte gib deine E-Mail-Adresse ein';

  @override
  String get emailInvalidForReset =>
      'Bitte gib eine gültige E-Mail-Adresse ein';

  @override
  String get sendCode => 'Code senden';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get currentPasswordRequired => 'Bitte gib dein aktuelles Passwort ein';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get newPasswordRequired => 'Bitte gib ein neues Passwort ein';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get confirmPasswordRequired => 'Bitte bestätige dein neues Passwort';

  @override
  String get passwordsDoNotMatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get newPasswordSameAsOld =>
      'Das neue Passwort muss sich vom alten unterscheiden';

  @override
  String get passwordChangedSuccess => 'Passwort erfolgreich geändert';

  @override
  String get currentPasswordIncorrect =>
      'Das aktuelle Passwort ist nicht korrekt';

  @override
  String get userNotFound => 'Benutzer nicht gefunden';

  @override
  String get profileLoadError => 'Fehler beim Laden des Profils';

  @override
  String get userCouldNotBeLoaded => 'Der Benutzer konnte nicht geladen werden';

  @override
  String get offerType => 'Angebotsart';

  @override
  String get allOfferTypes => 'Alle Angebotsarten';

  @override
  String get selectSorting => 'Bitte eine Sortierung auswählen';

  @override
  String get selectType => 'Bitte einen Typ auswählen';

  @override
  String get applyFilter => 'Filter anwenden';

  @override
  String get enterCode => 'Code eingeben';

  @override
  String codeSentToEmail(String email) {
    return 'Ein 6-stelliger Code wurde an $email gesendet. Bitte überprüfe dein Postfach.';
  }

  @override
  String get verifyCode => 'Code verifizieren';

  @override
  String get enterFullCode =>
      'Bitte gib den vollständigen 6-stelligen Code ein';

  @override
  String get codeVerifiedMessage =>
      'Bitte gebe ein neues Passwort ein. Der Code wurde erfolgreich verifiziert.';

  @override
  String get supportDeveloperTitle => 'Unterstütze den Entwickler!';

  @override
  String get supportDeveloperText =>
      'Wenn dir die App gefällt, kannst du mich mit einer Spende unterstützen :) Deine Unterstützung hilft mir, die Serverkosten zu decken und die App weiterzuentwickeln. Klicke auf den Button, um eine Spende über PayPal zu tätigen.';

  @override
  String get paypalDonateLink => 'PayPal Spendenlink';

  @override
  String get thanksForSupport => 'Danke für deine Unterstützung!';

  @override
  String get offerTypeOffer => 'Verleihe';

  @override
  String get offerTypeOfferCard => 'Zu verleihen';

  @override
  String get offerTypeFree => 'Verschenke';

  @override
  String get offerTypeFreeCard => 'Zu verschenken';

  @override
  String get offerTypeSearch => 'Suche';

  @override
  String get offerTypeSearchCard => 'Gesuch';

  @override
  String get offerTypeSell => 'Verkaufe';

  @override
  String get offerTypeSellCard => 'Zu verkaufen';

  @override
  String get newBadge => 'NEU';

  @override
  String get badgeTopLenderTitle => 'Top Verleiher';

  @override
  String get badgeTopLenderDescription => 'Mindestens 3 Artikel eingestellt';

  @override
  String get badgeEarlyUserTitle => 'Supporter';

  @override
  String get badgeEarlyUserDescription => 'Von Anfang an dabei';

  @override
  String get badgeTopNetworkedTitle => 'Gut vernetzt';

  @override
  String get badgeTopNetworkedDescription => '5 oder mehr direkte Freunde';

  @override
  String get details => 'Details';

  @override
  String get categoryLabel => 'Kategorie:';

  @override
  String get offerTypeLabel => 'Angebotstyp:';

  @override
  String get offerTypeFormLabel => 'Angebotstyp';

  @override
  String get articleLocationLabel => 'Artikelstandort:';

  @override
  String get postedOnLabel => 'Eingestellt am:';

  @override
  String get noDescriptionAvailable => '- Keine Beschreibung vorhanden -';

  @override
  String get memberSince => 'Mitglied seit';

  @override
  String get week => 'Woche';

  @override
  String get weeks => 'Wochen';

  @override
  String get month => 'Monat';

  @override
  String get months => 'Monaten';

  @override
  String get year => 'Jahr';

  @override
  String get years => 'Jahren';

  @override
  String get people => 'Personen';

  @override
  String get direct => 'direkt';

  @override
  String get indirect => 'indirekt';

  @override
  String get mutualFriends => 'Gemeinsame Freunde: ';

  @override
  String get categoryCamping => 'Camping';

  @override
  String get categoryFahrrad => 'Fahrrad';

  @override
  String get categoryWerkzeug => 'Werkzeug';

  @override
  String get categoryReisen => 'Reisen';

  @override
  String get categoryHaushalt => 'Haushalt';

  @override
  String get categoryMusik => 'Musik';

  @override
  String get categoryBuecher => 'Bücher';

  @override
  String get categorySport => 'Sport';

  @override
  String get categoryKueche => 'Küche';

  @override
  String get categorySpiele => 'Spiele';

  @override
  String get categoryFotografie => 'Fotografie';

  @override
  String get categoryUmzug => 'Umzug';

  @override
  String get categoryTechnik => 'Technik';

  @override
  String get categorySonstiges => 'Sonstiges';

  @override
  String get articleSavedSuccessTitle => 'Supi!';

  @override
  String get articleSavedSuccessMessage =>
      'Dein Eintrag wurde erfolgreich gespeichert! :)';

  @override
  String get continueButton => 'Weiter';

  @override
  String get visibilityLabel => 'Sichtbarkeit:';

  @override
  String get deleteArticleConfirm =>
      'Möchtest du diesen Artikel wirklich löschen?';

  @override
  String get errorOccurred => 'Es ist ein Fehler aufgetreten';

  @override
  String get emailNotConfirmed =>
      'Bitte bestätige deine E-Mail-Adresse, um dich anzumelden.';

  @override
  String get invalidCredentials => 'Ungültige E-Mail-Adresse oder Passwort';

  @override
  String get invalidImageType =>
      'Bewegtbilder (Videos, GIFs) werden nicht unterstützt';

  @override
  String get fileTooLarge => 'Das Bild ist zu groß. Maximale Größe: 15MB';

  @override
  String get noInternetConnection => 'Keine Internetverbindung';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get invalidOrExpiredCode => 'Ungültiger oder abgelaufener Code';

  @override
  String get tooManyRegistrationAttempts =>
      'Zu viele Registrierungsversuche. Bitte versuche es später erneut.';

  @override
  String get passwordDoesNotMeetRequirements =>
      'Das Passwort erfüllt nicht die Anforderungen.';

  @override
  String get cannotSendRequestToSelf =>
      'Du kannst dir nicht selbst eine Freundschaftsanfrage senden';

  @override
  String get userNotFoundByEmail =>
      'Kein Benutzer mit dieser E-Mail-Adresse gefunden';

  @override
  String get userNotFoundByFriendCode =>
      'Kein Benutzer mit diesem Freundescode gefunden';

  @override
  String get friendRequestAlreadyExists =>
      'Es existiert bereits eine offene Freundschaftsanfrage';

  @override
  String confirmationEmailSent(String email) {
    return 'Eine Bestätigungs-E-Mail wurde an $email gesendet. Bitte überprüfe dein Postfach.';
  }

  @override
  String get articleRemovedFromFavorites => 'Artikel aus Favoriten entfernt';

  @override
  String get articleAddedToFavorites => 'Artikel zu Favoriten hinzugefügt';

  @override
  String get errorLoadingArticle => 'Fehler beim Laden des Artikels';

  @override
  String get articleCouldNotBeLoaded =>
      'Der Artikel konnte nicht geladen werden';

  @override
  String get articleNotFound => 'Artikel nicht gefunden';

  @override
  String get noImageAvailable => 'Kein Bild verfügbar';

  @override
  String get languageSettingsTitle => 'Sprache';

  @override
  String get languageSettingsDescription =>
      'Die Sprache wird auf Basis der Systemeinstellungen gewählt.';

  @override
  String get languageSettingsAvailableLanguages => 'Verfügbare Sprachen:';

  @override
  String get languageSettingsEnglish => 'Englisch';

  @override
  String get languageSettingsGerman => 'Deutsch';

  @override
  String get navCommunity => 'Community';

  @override
  String get community => 'Community';

  @override
  String get groups => 'Gruppen';

  @override
  String get addFriendOrGroup => 'Freund oder Gruppe hinzufügen';

  @override
  String get friendCodeOrGroupCode => 'Freundescode oder Gruppencode';

  @override
  String get enterFriendOrGroupCode => 'Freundescode oder Gruppencode eingeben';

  @override
  String get pendingRequests => 'Offene Anfragen';

  @override
  String get noFriendsYet => 'Noch keine Freunde';

  @override
  String get noGroupsYet => 'Noch keine Gruppen';

  @override
  String get createGroup => 'Gruppe erstellen';

  @override
  String get groupName => 'Gruppenname';

  @override
  String get groupDescription => 'Gruppenbeschreibung';

  @override
  String get groupCode => 'Gruppencode';

  @override
  String get groupCodeCopied => 'Gruppencode kopiert';

  @override
  String get renewGroupCode => 'Gruppencode erneuern';

  @override
  String get groupCodeRenewed => 'Gruppencode erneuert';

  @override
  String get members => 'Mitglieder';

  @override
  String get noMembers => 'Keine Mitglieder';

  @override
  String get groupItems => 'Artikel der Gruppe';

  @override
  String get admin => 'Admin';

  @override
  String get makeAdmin => 'Zum Admin ernennen';

  @override
  String get removeMember => 'Mitglied entfernen';

  @override
  String get removeMemberTitle => 'Mitglied entfernen';

  @override
  String get removeMemberConfirm =>
      'Möchtest du dieses Mitglied wirklich entfernen?';

  @override
  String get memberRemoved => 'Mitglied entfernt';

  @override
  String get adminChanged => 'Admin geändert';

  @override
  String get deleteGroup => 'Gruppe löschen';

  @override
  String get deleteGroupTitle => 'Gruppe löschen';

  @override
  String get deleteGroupConfirm => 'Möchtest du diese Gruppe wirklich löschen?';

  @override
  String get leave => 'Verlassen';

  @override
  String get leaveGroup => 'Gruppe verlassen';

  @override
  String get leaveGroupTitle => 'Gruppe verlassen';

  @override
  String get leaveGroupConfirm =>
      'Möchtest du diese Gruppe wirklich verlassen?';

  @override
  String get leaveGroupSuccess => 'Du hast die Gruppe verlassen';

  @override
  String get groupDeleted => 'Gruppe gelöscht';

  @override
  String get groupCreated => 'Gruppe erstellt';

  @override
  String get groupUpdatedSuccess => 'Gruppe erfolgreich aktualisiert';

  @override
  String get groupNotFound => 'Gruppe nicht gefunden';

  @override
  String get editGroup => 'Gruppe bearbeiten';

  @override
  String get groupNameRequired => 'Bitte gib einen Gruppennamen ein';

  @override
  String get selectIcon => 'Icon auswählen';

  @override
  String get addFriend => 'Freund hinzufügen';

  @override
  String get joinGroup => 'Gruppe beitreten';

  @override
  String get create => 'Erstellen';

  @override
  String get demoMode => 'DEMO-MODUS';

  @override
  String get demoBannerClickToExit => 'Demo-Modus (Klicken zum Beenden)';

  @override
  String get selectAtLeastOneGroup => 'Bitte wähle mindestens eine Gruppe aus.';

  @override
  String get groupNameTooLong =>
      'Der Gruppenname ist zu lang (max. 20 Zeichen)';

  @override
  String get renewGroupCodeConfirm =>
      'Möchtest du den Gruppencode wirklich erneuern? Der alte Code wird danach sofort ungültig und neue Mitglieder können ihm nicht mehr beitreten.';

  @override
  String get enterGroupCode => 'Bitte gib einen Gruppencode ein';

  @override
  String get joinGroupSuccess => 'Du bist der Gruppe beigetreten';
}
