import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Hard-coded localization for Legash Blood Network.
///
/// Languages supported:
///   - en : English
///   - am : Amharic (አማርኛ)
///   - om : Afaan Oromoo
///
/// Strings are hard-coded (no ARB files) as requested.
///
/// This version uses a static locale holder instead of Flutter's
/// Localizations system (which isn't available in this SDK).
class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  /// Current locale, updated by [LocaleProvider].
  static Locale _current = const Locale('en', '');

  /// Supported locales.
  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('am', ''),
    Locale('om', ''),
  ];

  /// Set the current locale (called by LocaleProvider).
  static void setLocale(Locale locale) {
    _current = locale;
  }

  /// Get localizations for the current static locale.
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations(_current);
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  String _get(String key) {
    final strings = _allStrings[locale.languageCode];
    if (strings == null) return _allStrings['en']![key] ?? key;
    return strings[key] ?? _allStrings['en']![key] ?? key;
  }

  static const Map<String, Map<String, String>> _allStrings = {
    'en': _english,
    'am': _amharic,
    'om': _afaanOromoo,
  };

  // -------------------------------------------------------------------------
  // App shell
  // -------------------------------------------------------------------------
  String get appTitle => _get('appTitle');
  String get legash => _get('legash');

  // Bottom nav
  String get navHome => _get('navHome');
  String get navRequests => _get('navRequests');
  String get navProfile => _get('navProfile');

  // Dashboard
  String get greetingMorning => _get('greetingMorning');
  String get greetingAfternoon => _get('greetingAfternoon');
  String get greetingEvening => _get('greetingEvening');
  String get eligibleToDonate => _get('eligibleToDonate');
  String get howLegashWorks => _get('howLegashWorks');
  String get howLegashWorksDesc => _get('howLegashWorksDesc');
  String get donorProfile => _get('donorProfile');
  String get bloodType => _get('bloodType');
  String get noEventsYet => _get('noEventsYet');
  String get checkBackSoon => _get('checkBackSoon');
  String get events => _get('events');
  String get donationHistory => _get('donationHistory');
  String get nearbyCenters => _get('nearbyCenters');

  // Quick nav
  String get quickNavDonationHistory => _get('quickNavDonationHistory');
  String get quickNavNearbyCenters => _get('quickNavNearbyCenters');

  // Donation history
  String get noDonationHistoryYet => _get('noDonationHistoryYet');
  String get donationRecordsDesc => _get('donationRecordsDesc');
  String get couldNotLoadDonationHistory => _get('couldNotLoadDonationHistory');
  String get retry => _get('retry');
  String get centerName => _get('centerName');
  String get bloodCenter => _get('bloodCenter');
  String get date => _get('date');
  String get quantity => _get('quantity');

  // Nearby centers
  String get nearbyBloodCenters => _get('nearbyBloodCenters');
  String get searchCenterNameOrCity => _get('searchCenterNameOrCity');
  String get couldNotLoadNearbyBloodCenters =>
      _get('couldNotLoadNearbyBloodCenters');
  String get noBloodCentersMatching => _get('noBloodCentersMatching');
  String get noNearbyBloodCentersFound => _get('noNearbyBloodCentersFound');
  String get verifiedMedicalFacilitiesWillAppear =>
      _get('verifiedMedicalFacilitiesWillAppear');
  String get verifiedFacility => _get('verifiedFacility');
  String get call => _get('call');
  String get directions => _get('directions');

  // Profile
  String get profile => _get('profile');
  String get personalDetails => _get('personalDetails');
  String get fullName => _get('fullName');
  String get tapToSelect => _get('tapToSelect');
  String get gender => _get('gender');
  String get phoneNumber => _get('phoneNumber');
  String get faydaNationalIdFin => _get('faydaNationalIdFin');
  String get medicalPhysicalDetails => _get('medicalPhysicalDetails');
  String get dateOfBirth => _get('dateOfBirth');
  String get weight => _get('weight');
  String get height => _get('height');
  String get healthNotes => _get('healthNotes');
  String get none => _get('none');
  String get security => _get('security');
  String get changeSecurityPIN => _get('changeSecurityPIN');
  String get logOut => _get('logOut');
  String get verifiedDonor => _get('verifiedDonor');
  String get bloodTypeUnset => _get('bloodTypeUnset');
  String get totalDonations => _get('totalDonations');
  String get lastDonation => _get('lastDonation');
  String get nextEligibleDonation => _get('nextEligibleDonation');

  // Onboarding
  String get welcome => _get('welcome');
  String get welcomeSubtitle => _get('welcomeSubtitle');
  String get register => _get('register');
  String get login => _get('login');

  // Common
  String get save => _get('save');
  String get cancel => _get('cancel');
  String get ok => _get('ok');
  String get error => _get('error');
  String get success => _get('success');
  String get loading => _get('loading');
  String get home => _get('home');
}

