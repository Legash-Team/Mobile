import 'package:flutter/material.dart';
import '../constants.dart';

class TermsPolicyScreen extends StatelessWidget {
  const TermsPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text('Terms & Policy'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _lastUpdated(theme),
            const SizedBox(height: AppSpacing.xl),
            _sectionTitle(theme, 'Your data and privacy'),
            const SizedBox(height: AppSpacing.sm),
            _bodyText(
              theme,
              'We are committed to protecting your privacy.\n\n'
              'This section explains how we collect, use, and safeguard your personal '
              'information when you use our services. We only collect data necessary '
              'to provide and improve the LEGASH experience.\n\n'
              'Your health information, including blood type and donation history, is '
              'encrypted and stored securely. We adhere strictly to national health '
              'data regulations to ensure your sensitive information remains confidential.',
            ),
            const SizedBox(height: AppSpacing.lg),
            _sectionTitle(theme, 'How your information is shared'),
            const SizedBox(height: AppSpacing.sm),
            _bodyText(
              theme,
              'LEGASH does not sell your personal data to third parties. Your '
              'information is only shared when necessary to facilitate a blood '
              'donation request or to comply with legal obligations.\n\n'
              'When you respond to a donation request, your contact details may be '
              'shared with the requesting party or the partner hospital, only with '
              'your explicit consent for that specific transaction.',
            ),
            const SizedBox(height: AppSpacing.lg),
            _sectionTitle(theme, 'Account verification'),
            const SizedBox(height: AppSpacing.sm),
            _bodyText(
              theme,
              'To ensure the safety and integrity of the LEGASH community, all '
              'accounts must undergo a verification process. This may involve '
              'confirming your phone number, email address, or identity via '
              'government-issued ID.\n\n'
              'Unverified accounts may face restrictions in interacting with active '
              'requests or making direct contact with other users.',
            ),
            const SizedBox(height: AppSpacing.lg),
            _sectionTitle(theme, 'User Responsibilities'),
            const SizedBox(height: AppSpacing.sm),
            _bodyText(
              theme,
              'By using this app, you agree to provide accurate and up-to-date '
              'health information. You acknowledge that providing false information '
              'regarding your donation eligibility can have serious medical '
              'consequences.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _bulletItem(theme, 'Maintain the confidentiality of your account credentials.'),
            const SizedBox(height: AppSpacing.xs),
            _bulletItem(theme, 'Respect the privacy and circumstances of other users.'),
            const SizedBox(height: AppSpacing.xs),
            _bulletItem(
              theme,
              'Report any suspicious activity or violations of these terms immediately.',
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _lastUpdated(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.paperDim,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        'Last updated: October 24, 2023',
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          fontFamily: AppFonts.mono,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        color: AppColors.crimson,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 24 / 18,
      ),
    );
  }

  Widget _bodyText(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: AppColors.textPrimary,
        height: 26 / 17,
        fontSize: 15,
      ),
    );
  }

  Widget _bulletItem(ThemeData theme, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 6, color: AppColors.crimson),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 22 / 15,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}