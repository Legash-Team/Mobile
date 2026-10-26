import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';
import 'app_localizations_om.dart';

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
    Locale('am'),
    Locale('en'),
    Locale('om'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Legash'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @requestsTab.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requestsTab;

  /// No description provided for @feedTab.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feedTab;

  /// No description provided for @eventsTab.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @eligibleToDonate.
  ///
  /// In en, this message translates to:
  /// **'You\'re eligible to donate.'**
  String get eligibleToDonate;

  /// No description provided for @howLegashWorks.
  ///
  /// In en, this message translates to:
  /// **'How Legash works'**
  String get howLegashWorks;

  /// No description provided for @howLegashWorksExplanation.
  ///
  /// In en, this message translates to:
  /// **'When a hospital in your area needs blood, you get an alert. Accept and the hospital can reach out to you directly.'**
  String get howLegashWorksExplanation;

  /// No description provided for @recentEvents.
  ///
  /// In en, this message translates to:
  /// **'Recent Events'**
  String get recentEvents;

  /// No description provided for @noEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No events yet'**
  String get noEventsYet;

  /// No description provided for @yourDonorProfile.
  ///
  /// In en, this message translates to:
  /// **'Your donor profile'**
  String get yourDonorProfile;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodType;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @personalAndIdentityDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal & Identity Details'**
  String get personalAndIdentityDetails;

  /// No description provided for @medicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Medical & Physical Details'**
  String get medicalDetails;

  /// No description provided for @healthNotes.
  ///
  /// In en, this message translates to:
  /// **'Health Notes'**
  String get healthNotes;

  /// No description provided for @editHealthNotes.
  ///
  /// In en, this message translates to:
  /// **'Edit Health Notes'**
  String get editHealthNotes;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securityAccount.
  ///
  /// In en, this message translates to:
  /// **'Security & Account'**
  String get securityAccount;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @chooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred app language'**
  String get chooseLanguageSubtitle;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @amharic.
  ///
  /// In en, this message translates to:
  /// **'Amharic'**
  String get amharic;

  /// No description provided for @oromo.
  ///
  /// In en, this message translates to:
  /// **'Afaan Oromoo'**
  String get oromo;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @finLabel.
  ///
  /// In en, this message translates to:
  /// **'Fayda National ID (FIN)'**
  String get finLabel;

  /// No description provided for @donorId.
  ///
  /// In en, this message translates to:
  /// **'Donor ID'**
  String get donorId;

  /// No description provided for @donorShortId.
  ///
  /// In en, this message translates to:
  /// **'Short ID'**
  String get donorShortId;

  /// No description provided for @copyShortId.
  ///
  /// In en, this message translates to:
  /// **'Copy Short ID'**
  String get copyShortId;

  /// No description provided for @shortIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Donor Short ID copied to clipboard'**
  String get shortIdCopied;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change Security PIN'**
  String get changePin;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your Legash account?'**
  String get logoutConfirmMessage;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get alreadyHaveAccount;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @selectBloodType.
  ///
  /// In en, this message translates to:
  /// **'Select Blood Type'**
  String get selectBloodType;

  /// No description provided for @chooseBloodTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your confirmed blood type'**
  String get chooseBloodTypeSubtitle;

  /// No description provided for @editFullName.
  ///
  /// In en, this message translates to:
  /// **'Edit Full Name'**
  String get editFullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @editWeight.
  ///
  /// In en, this message translates to:
  /// **'Edit Weight (kg)'**
  String get editWeight;

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter weight in kg'**
  String get enterWeight;

  /// No description provided for @editHeight.
  ///
  /// In en, this message translates to:
  /// **'Edit Height (cm)'**
  String get editHeight;

  /// No description provided for @enterHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter height in cm'**
  String get enterHeight;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @confirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm New PIN'**
  String get confirmNewPin;

  /// No description provided for @pinChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Security PIN updated successfully'**
  String get pinChangedSuccess;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'New PINs do not match'**
  String get pinMismatch;

  /// No description provided for @pinLengthError.
  ///
  /// In en, this message translates to:
  /// **'PIN must be 4 digits'**
  String get pinLengthError;

  /// No description provided for @currentPinRequired.
  ///
  /// In en, this message translates to:
  /// **'Current PIN is required'**
  String get currentPinRequired;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @enterYourPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit PIN'**
  String get enterYourPin;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @failedToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update'**
  String get failedToUpdate;

  /// No description provided for @activeTab.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeTab;

  /// No description provided for @closedTab.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closedTab;

  /// No description provided for @noActiveEvents.
  ///
  /// In en, this message translates to:
  /// **'No active events at this time.'**
  String get noActiveEvents;

  /// No description provided for @noClosedEvents.
  ///
  /// In en, this message translates to:
  /// **'No closed events.'**
  String get noClosedEvents;

  /// No description provided for @couldNotLoadEvents.
  ///
  /// In en, this message translates to:
  /// **'Could not load events.'**
  String get couldNotLoadEvents;

  /// No description provided for @activeEventBadge.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE EVENT'**
  String get activeEventBadge;

  /// No description provided for @closedEventBadge.
  ///
  /// In en, this message translates to:
  /// **'CLOSED'**
  String get closedEventBadge;

  /// No description provided for @closingDate.
  ///
  /// In en, this message translates to:
  /// **'Closing Date'**
  String get closingDate;

  /// No description provided for @applyJoin.
  ///
  /// In en, this message translates to:
  /// **'Apply / Join'**
  String get applyJoin;

  /// No description provided for @ongoingFilter.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoingFilter;

  /// No description provided for @acceptedFilter.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedFilter;

  /// No description provided for @deniedFilter.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get deniedFilter;

  /// No description provided for @couldNotLoadRequests.
  ///
  /// In en, this message translates to:
  /// **'Could not load requests.'**
  String get couldNotLoadRequests;

  /// No description provided for @noRequestsForFilter.
  ///
  /// In en, this message translates to:
  /// **'No requests in this category.'**
  String get noRequestsForFilter;

  /// No description provided for @urgentBadge.
  ///
  /// In en, this message translates to:
  /// **'URGENT'**
  String get urgentBadge;

  /// No description provided for @acceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get acceptRequest;

  /// No description provided for @declineRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineRequest;

  /// No description provided for @acceptDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Accepting reveals your phone number to the hospital to coordinate donation.'**
  String get acceptDisclaimer;

  /// No description provided for @requestClosedExpired.
  ///
  /// In en, this message translates to:
  /// **'This blood request has closed or expired.'**
  String get requestClosedExpired;

  /// No description provided for @callHospital.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callHospital;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @communityFeed.
  ///
  /// In en, this message translates to:
  /// **'COMMUNITY FEED'**
  String get communityFeed;

  /// No description provided for @couldNotLoadFeed.
  ///
  /// In en, this message translates to:
  /// **'Could not load feed posts.'**
  String get couldNotLoadFeed;

  /// No description provided for @noFeedPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No feed posts yet.'**
  String get noFeedPostsYet;

  /// No description provided for @checkBackSoonUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check back soon for community updates.'**
  String get checkBackSoonUpdates;

  /// No description provided for @donationHistory.
  ///
  /// In en, this message translates to:
  /// **'Donation History'**
  String get donationHistory;

  /// No description provided for @couldNotLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Could not load donation history.'**
  String get couldNotLoadHistory;

  /// No description provided for @noDonationHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No donation history yet'**
  String get noDonationHistoryYet;

  /// No description provided for @pastDonationsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your past blood donation records will appear here.'**
  String get pastDonationsAppearHere;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @completedStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedStatus;

  /// No description provided for @nearbyCenters.
  ///
  /// In en, this message translates to:
  /// **'Nearby Blood Centers'**
  String get nearbyCenters;

  /// No description provided for @searchCenterHint.
  ///
  /// In en, this message translates to:
  /// **'Search center name or city...'**
  String get searchCenterHint;

  /// No description provided for @couldNotLoadCenters.
  ///
  /// In en, this message translates to:
  /// **'Could not load nearby blood centers.'**
  String get couldNotLoadCenters;

  /// No description provided for @noCentersFound.
  ///
  /// In en, this message translates to:
  /// **'No nearby blood centers found.'**
  String get noCentersFound;

  /// No description provided for @verifiedFacility.
  ///
  /// In en, this message translates to:
  /// **'Verified Facility'**
  String get verifiedFacility;

  /// No description provided for @callButton.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callButton;

  /// No description provided for @donationStats.
  ///
  /// In en, this message translates to:
  /// **'Donation Stats'**
  String get donationStats;

  /// No description provided for @totalDonations.
  ///
  /// In en, this message translates to:
  /// **'Total Donations'**
  String get totalDonations;

  /// No description provided for @lastDonation.
  ///
  /// In en, this message translates to:
  /// **'Last Donation'**
  String get lastDonation;

  /// No description provided for @totalVolume.
  ///
  /// In en, this message translates to:
  /// **'Total Volume'**
  String get totalVolume;

  /// No description provided for @verifiedDonor.
  ///
  /// In en, this message translates to:
  /// **'Verified Donor'**
  String get verifiedDonor;

  /// No description provided for @bloodTypeUnset.
  ///
  /// In en, this message translates to:
  /// **'Blood Type Unset'**
  String get bloodTypeUnset;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @legashMatchExplanation.
  ///
  /// In en, this message translates to:
  /// **'Legash matches you with emergency hospital requests in your area.'**
  String get legashMatchExplanation;

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get forgotPin;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your registered phone number.'**
  String get enterPhone;

  /// No description provided for @enterPin4Digits.
  ///
  /// In en, this message translates to:
  /// **'Please enter your 4-digit PIN.'**
  String get enterPin4Digits;

  /// No description provided for @createPinHeading.
  ///
  /// In en, this message translates to:
  /// **'Create your 4-digit PIN'**
  String get createPinHeading;

  /// No description provided for @confirmPinHeading.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get confirmPinHeading;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Please try again.'**
  String get pinsDoNotMatch;

  /// No description provided for @pinCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN created successfully! Welcome to Legash.'**
  String get pinCreatedSuccess;

  /// No description provided for @step1Of2.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2: Create PIN'**
  String get step1Of2;

  /// No description provided for @step2Of2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2: Confirm PIN'**
  String get step2Of2;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToTerms;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service & Privacy Policy'**
  String get termsOfService;

  /// No description provided for @gpsRequired.
  ///
  /// In en, this message translates to:
  /// **'GPS Location Required'**
  String get gpsRequired;

  /// No description provided for @locationAcquired.
  ///
  /// In en, this message translates to:
  /// **'Location Acquired'**
  String get locationAcquired;

  /// No description provided for @captureLocation.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get captureLocation;

  /// No description provided for @updateLocation.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateLocation;

  /// No description provided for @unknownBloodTypeCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know my blood type yet'**
  String get unknownBloodTypeCheckbox;

  /// No description provided for @termsAndPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Policy'**
  String get termsAndPolicyTitle;

  /// No description provided for @healthTab.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthTab;

  /// No description provided for @donorFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Donor FAQ & Guidelines'**
  String get donorFaqTitle;

  /// No description provided for @cautionAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'CAUTION'**
  String get cautionAlertTitle;

  /// No description provided for @cautionAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Note: These are only wellness tips and are not a substitute for real medical tests.'**
  String get cautionAlertBody;

  /// No description provided for @bloodCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Blood Compatibility'**
  String get bloodCompatibility;

  /// No description provided for @canDonateTo.
  ///
  /// In en, this message translates to:
  /// **'You can donate to'**
  String get canDonateTo;

  /// No description provided for @canReceiveFrom.
  ///
  /// In en, this message translates to:
  /// **'You can receive from'**
  String get canReceiveFrom;

  /// No description provided for @outgoingCompatibility.
  ///
  /// In en, this message translates to:
  /// **'OUTGOING COMPATIBILITY'**
  String get outgoingCompatibility;

  /// No description provided for @incomingCompatibility.
  ///
  /// In en, this message translates to:
  /// **'INCOMING COMPATIBILITY'**
  String get incomingCompatibility;

  /// No description provided for @universalDonorBadge.
  ///
  /// In en, this message translates to:
  /// **'Universal Red Cell Donor'**
  String get universalDonorBadge;

  /// No description provided for @universalRecipientBadge.
  ///
  /// In en, this message translates to:
  /// **'Universal Recipient'**
  String get universalRecipientBadge;

  /// No description provided for @discoverBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Discover Your Blood Group'**
  String get discoverBloodGroup;

  /// No description provided for @discoverBloodGroupDesc.
  ///
  /// In en, this message translates to:
  /// **'Knowing your blood type enables Legash to match you with urgent clinical requests in your area.'**
  String get discoverBloodGroupDesc;

  /// No description provided for @findBloodCenter.
  ///
  /// In en, this message translates to:
  /// **'Find a Blood Center'**
  String get findBloodCenter;

  /// No description provided for @updateInProfile.
  ///
  /// In en, this message translates to:
  /// **'Update in Profile'**
  String get updateInProfile;

  /// No description provided for @foodsForDonorsTab.
  ///
  /// In en, this message translates to:
  /// **'Foods for Donors'**
  String get foodsForDonorsTab;

  /// No description provided for @activityRestTab.
  ///
  /// In en, this message translates to:
  /// **'Activity & Rest'**
  String get activityRestTab;

  /// No description provided for @mindfulCareTab.
  ///
  /// In en, this message translates to:
  /// **'Mindful Care'**
  String get mindfulCareTab;

  /// No description provided for @dailyHabitsTab.
  ///
  /// In en, this message translates to:
  /// **'Daily Habits'**
  String get dailyHabitsTab;

  /// No description provided for @faqStillQuestions.
  ///
  /// In en, this message translates to:
  /// **'Still have questions?'**
  String get faqStillQuestions;

  /// No description provided for @faqAskHereAt.
  ///
  /// In en, this message translates to:
  /// **'If you have any other questions, ask here at admin@legash.com'**
  String get faqAskHereAt;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Blood, matched to where it\'s needed'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Desc.
  ///
  /// In en, this message translates to:
  /// **'Legash connects donors directly with nearby hospitals that need their blood type — no waiting rooms, no guessing.'**
  String get onboardingSlide1Desc;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Community Feed & Events'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Desc.
  ///
  /// In en, this message translates to:
  /// **'Follow live hospital updates and announcements on the Feed tab, and discover upcoming blood donation drives on the Events tab.'**
  String get onboardingSlide2Desc;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Share urgent requests'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Desc.
  ///
  /// In en, this message translates to:
  /// **'Multiply your impact by generating instant referral links for critical blood requests to share with fellow registered donors.'**
  String get onboardingSlide3Desc;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerificationTitle;

  /// No description provided for @verifyYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone'**
  String get verifyYourPhone;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit SMS verification code to'**
  String get otpSentTo;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Did not receive the code?'**
  String get didNotReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'A fresh 6-digit OTP has been sent to your phone.'**
  String get otpSentSuccess;

  /// No description provided for @phoneVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified! Now create your 4-digit PIN.'**
  String get phoneVerifiedSuccess;

  /// No description provided for @campaignDetails.
  ///
  /// In en, this message translates to:
  /// **'Campaign Details'**
  String get campaignDetails;

  /// No description provided for @organizedBy.
  ///
  /// In en, this message translates to:
  /// **'Organized by'**
  String get organizedBy;

  /// No description provided for @aboutThisCampaign.
  ///
  /// In en, this message translates to:
  /// **'About This Campaign'**
  String get aboutThisCampaign;

  /// No description provided for @donorPrepTips.
  ///
  /// In en, this message translates to:
  /// **'Donor Preparation Tips'**
  String get donorPrepTips;

  /// No description provided for @learnMoreRegister.
  ///
  /// In en, this message translates to:
  /// **'Learn More & Register'**
  String get learnMoreRegister;

  /// No description provided for @eventDetailsCopied.
  ///
  /// In en, this message translates to:
  /// **'Event details copied to clipboard!'**
  String get eventDetailsCopied;

  /// No description provided for @communityUpdate.
  ///
  /// In en, this message translates to:
  /// **'Community Update'**
  String get communityUpdate;

  /// No description provided for @verifiedNotice.
  ///
  /// In en, this message translates to:
  /// **'Verified Community Notice'**
  String get verifiedNotice;

  /// No description provided for @shareUpdate.
  ///
  /// In en, this message translates to:
  /// **'Share Update with Friends & Family'**
  String get shareUpdate;

  /// No description provided for @updateCopied.
  ///
  /// In en, this message translates to:
  /// **'Update copied to clipboard!'**
  String get updateCopied;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get noNotificationsYet;

  /// No description provided for @couldNotLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Could not load notifications.'**
  String get couldNotLoadNotifications;

  /// No description provided for @viewRequest.
  ///
  /// In en, this message translates to:
  /// **'View Request'**
  String get viewRequest;

  /// No description provided for @joinLegash.
  ///
  /// In en, this message translates to:
  /// **'Join Legash'**
  String get joinLegash;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register as a verified blood donor and save lives.'**
  String get registerSubtitle;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @locationMatchNotice.
  ///
  /// In en, this message translates to:
  /// **'Please capture your current location to match with nearby blood requests.'**
  String get locationMatchNotice;

  /// No description provided for @agreeToTermsNotice.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms & Privacy Policy to continue.'**
  String get agreeToTermsNotice;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Phone number is already registered.'**
  String get phoneAlreadyRegistered;

  /// No description provided for @bloodTypeInfoNotice.
  ///
  /// In en, this message translates to:
  /// **'You can find your blood type at your nearest hospital or donation center and update it in your profile anytime.'**
  String get bloodTypeInfoNotice;

  /// No description provided for @callFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start phone call.'**
  String get callFailed;

  /// No description provided for @directionsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open map directions.'**
  String get directionsFailed;

  /// No description provided for @verifiedCentersAppear.
  ///
  /// In en, this message translates to:
  /// **'Verified blood donation centers will appear here.'**
  String get verifiedCentersAppear;

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneNumber;

  /// No description provided for @enterNewPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your new phone number.'**
  String get enterNewPhoneNumber;

  /// No description provided for @confirmPhoneChange.
  ///
  /// In en, this message translates to:
  /// **'Confirm Phone Change'**
  String get confirmPhoneChange;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// No description provided for @confirmAndUpdate.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Update'**
  String get confirmAndUpdate;

  /// No description provided for @pinResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN reset successfully. Please log in with your new PIN.'**
  String get pinResetSuccess;

  /// No description provided for @pinNotSet.
  ///
  /// In en, this message translates to:
  /// **'PIN has not been set for this account.'**
  String get pinNotSet;

  /// No description provided for @accountNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Account is not verified yet.'**
  String get accountNotVerified;

  /// No description provided for @enterPhoneForReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we will send you an OTP to reset your PIN.'**
  String get enterPhoneForReset;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @onboardingSlide4Title.
  ///
  /// In en, this message translates to:
  /// **'Your Health & Compatibility'**
  String get onboardingSlide4Title;

  /// No description provided for @onboardingSlide4Desc.
  ///
  /// In en, this message translates to:
  /// **'Visualize your blood compatibility directly on your dashboard, and explore personalized wellness and nutrition tips.'**
  String get onboardingSlide4Desc;

  /// No description provided for @onboardingSlide5Title.
  ///
  /// In en, this message translates to:
  /// **'24/7 AI Health Assistant'**
  String get onboardingSlide5Title;

  /// No description provided for @onboardingSlide5Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the floating assistant anytime to get quick answers on donation eligibility, post-donation recovery, and wellness.'**
  String get onboardingSlide5Desc;

  /// No description provided for @onboardingSlide6Title.
  ///
  /// In en, this message translates to:
  /// **'Verified, secure, and private'**
  String get onboardingSlide6Title;

  /// No description provided for @onboardingSlide6Desc.
  ///
  /// In en, this message translates to:
  /// **'Every hospital and donor is verified before connecting. Your phone number stays private until you choose to respond.'**
  String get onboardingSlide6Desc;

  /// No description provided for @onboardingSlide7Title.
  ///
  /// In en, this message translates to:
  /// **'Ready to save a life?'**
  String get onboardingSlide7Title;

  /// No description provided for @onboardingSlide7Desc.
  ///
  /// In en, this message translates to:
  /// **'Takes about two minutes to set up your profile and get matched.'**
  String get onboardingSlide7Desc;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @activeCampaign.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE CAMPAIGN'**
  String get activeCampaign;

  /// No description provided for @campaignClosed.
  ///
  /// In en, this message translates to:
  /// **'CAMPAIGN CLOSED'**
  String get campaignClosed;

  /// No description provided for @registrationAvailableAtCenter.
  ///
  /// In en, this message translates to:
  /// **'Registration Available at Center'**
  String get registrationAvailableAtCenter;

  /// No description provided for @applyRegisterToDonate.
  ///
  /// In en, this message translates to:
  /// **'Apply / Register to Donate'**
  String get applyRegisterToDonate;

  /// No description provided for @updateBadge.
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get updateBadge;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyAndContinue;

  /// No description provided for @otpConfidentialNote.
  ///
  /// In en, this message translates to:
  /// **'Your OTP is confidential. Never forward or share this code with anyone.'**
  String get otpConfidentialNote;

  /// No description provided for @enterAll6Digits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 digits.'**
  String get enterAll6Digits;

  /// No description provided for @invalidVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code.'**
  String get invalidVerificationCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get resendCodeIn;

  /// No description provided for @pinStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose a memorable 4-digit PIN to securely unlock the Legash app on this device.'**
  String get pinStep1Desc;

  /// No description provided for @pinStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Please re-enter the same 4-digit PIN to confirm.'**
  String get pinStep2Desc;

  /// No description provided for @showPin.
  ///
  /// In en, this message translates to:
  /// **'Show PIN'**
  String get showPin;

  /// No description provided for @hidePin.
  ///
  /// In en, this message translates to:
  /// **'Hide PIN'**
  String get hidePin;

  /// No description provided for @changeInitialPin.
  ///
  /// In en, this message translates to:
  /// **'Change initial PIN'**
  String get changeInitialPin;

  /// No description provided for @continueToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Continue to Confirm'**
  String get continueToConfirm;

  /// No description provided for @confirmAndSavePin.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Save PIN'**
  String get confirmAndSavePin;

  /// No description provided for @pinConfidentialNote.
  ///
  /// In en, this message translates to:
  /// **'Your PIN is securely hashed and protected. Never share your PIN with anyone.'**
  String get pinConfidentialNote;

  /// No description provided for @enterAll4Digits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 4 digits.'**
  String get enterAll4Digits;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @setPinButton.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPinButton;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @setNewPin.
  ///
  /// In en, this message translates to:
  /// **'Set New PIN'**
  String get setNewPin;

  /// No description provided for @chooseNewPin.
  ///
  /// In en, this message translates to:
  /// **'Choose a new 4-digit PIN.'**
  String get chooseNewPin;

  /// No description provided for @resetPin.
  ///
  /// In en, this message translates to:
  /// **'Reset PIN'**
  String get resetPin;

  /// No description provided for @pinMustBe4Digits.
  ///
  /// In en, this message translates to:
  /// **'PIN must be 4 digits'**
  String get pinMustBe4Digits;

  /// No description provided for @pinDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'PIN must be digits only'**
  String get pinDigitsOnly;

  /// No description provided for @pinsDoNotMatchShort.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinsDoNotMatchShort;

  /// No description provided for @changePhoneInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your new phone number. We will send an authorization code to your current registered number.'**
  String get changePhoneInstruction;

  /// No description provided for @newPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'New Phone Number'**
  String get newPhoneNumberLabel;

  /// No description provided for @phoneRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required.'**
  String get phoneRequiredError;

  /// No description provided for @confirmPhoneChangeInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your current phone to confirm changing your number.'**
  String get confirmPhoneChangeInstruction;

  /// No description provided for @verificationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCodeLabel;

  /// No description provided for @enter6DigitCodeError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 6-digit code.'**
  String get enter6DigitCodeError;

  /// No description provided for @phoneUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone number updated successfully.'**
  String get phoneUpdatedSuccess;
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
      <String>['am', 'en', 'om'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
    case 'om':
      return AppLocalizationsOm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