// ===========================================================================
// English
// ===========================================================================
const Map<String, String> _english = {
  'appTitle': 'Legash Blood Network',
  'legash': 'LEGASH',

  'navHome': 'Home',
  'navRequests': 'Requests',
  'navProfile': 'Profile',

  'greetingMorning': 'Good morning',
  'greetingAfternoon': 'Good afternoon',
  'greetingEvening': 'Good evening',
  'eligibleToDonate': "You're eligible to donate.",
  'howLegashWorks': 'How Legash works',
  'howLegashWorksDesc':
      'When a hospital in your area needs blood, you get an alert. '
      'Accept and the hospital can reach out to you directly.',
  'donorProfile': 'Your donor profile',
  'bloodType': 'Blood type',
  'noEventsYet': 'No events yet.',
  'checkBackSoon': 'Check back soon!',
  'events': 'Events',
  'donationHistory': 'Donation History',
  'nearbyCenters': 'Nearby Centers',

  'quickNavDonationHistory': 'Donation History',
  'quickNavNearbyCenters': 'Nearby Centers',

  'noDonationHistoryYet': 'No donation history yet.',
  'donationRecordsDesc':
      'Your donation records from blood centers will appear here once available.',
  'couldNotLoadDonationHistory': 'Could not load donation history.',
  'retry': 'Retry',
  'centerName': 'Center Name',
  'bloodCenter': 'Blood Center',
  'date': 'Date',
  'quantity': 'Quantity',

  'nearbyBloodCenters': 'Nearby Blood Centers',
  'searchCenterNameOrCity': 'Search center name or city...',
  'couldNotLoadNearbyBloodCenters': 'Could not load nearby blood centers.',
  'noBloodCentersMatching': 'No blood centers matching "{query}".',
  'noNearbyBloodCentersFound': 'No nearby blood centers found.',
  'verifiedMedicalFacilitiesWillAppear':
      'Verified blood donation centers will appear here.',
  'verifiedFacility': 'Verified Facility',
  'call': 'Call',
  'directions': 'Directions',

  'profile': 'PROFILE',
  'personalDetails': 'Personal Details',
  'fullName': 'Full Name',
  'tapToSelect': 'Tap to select',
  'gender': 'Gender',
  'phoneNumber': 'Phone Number',
  'faydaNationalIdFin': 'Fayda National ID (FIN)',
  'medicalPhysicalDetails': 'Medical & Physical Details',
  'dateOfBirth': 'Date of Birth',
  'weight': 'Weight',
  'height': 'Height',
  'healthNotes': 'Health Notes',
  'none': 'None',
  'security': 'Security',
  'changeSecurityPIN': 'Change Security PIN',
  'logOut': 'Log Out',
  'verifiedDonor': 'Verified Donor',
  'bloodTypeUnset': 'Blood Type Unset',
  'totalDonations': 'Total Donations',
  'lastDonation': 'Last Donation',
  'nextEligibleDonation': 'Next Eligible Donation',

  'welcome': 'Welcome to Legash',
  'welcomeSubtitle': 'Save lives. Donate blood.',
  'register': 'Register',
  'login': 'Login',

  'save': 'Save',
  'cancel': 'Cancel',
  'ok': 'OK',
  'error': 'Error',
  'success': 'Success',
  'loading': 'Loading...',
  'home': 'Home',
};

