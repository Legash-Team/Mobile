import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:egash_mobile/models/donor_model.dart';
import 'package:egash_mobile/providers/auth_provider.dart';
import 'package:egash_mobile/providers/locale_provider.dart';
import 'package:egash_mobile/screens/donor_faq_screen.dart';
import 'package:egash_mobile/screens/health_screen.dart';
import 'package:egash_mobile/utils/wellness_content.dart';
import 'package:egash_mobile/widgets/blood_compatibility_card.dart';

Widget createLocalizedTestApp({
  required Widget child,
  required Locale locale,
  DonorInfo? mockDonor,
}) {
  final auth = AuthProvider();
  if (mockDonor != null) {
    auth.updateDonor(mockDonor);
  }

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>.value(value: auth),
      ChangeNotifierProvider<LocaleProvider>(
        create: (_) => LocaleProvider(locale.languageCode),
      ),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: LocaleProvider.supportedLocales,
      localizationsDelegates: LocaleProvider.localizationsDelegates,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Multilingual Wellness Content Tests', () {
    test('English wellness profile content returns English text', () {
      final wellness = getWellnessForBloodType('O+', 'en');
      expect(wellness.engagementNote, contains('O+ is the most prevalent blood type'));
      expect(wellness.foods.first.title, contains('Iron-Rich Foods'));
      expect(wellness.activities.first.title, contains('Immediate Post-Donation Rest'));
    });

    test('Amharic wellness profile content returns Amharic text', () {
      final wellness = getWellnessForBloodType('O+', 'am');
      expect(wellness.engagementNote, contains('O+ በብዙ ማህበረሰቦች ውስጥ'));
      expect(wellness.foods.first.title, contains('ለጤናማ ሄሞግሎቢን በብረት የበለፀጉ ምግቦች'));
      expect(wellness.activities.first.title, contains('ከልገሳ በኋላ ወዲያውኑ የሚደረግ እረፍት'));
    });

    test('Afaan Oromoo wellness profile content returns Afaan Oromoo text', () {
      final wellness = getWellnessForBloodType('O+', 'om');
      expect(wellness.engagementNote, contains('O+ hawaasa baay\'ee keessatti'));
      expect(wellness.foods.first.title, contains('Nyaatawwan Sibiilaan Badhaadhan'));
      expect(wellness.activities.first.title, contains('Boqonnaa Battalaa Arjooma Boodaa'));
    });
  });

  group('Multilingual BloodCompatibilityCard Widget Tests', () {
    testWidgets('Renders in Amharic when locale is am', (tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(
          child: const BloodCompatibilityCard(bloodType: 'A+'),
          locale: const Locale('am'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('የደም ተኳሃኝነት'), findsOneWidget);
      expect(find.text('ለደም ቡድንዎ የ ABO እና Rh ደም መስጠት/መቀበል ተኳሃኝነት፦'), findsOneWidget);
      expect(find.text('ለነዚህ መለገስ ይችላሉ'), findsOneWidget);
      expect(find.text('ከነዚህ መቀበል ይችላሉ'), findsOneWidget);
      expect(find.text('(እርስዎ)'), findsWidgets);
    });

    testWidgets('Renders in Afaan Oromoo when locale is om', (tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(
          child: const BloodCompatibilityCard(bloodType: 'A+'),
          locale: const Locale('om'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Walsimsiisa Dhiigaa'), findsOneWidget);
      expect(find.text('Kanneeniif arjoomuu dandeessu'), findsOneWidget);
      expect(find.text('Kanneen irraa fudhachuu dandeessu'), findsOneWidget);
      expect(find.text('(Isin)'), findsWidgets);
    });
  });

  group('Multilingual HealthScreen Widget Tests', () {
    testWidgets('Renders Amharic tabs and caution in Amharic locale', (tester) async {
      final mockDonor = DonorInfo(
        id: 'donor-1',
        name: 'Abebe Bikila',
        phone: '+251911223344',
        bloodType: 'O+',
      );

      await tester.pumpWidget(
        createLocalizedTestApp(
          child: const HealthScreen(isActive: true),
          locale: const Locale('am'),
          mockDonor: mockDonor,
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('ጤና እና ደህንነት'), findsOneWidget);
      expect(find.text('ማስጠንቀቂያ'), findsOneWidget);
      expect(find.text('የለጋሾች ምግቦች'), findsOneWidget);
      expect(find.text('እንቅስቃሴ እና እረፍት'), findsOneWidget);
      expect(find.text('ጥንቃቄ እና ክትትል'), findsOneWidget);
      expect(find.text('ዕለታዊ ልማዶች'), findsOneWidget);
    });

    testWidgets('Renders Afaan Oromoo tabs and caution in Afaan Oromoo locale', (tester) async {
      final mockDonor = DonorInfo(
        id: 'donor-1',
        name: 'Derartu Tulu',
        phone: '+251911223344',
        bloodType: 'O+',
      );

      await tester.pumpWidget(
        createLocalizedTestApp(
          child: const HealthScreen(isActive: true),
          locale: const Locale('om'),
          mockDonor: mockDonor,
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Fayyaa & Nageenya'), findsOneWidget);
      expect(find.text('OFEGGEENNOO'), findsOneWidget);
      expect(find.text('Nyaata Arjoomtootaaf'), findsOneWidget);
      expect(find.text('Sochii & Boqonnaa'), findsOneWidget);
      expect(find.text('Xiyyeeffannoo & Qorannoo'), findsOneWidget);
      expect(find.text('Amaloota Guyyuu'), findsOneWidget);
    });
  });

  group('Multilingual DonorFaqScreen Widget Tests', () {
    testWidgets('Renders Amharic questions and categories in Amharic locale', (tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(
          child: const DonorFaqScreen(),
          locale: const Locale('am'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('የለጋሽ ተደጋጋሚ ጥያቄዎች እና መመሪያዎች'), findsOneWidget);
      expect(find.text('ሁሉም'), findsOneWidget);
      expect(find.text('ምዝገባ እና መግቢያ'), findsWidgets);
      expect(find.textContaining('እንዴት እንደ ለጋሽ እመዘገባለሁ'), findsOneWidget);
    });

    testWidgets('Renders Afaan Oromoo questions and categories in Afaan Oromoo locale', (tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(
          child: const DonorFaqScreen(),
          locale: const Locale('om'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Gaaffilee Arjoomaa & Qajeelfamoota'), findsOneWidget);
      expect(find.text('Hunda'), findsOneWidget);
      expect(find.text('Galmee & Seensa'), findsWidgets);
      expect(find.textContaining('Akkamitti akka arjoomaatti galmaa\'ee'), findsOneWidget);
    });
  });
}
