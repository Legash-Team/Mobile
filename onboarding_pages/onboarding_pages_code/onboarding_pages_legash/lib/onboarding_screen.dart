import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//design template

//color style
abstract final class OnboardingColor {
  static const ink = Color(0xFF1B1410);
  static const inkSoft = Color(0xFF4A4038);
  static const paper = Color(0xFFFAF6F0);
  static const paperDim = Color(0xFFF2EBE1);
  static const sand = Color(0xFFEAE0D0);
  static const crimson = Color(0xFFC31F3B);
  static const crimsonDark = Color(0xFF8F1329);
  static const verified = Color(0xFF1F6F5C);
}

abstract final class OnboardingRadius {
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const pill = 999.0;
}

abstract final class OnboardingSpace {
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

//text style
abstract final class OnboardingFont {
  static const sans = 'IBMPlexSans';
  static const mono = 'IBMPlexMono';
}

abstract final class OnboardingText {
  static TextStyle h1({Color? color}) => TextStyle(
    fontFamily: OnboardingFont.sans,
    fontSize: 34,
    height: 40 / 34,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.ink,
  );

  static TextStyle h2({Color? color}) => TextStyle(
    fontFamily: OnboardingFont.sans,
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.ink,
  );

  static TextStyle h3({Color? color}) => TextStyle(
    fontFamily: OnboardingFont.sans,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.ink,
  );

  static TextStyle lede({Color? color}) => TextStyle(
    fontFamily: OnboardingFont.sans,
    fontSize: 17,
    height: 26 / 17,
    fontWeight: FontWeight.w400,
    color: color ?? OnboardingColor.inkSoft,
  );

  static TextStyle medium({Color? color}) => TextStyle(
    fontFamily: OnboardingFont.sans,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
    color: color ?? OnboardingColor.inkSoft,
  );

  static TextStyle small({Color? color}) => TextStyle(
    fontFamily: OnboardingFont.sans,
    fontSize: 13,
    height: 20 / 13,
    fontWeight: FontWeight.w400,
    color: color ?? OnboardingColor.inkSoft,
  );

  static TextStyle button({Color? color}) => TextStyle(
    fontFamily: OnboardingFont.sans,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
  );

  static TextStyle monoNumeric({Color? color}) => TextStyle(
    fontFamily: OnboardingFont.mono,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.ink,
  );

  static TextStyle monoChip({Color? color}) => TextStyle(
    fontFamily: OnboardingFont.mono,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: color ?? OnboardingColor.inkSoft,
  );
}

//SVGs
abstract final class OnboardingSvg {
  static const onboardingNetwork = 'assets/svg/onboarding_network.svg';
  static const onboardingShield = 'assets/svg/onboarding_shield.svg';
  static const onboardingStar = 'assets/svg/onboarding_star.svg';
  static const logoLegash = 'assets/svg/logo_legash.svg';
}

//main widget
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 4;

  void _goToPage(int index) {
    if (index < 0 || index >= _totalPages) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingColor.paper,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: -_totalPages,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OnboardingRadius.lg,
                  ),
                  //child: _buildSlide(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OnboardingRadius.md,
        OnboardingRadius.sm,
        OnboardingRadius.md,
        0,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: _currentPage < _totalPages - 1
            ? TextButton(
                onPressed: () => _goToPage(_totalPages - 1),
                style: TextButton.styleFrom(
                  foregroundColor: OnboardingColor.inkSoft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: OnboardingRadius.sm,
                    vertical: OnboardingSpace.xs,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('Skip', style: OnboardingText.medium()),
              )
            : const SizedBox(height: 48),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OnboardingSpace.lg,
        0,
        OnboardingSpace.lg,
        OnboardingSpace.xl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PageIndicatorDots(
            current: _currentPage,
            total: _totalPages,
            onTap: _goToPage,
          ),
          OnboardingNavArrow(
            isLastPage: _currentPage == _totalPages - 1,
            onTap: () {
              if (_currentPage < _totalPages - 1) {
                _goToPage(_currentPage + 1);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(int index) {
    return switch (index) {
      0 => const OnboardingScreen1(),
      1 => const OnboardingScreen2(),
      2 => const OnboardingScreen3(),
      3 => const OnboardingScreen4(),
      _ => const SizedBox.shrink(),
    };
  }
}

class PageIndicatorDots extends StatelessWidget {
  final int current;
  final int total;
  final ValueChanged<int> onTap;

  const PageIndicatorDots({
    super.key,
    required this.current,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final active = i == current;
        return GestureDetector(
          onTap: () => onTap(i),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? OnboardingColor.crimson : OnboardingColor.sand,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

class OnboardingNavArrow extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onTap;

  const OnboardingNavArrow({
    super.key,
    required this.isLastPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: OnboardingColor.crimson,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isLastPage ? Icons.check_rounded : Icons.arrow_forward_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}




//screens

class _ScreenScaffold extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String subtitle;
  final Widget? below; // e.g. CTA buttons on slide 4

  const _ScreenScaffold({
    required this.illustration,
    required this.title,
    required this.subtitle,
    this.below,
  });

   @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        illustration,
        const Spacer(flex: 1),
        Text(title, style: OnboardingText.h2(), textAlign: TextAlign.center),
        const SizedBox(height: OnboardingSpace.md),
        Text(subtitle, style: OnboardingText.lede(), textAlign: TextAlign.center),
        if (below != null) ...[
          const SizedBox(height: OnboardingSpace.xl),
          below!,
        ],
        const Spacer(flex: 3),
      ],
    );
  }
}


//screen1
class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScreenScaffold(
      illustration: SvgPicture.asset(
        OnboardingSvg.onboardingNetwork,
        width: 260,
        height: 260,
        fit: BoxFit.contain,
      ),
      title: "Blood, matched to where it's needed",
      subtitle:
          'LEGASH connects donors directly with nearby hospitals that need their blood type — no waiting rooms, no guessing.',
    );
  }
}

//screen2
class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//screen3
class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//screen4
class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}