// ===========================================================================
// Amharic (አማርኛ)
// ===========================================================================
const Map<String, String> _amharic = {
  'appTitle': 'ሌጋሽ የዝማኔነት ድምር',
  'legash': 'ሌጋሽ',

  'navHome': 'መነሻ',
  'navRequests': 'ጥያቄዎች',
  'navProfile': 'ሕግታቱ',

  'greetingMorning': 'እንደምን እደላለሁ',
  'greetingAfternoon': 'እንደምስከረም እደላለሁ',
  'greetingEvening': 'እንደምንቀበል እደላለሁ',
  'eligibleToDonate': 'መተዋዋልን ይችላሉ።',
  'howLegashWorks': 'እንዴት ሌጋሽ ይሰራል',
  'howLegashWorksDesc':
      'በአካባቢዎ ላይ መተዋዋዢ የፍርድ ፀሐይ ሲሆን እንደሚነግረው ይመልከታሉ፤ '
      'አቀረቡ ፡ መተዋዋዢው በመንገድ ይዘጋውዋል።',
  'donorProfile': 'የዝማኔው መዝሙራት',
  'bloodType': 'የፍርድ ዓይነት',
  'noEventsYet': 'አይነት ዕድሎች የለም።',
  'checkBackSoon': 'በቀላሉ መ on回/',
  'events': 'ዕድሎች',
  'donationHistory': 'የዝማኔነት ታሪክ',
  'nearbyCenters': 'ቀላሉ መረጃ ማኅበረሰቦች',

  'quickNavDonationHistory': 'የዝማኔነት ታሪክ',
  'quickNavNearbyCenters': 'ቀላሉ መረጃ ማኅበረሰቦች',

  'noDonationHistoryYet': 'አሁን የዝማኔነት ታሪክ የለም።',
  'donationRecordsDesc':
      'የማኅበረሰቦች መዝሙር የዝማኔነት ባለፌ ተማሪ የሆኑት በመጫን ይገኛሉ።',
  'couldNotLoadDonationHistory': 'የዝማኔነት ታሪክ አልተቀመጠም።',
  'retry': 'ይዘዋውሮ',
  'centerName': 'ስም መረጃ',
  'bloodCenter': 'የፍርድ መረጃ',
  'date': 'ቀን',
  'quantity': 'መጠን',

  'nearbyBloodCenters': 'ቀላሉ የፍርድ መረጃዎች',
  'searchCenterNameOrCity': 'ስም ወይም ከተማ ይፈልጋሉ...',
  'couldNotLoadNearbyBloodCenters': 'የቀላሉ የፍርድ መረጃዎች አልተቀመጠም።',
  'noBloodCentersMatching': '"{query}" ውስጥ የፍርድ መረጃ አልተቀመጠም።',
  'noNearbyBloodCentersFound': 'ቀላሉ የፍርድ መረጃ አልተገኘም።',
  'verifiedMedicalFacilitiesWillAppear':
      'ተረኝቷል የፍርድ ዝማኔ መረጃ ይገኛሉ።',
  'verifiedFacility': 'ተረኝቷል መረጃ',
  'call': 'ይደውሉ',
  'directions': 'መንገዶች',

  'profile': 'ሕግታት',
  'personalDetails': 'የግል መረጃ',
  'fullName': 'ሙሉ ስም',
  'tapToSelect': 'ይጫኑ ይምረጡ',
  'gender': 'ፍጹም',
  'phoneNumber': 'ስልክ ቁጥር',
  'faydaNationalIdFin': 'ፋይዳ ብልጽግና መታወክን (FIN)',
  'medicalPhysicalDetails': 'የጤና እና የሥራ ጥቅሶች',
  'dateOfBirth': 'የልደት ቀን',
  'weight': 'ክብር',
  'height': 'ሕያዊ',
  'healthNotes': 'የጤና አስተያየቶች',
  'none': 'የለም',
  'security': 'አីቲንግ',
  'changeSecurityPIN': 'የአስተያየት PIN ቀድሞ ውጣል',
  'logOut': 'ውጣ',
  'verifiedDonor': 'ተረኝቷል ዝማኔ',
  'bloodTypeUnset': 'የፍርድ ዓይነት አልተዘላገቁም',
  'totalDonations': 'ጠቅላይ ዝማኔነት',
  'lastDonation': 'የቀድሞ ዝማኔነት',
  'nextEligibleDonation': 'የቀጣይ ይችላል ዝማኔነት',

  'welcome': 'እንኳን በደህና መጣህ። ሌጋሽ',
  'welcomeSubtitle': 'ሕይወትን ይዝቱ፡ ፍርድ ይዝቱ።',
  'register': 'ዝርዝር',
  'login': 'ግባ',

  'save': 'ዝርዝር',
  'cancel': 'አቁሙ',
  'ok': 'እሺ',
  'error': 'ስህተት',
  'success': 'እረፍት',
  'loading': 'ይታወቃል...',
  'home': 'መነሻ',
};

