import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String _completedKey = 'onboarding_completed';

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completedKey) ?? false;
  }

  static Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completedKey, true);
  }

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 7;

  _OnboardingPage _buildPage(int index, AppLocalizations? l10n) {
    switch (index) {
      case 0:
        return _OnboardingPage(
          icon: Icons.water_drop_rounded,
          title: l10n?.onboardingSlide1Title ?? "Blood, matched to where it's needed",
          subtitle: l10n?.onboardingSlide1Desc ??
              "Legash connects donors directly with nearby hospitals that need their blood type \u2014 no waiting rooms, no guessing.",
        );
      case 1:
        return _OnboardingPage(
          icon: Icons.dynamic_feed_rounded,
          title: l10n?.onboardingSlide2Title ?? "Community Feed & Events",
          subtitle: l10n?.onboardingSlide2Desc ??
              "Follow live hospital updates and announcements on the Feed tab, and discover upcoming blood donation drives on the Events tab.",
        );
      case 2:
        return _OnboardingPage(
          icon: Icons.share_rounded,
          title: l10n?.onboardingSlide3Title ?? "Share urgent requests",
          subtitle: l10n?.onboardingSlide3Desc ??
              "Multiply your impact by generating instant referral links for critical blood requests to share with fellow registered donors.",
        );
      case 3:
        return _OnboardingPage(
          icon: Icons.health_and_safety_rounded,
          title: l10n?.onboardingSlide4Title ?? "Your Health & Compatibility",
          subtitle: l10n?.onboardingSlide4Desc ??
              "Visualize your blood compatibility directly on your dashboard, and explore personalized wellness and nutrition tips.",
        );
      case 4:
        return _OnboardingPage(
          icon: Icons.smart_toy_rounded,
          title: l10n?.onboardingSlide5Title ?? "24/7 AI Health Assistant",
          subtitle: l10n?.onboardingSlide5Desc ??
              "Tap the floating assistant anytime to get quick answers on donation eligibility, post-donation recovery, and wellness.",
        );
      case 5:
        return _OnboardingPage(
          icon: Icons.verified_user_rounded,
          title: l10n?.onboardingSlide6Title ?? "Verified, secure, and private",
          subtitle: l10n?.onboardingSlide6Desc ??
              "Every hospital and donor is verified before connecting. Your phone number stays private until you choose to respond.",
        );
      case 6:
      default:
        return _OnboardingPage(
          icon: Icons.favorite_rounded,
          title: l10n?.onboardingSlide7Title ?? "Ready to save a life?",
          subtitle: l10n?.onboardingSlide7Desc ??
              "Takes about two minutes to set up your profile and get matched.",
          isLast: true,
        );
    }
  }

  void _goToPage(int index) {
    if (index < 0 || index >= _totalPages) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  void _complete() {
    OnboardingScreen.markCompleted();
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Column(
          children: [
            _buildSkip(l10n),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _totalPages,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppRadius.lg),
                  child: _buildPage(index, l10n),
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkip(AppLocalizations? l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: _currentPage < _totalPages - 1
            ? TextButton(
                onPressed: () => _goToPage(_totalPages - 1),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(l10n?.skip ?? 'Skip', style: const TextStyle(fontSize: 15)),
              )
            : const SizedBox(height: 48),
      ),
    );
  }

  Widget _buildBottomNav() {
    final isLastPage = _currentPage == _totalPages - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: isLastPage
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPageDots(),
                const SizedBox(width: 16),
                _buildNavCircle(icon: Icons.check_rounded, onTap: _complete),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPageDots(),
                _buildNavCircle(
                  icon: Icons.arrow_forward_rounded,
                  onTap: () => _goToPage(_currentPage + 1),
                ),
              ],
            ),
    );
  }

  Widget _buildPageDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_totalPages, (i) {
        final active = i == _currentPage;
        return GestureDetector(
          onTap: () => _goToPage(i),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? AppColors.crimson : AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNavCircle({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColors.crimson,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _OnboardingPage extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  State<_OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<_OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _ringAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutSine),
    );

    _ringAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  disableAnimations
                      ? Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.crimson.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(widget.icon, size: 56, color: AppColors.crimson),
                        )
                      : AnimatedBuilder(
                          animation: _animController,
                          builder: (context, child) {
                            return SizedBox(
                              width: 140,
                              height: 140,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Pulsing outer ripple ring
                                  Transform.scale(
                                    scale: _ringAnimation.value,
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.crimson.withValues(
                                            alpha: (1.0 - _animController.value) * 0.35,
                                          ),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Heartbeat pulsing icon bubble
                                  Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: AppColors.crimson.withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.crimson.withValues(
                                              alpha: 0.15 * _animController.value,
                                            ),
                                            blurRadius: 18,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(widget.icon, size: 56, color: AppColors.crimson),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 32),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 24,
                      height: 30 / 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 17,
                        height: 26 / 17,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (widget.isLast) ...[
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          OnboardingScreen.markCompleted();
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.crimson,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)?.createAccount ?? 'Create an account',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          OnboardingScreen.markCompleted();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          side: const BorderSide(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)?.alreadyHaveAccount ?? 'I already have an account',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
