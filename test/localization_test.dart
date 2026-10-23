import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:egash_mobile/l10n/app_localizations.dart';
import 'package:egash_mobile/models/donor_model.dart';
import 'package:egash_mobile/providers/auth_provider.dart';
import 'package:egash_mobile/providers/locale_provider.dart';
import 'package:egash_mobile/screens/profile_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppLocalizations & LocaleProvider', () {
    testWidgets('AppLocalizations correctly loads strings in English, Amharic, and Oromo', (tester) async {
      final expectations = {
        'en': {
          'appTitle': 'Legash',
          'language': 'Language',
          'profileTab': 'Profile',
          'goodMorning': 'Good morning',
        },
        'am': {
          'appTitle': 'ለጋሽ',
          'language': 'ቋንቋ',
          'profileTab': 'መገለጫ',
          'goodMorning': 'እንደምን አደሩ',
        },
        'om': {
          'appTitle': 'Legaash',
          'language': 'Afaan',
          'profileTab': 'Piroofayilii',
          'goodMorning': 'Akkam bulte',
        },
      };

      for (final entry in expectations.entries) {
        final langCode = entry.key;
        final expectedMap = entry.value;

        late AppLocalizations localizations;

        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(langCode),
            localizationsDelegates: LocaleProvider.localizationsDelegates,
            supportedLocales: LocaleProvider.supportedLocales,
            home: Builder(
              builder: (context) {
                localizations = AppLocalizations.of(context)!;
                return Column(
                  children: [
                    Text(localizations.appTitle),
                    Text(localizations.language),
                    Text(localizations.profileTab),
                    Text(localizations.goodMorning),
                  ],
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(localizations.appTitle, expectedMap['appTitle']);
        expect(localizations.language, expectedMap['language']);
        expect(localizations.profileTab, expectedMap['profileTab']);
        expect(localizations.goodMorning, expectedMap['goodMorning']);

        expect(find.text(expectedMap['appTitle']!), findsOneWidget);
        expect(find.text(expectedMap['language']!), findsOneWidget);
        expect(find.text(expectedMap['profileTab']!), findsOneWidget);
        expect(find.text(expectedMap['goodMorning']!), findsOneWidget);
      }
    });

    test('LocaleProvider initializes default, updates, and persists to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      final provider = LocaleProvider();
      expect(provider.locale.languageCode, 'en');

      // Change to Amharic
      await provider.setLocale(const Locale('am'));
      expect(provider.locale.languageCode, 'am');

      // Check SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(LocaleProvider.localePrefKey), 'am');

      // Change to Oromo
      await provider.setLocale(const Locale('om'));
      expect(provider.locale.languageCode, 'om');
      expect(prefs.getString(LocaleProvider.localePrefKey), 'om');

      // Boot test with saved locale code
      final loadedCode = await LocaleProvider.getSavedLocaleCode();
      expect(loadedCode, 'om');

      final newBootProvider = LocaleProvider(loadedCode);
      expect(newBootProvider.locale.languageCode, 'om');
    });

    testWidgets('ProfileScreen shows language selector and switches locale immediately', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final authProvider = AuthProvider();
      await authProvider.login(
        'mock-token',
        DonorInfo(
          id: 'donor-1',
          name: 'Abebe Kebede',
          phone: '+251911223344',
          bloodType: 'A+',
          gender: 'male',
        ),
      );
      final localeProvider = LocaleProvider('en');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
          ],
          child: Consumer<LocaleProvider>(
            builder: (context, locProv, _) {
              return MaterialApp(
                locale: locProv.locale,
                localizationsDelegates: LocaleProvider.localizationsDelegates,
                supportedLocales: LocaleProvider.supportedLocales,
                home: const ProfileScreen(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // In English, Profile screen should show "Language" and "English"
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Personal Details'), findsOneWidget);

      // Tap the Language tile
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Bottom sheet should open with title "Select Language" and choices
      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('አማርኛ'), findsOneWidget);
      expect(find.text('Afaan Oromoo'), findsOneWidget);

      // Select Amharic
      await tester.tap(find.text('አማርኛ'));
      await tester.pumpAndSettle();

      // Active locale must now be 'am'
      expect(localeProvider.locale.languageCode, 'am');

      // Screen should immediately reflect Amharic without restart:
      // "ቋንቋ" for Language, "የግል ዝርዝሮች" for Personal Details
      expect(find.text('ቋንቋ'), findsOneWidget);
      expect(find.text('የግል ዝርዝሮች'), findsOneWidget);

      // Tap Language again to switch to Afaan Oromoo
      await tester.tap(find.text('ቋንቋ'));
      await tester.pumpAndSettle();

      expect(find.text('ቋንቋ ይምረጡ'), findsOneWidget);
      await tester.tap(find.text('Afaan Oromoo'));
      await tester.pumpAndSettle();

      // Active locale must now be 'om'
      expect(localeProvider.locale.languageCode, 'om');
      expect(find.text('Afaan'), findsOneWidget);
      expect(find.text('Odeeffannoo Dhuunfaa'), findsOneWidget);
    });
  });
}