const Map<String, String> _afaanOromoo = {
  'appTitle': 'Legash Blood Network',
  'legash': 'LEGASH',

  'navHome': 'Mana',
  'navRequests': 'Maqaanii',
  'navProfile': 'Hojiin',

  'greetingMorning': 'Innili',
  'greetingAfternoon': 'Innili',
  'greetingEvening': 'Innili',
  'eligibleToDonate': 'Dabalateera.',
  'howLegashWorks': 'Legash ni maali?',
  'howLegashWorksDesc':
      'Waaqayyo maqaanii qabaan hin qabu, dabalateera.',
  'donorProfile': 'Dabalateera hojiin',
  'bloodType': 'Cimnii kanaa',
  'noEventsYet': 'Hammatti ti.',
  'checkBackSoon': 'Yoo hin beeksisu.',
  'events': 'Hammatti',
  'donationHistory': 'Maqaanii deebi',
  'nearbyCenters': 'Na barbaachisaa',

  'quickNavDonationHistory': 'Maqaanii deebi',
  'quickNavNearbyCenters': 'Na barbaachisaa',

  'noDonationHistoryYet': 'Maqaanii deebi qabamu.',
  'donationRecordsDesc':
      'Maqaanii deebi qabaan keessaatti.',
  'couldNotLoadDonationHistory': 'Maqaanii deebi hin qabu.',
  'retry': 'Mana',
  'centerName': 'Magaalaa beeksisa',
  'bloodCenter': 'Cimnii beeksisa',
  'date': 'Cimsaa',
  'quantity': 'Qaama',

  'nearbyBloodCenters': 'Na beeksisa qabde',
  'searchCenterNameOrCity': 'Magaalaa deebi qabaan yoo beeksisa.',
  'couldNotLoadNearbyBloodCenters': 'Na beeksisa hin qabu.',
  'noBloodCentersMatching': 'Na beeksisa qabaan hin qabu.',
  'noNearbyBloodCentersFound': 'Na beeksisa qabaan hin taane.',
  'verifiedMedicalFacilitiesWillAppear':
      'Na beeksisa qabaan dandeeti.',
  'verifiedFacility': 'Qabeenya dubbachuu',
  'call': 'Barruu',
  'directions': 'Tajaajila',

  'profile': 'HOJIIN',
  'personalDetails': 'Hojiin dabalate',
  'fullName': 'Magaalaa',
  'tapToSelect': 'Dhaamu',
  'gender': 'Dhiisoo',
  'phoneNumber': 'Telefoonii bilbila',
  'faydaNationalIdFin': 'FIN',
  'medicalPhysicalDetails': 'Tajaajilaa qabaan',
  'dateOfBirth': 'Cimsaa kanaa',
  'weight': 'Qaama',
  'height': 'Eegumsa',
  'healthNotes': 'Tajaajila qabaan',
  'none': 'Hin taane',
  'security': 'Oltiin',
  'changeSecurityPIN': 'PIN keessattii hin qabdu',
  'logOut': 'Hoji',
  'verifiedDonor': 'Qabeenya dubbachuu',
  'bloodTypeUnset': 'Cimnii kanaa hin qabne.',
  'totalDonations': 'Maqaanii qabaan',
  'lastDonation': 'Maqaanii deebi',
  'nextEligibleDonation': 'Maqaanii deebi qabde',

  'welcome': 'Legashni walitti hundee.',
  'welcomeSubtitle': 'Dabalateera.',
  'register': 'Hoji',
  'login': 'Hoji',

  'save': 'Dhaamu',
  'cancel': 'Hoji',
  'ok': 'Eeyyee',
  'error': 'Kan baayye',
  'success': 'Dandaama',
  'loading': 'Yaada',
  'home': 'Mana',
};

/// Persisted locale provider.
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString('app_locale');
      if (code != null && code.isNotEmpty) {
        _locale = Locale(code, '');
        AppLocalizations.setLocale(_locale);
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    final newLocale = Locale(languageCode, '');
    if (_locale == newLocale) return;
    _locale = newLocale;
    AppLocalizations.setLocale(_locale);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_locale', languageCode);
    } catch (_) {}
    notifyListeners();
  }
}
