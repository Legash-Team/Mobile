import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'providers/auth_provider.dart';
import 'screens/register_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/terms_policy_screen.dart';
import 'screens/login_screen.dart';
import 'screens/donor_home_shell.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const LegashApp());
}

class LegashApp extends StatelessWidget {
  const LegashApp({super.key});

  Future<bool> _checkOnboarding() => OnboardingScreen.isCompleted();

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
              borderSide: BorderSide(color: AppColors.crimson, width: 2),
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
          future: _checkOnboarding(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                backgroundColor: AppColors.paper,
                body: Center(child: CircularProgressIndicator(color: AppColors.crimson)),
              );
            }
            final completed = snapshot.data!;
            return completed ? const LoginScreen() : const OnboardingScreen();
          },
        ),
        routes: {
          '/login': (_) => const LoginScreen(),
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
          return null;
        },
      ),
    );
  }
}
