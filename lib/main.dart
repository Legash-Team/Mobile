import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/register_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/terms_policy_screen.dart';
import 'screens/set_pin_screen.dart';
import 'screens/pin_unlock_screen.dart';
import 'screens/donor_home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FcmService.initialize();
  runApp(const LegashApp());
}

class LegashApp extends StatefulWidget {
  const LegashApp({super.key});

  @override
  State<LegashApp> createState() => _LegashAppState();
}

class _LegashAppState extends State<LegashApp> {
  late Future<bool> _onboardingFuture;

  @override
  void initState() {
    super.initState();
    _onboardingFuture = OnboardingScreen.isCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Legash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.crimson,
            primary: AppColors.crimson,
            error: AppColors.crimson,
            surface: AppColors.surface,
          ),
          scaffoldBackgroundColor: AppColors.paper,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.paper,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: false,
          ),
          fontFamily: AppFonts.sans,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.borderFocused, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.crimson, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.crimson, width: 2),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.crimson,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        home: FutureBuilder<bool>(
          future: _onboardingFuture,
          builder: (context, onboardingSnapshot) {
            if (!onboardingSnapshot.hasData) {
              return const Scaffold(
                backgroundColor: AppColors.paper,
                body: Center(child: CircularProgressIndicator(color: AppColors.crimson)),
              );
            }
            final onboardingDone = onboardingSnapshot.data!;
            if (!onboardingDone) return const OnboardingScreen();

            return Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (!auth.initialized) {
                  return const Scaffold(
                    backgroundColor: AppColors.paper,
                    body: Center(child: CircularProgressIndicator(color: AppColors.crimson)),
                  );
                }
                if (auth.isLoggedIn) return const DonorHomeShell();
                return const PinUnlockScreen();
              },
            );
          },
        ),
        routes: {
          '/login': (_) => const PinUnlockScreen(),
          '/register': (_) => const RegisterScreen(),
          '/terms': (_) => const TermsPolicyScreen(),
          '/dashboard': (_) => const DonorHomeShell(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/otp') {
            final phone = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(phone: phone),
            );
          }
          if (settings.name == '/set-pin') {
            final phone = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => SetPinScreen(phone: phone),
            );
          }
          return null;
        },
      ),
    );
  }
}
