import 'package:flutter/material.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../screens/nearby_centers_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/blood_compatibility.dart';

class BloodCompatibilityCard extends StatelessWidget {
  final String? bloodType;

  const BloodCompatibilityCard({
    super.key,
    required this.bloodType,
  });

  @override
  Widget build(BuildContext context) {
    final isKnown = isBloodTypeKnown(bloodType);
    final normalized = normalizeBloodType(bloodType);

    // Subtle entrance animation using Flutter's built-in TweenAnimationBuilder
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1.0 - value)),
            child: child,
          ),
        );
      },
      child: isKnown && normalized != null
          ? _buildKnownCard(context, normalized)
          : _buildUnknownCard(context),
    );
  }

  /// Compatibility diagram card when blood type is known
  Widget _buildKnownCard(BuildContext context, String normalizedType) {
    final donateList = getCanDonateTo(normalizedType);
    final receiveList = getCanReceiveFrom(normalizedType);
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;

    final cardTitle = l10n?.bloodCompatibility ?? 'Blood Compatibility';
    final cardSubtitle = lang == 'am'
        ? 'ለደም ቡድንዎ የ ABO እና Rh ደም መስጠት/መቀበል ተኳሃኝነት፦'
        : lang == 'om'
            ? 'Walsimsiisa ABO fi Rh dabarsa dhiigaa kan gosa dhiiga keessanii:'
            : 'ABO and Rh transfusion compatibility for your blood group:';

    final badgeLabel = lang == 'am'
        ? 'የእርስዎ የደም ዓይነት'
        : lang == 'om'
            ? 'GOSA DHIIGA KEESSANII'
            : 'YOUR BLOOD TYPE';

    final donateTitle = l10n?.canDonateTo ?? 'You can donate to';
    final donateTag = l10n?.outgoingCompatibility ?? 'OUTGOING COMPATIBILITY';
    final donateDesc = lang == 'am'
        ? '${donateList.length} ተቀባይ የደም ቡድኖች የእርስዎን ቀይ የደም ሴሎች በደህና መውሰድ ይችላሉ።'
        : lang == 'om'
            ? 'Gosoonni dhiigaa fudhattootaa ${donateList.length} seelota dhiiga diimaa keessan nagaan fudhachuu danda\'u.'
            : '${donateList.length} recipient blood groups can safely receive your red blood cells.';

    final receiveTitle = l10n?.canReceiveFrom ?? 'You can receive from';
    final receiveTag = l10n?.incomingCompatibility ?? 'INCOMING COMPATIBILITY';
    final receiveDesc = lang == 'am'
        ? 'ደም መውሰድ ካስፈለገዎት ${receiveList.length} ለጋሽ የደም ቡድኖች ተኳሃኝ ናቸው።'
        : lang == 'om'
            ? 'Dabarsa dhiigaa yoo barbaaddan gosoonni dhiigaa arjoomtootaa ${receiveList.length} walsimoo dha.'
            : '${receiveList.length} donor blood groups are compatible if you need a transfusion.';

    final safeRulesNote = lang == 'am'
        ? 'ለጋሽ አስቸኳይ የሆስፒታል ጥያቄዎችን የሚያዛምደው ደህንነቱ በተጠበቀ የተኳሃኝነት ህጎች ብቻ ነው።'
        : lang == 'om'
            ? 'Legaash gaaffilee hospitaalaa ariifachiisaa seerota walsimsiisa nagaa qofa keessatti walitti fida.'
            : 'Legash matches urgent hospital requests strictly within safe compatibility rules.';

    final youLabel = lang == 'am' ? '(እርስዎ)' : lang == 'om' ? '(Isin)' : '(You)';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              const Icon(
                Icons.bloodtype_outlined,
                color: AppColors.crimson,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                cardTitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            cardSubtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Central Donor Badge with directional visual connection
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.crimson,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.crimson.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    badgeLabel,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    normalizedType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.cardBorder, height: 1, thickness: 0.8),
          const SizedBox(height: AppSpacing.md),

          // Section 1: You can donate to (Outward direction)
          _buildDirectionSection(
            title: donateTitle,
            directionTag: donateTag,
            directionIcon: Icons.arrow_upward_rounded,
            iconColor: const Color(0xFF1F6F5C),
            types: donateList,
            description: donateDesc,
            youLabel: youLabel,
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.cardBorder, height: 1, thickness: 0.8),
          const SizedBox(height: AppSpacing.md),

          // Section 2: You can receive from (Inward direction)
          _buildDirectionSection(
            title: receiveTitle,
            directionTag: receiveTag,
            directionIcon: Icons.arrow_downward_rounded,
            iconColor: AppColors.crimson,
            types: receiveList,
            description: receiveDesc,
            youLabel: youLabel,
          ),

          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.paperDim,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.inkSoft),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    safeRulesNote,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds one directional compatibility section (donate to OR receive from)
  Widget _buildDirectionSection({
    required String title,
    required String directionTag,
    required IconData directionIcon,
    required Color iconColor,
    required List<String> types,
    required String description,
    required String youLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(directionIcon, size: 15, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            const Spacer(),
            Text(
              directionTag,
              style: TextStyle(
                color: iconColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: types.map((type) {
            final isSelf = type == bloodType;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isSelf ? iconColor.withValues(alpha: 0.15) : AppColors.paperDim,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: isSelf ? iconColor : AppColors.cardBorder,
                  width: isSelf ? 1.2 : 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: isSelf ? iconColor : AppColors.textPrimary,
                      fontWeight: isSelf ? FontWeight.bold : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  if (isSelf) ...[
                    const SizedBox(width: 4),
                    Text(
                      youLabel,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Helpful message when blood type is unknown (does NOT guess or assume)
  Widget _buildUnknownCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;

    final cardTitle = l10n?.bloodCompatibility ?? 'Blood Compatibility';
    final cardDesc = lang == 'am'
        ? 'የደም ዓይነትዎን በአቅራቢያዎ በሚገኝ ሆስፒታል ወይም የደም ማዕከል ማወቅ እና በማንኛውም ጊዜ በመገለጫዎ ውስጥ ማዘመን ይችላሉ።'
        : lang == 'om'
            ? 'Gosa dhiiga keessanii hospitaala yookiin wiirtuu dhiigaa dhihoo jiru irraa baruu fi yeroo kamiyyuu piroofayilii keessatti haaromsuu dandeessu.'
            : 'You can find your blood type at your nearest hospital or donation center and update it in your profile anytime.';

    final cardHint = lang == 'am'
        ? 'የደም ዓይነትዎ ከተወሰነ በኋላ፣ ለጋሽ ግላዊ የደም ተኳሃኝነት ንድፍዎን ያሳያል እንዲሁም ከተኳሃኝ የአደጋ ጊዜ የሆስፒታል ጥያቄዎች ጋር ያዛምድዎታል።'
        : lang == 'om'
            ? 'Gosi dhiiga keessanii erga murtaa\'ee booda, Legaash fakkii walsimsiisa dhiiga dhuunfaa keessanii agarsiisa fi gaaffilee hospitaalaa walsimoo wajjin walitti isin fida.'
            : 'Once your blood type is set, Legash will display your personalized blood compatibility diagram and match you with compatible emergency hospital requests.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bloodtype_outlined,
                color: AppColors.crimson,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                cardTitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            cardDesc,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cardHint,
            style: const TextStyle(
              color: AppColors.sand,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NearbyCentersScreen()),
                  );
                },
                icon: const Icon(Icons.location_on_outlined, size: 14),
                label: Text(l10n?.nearbyCenters ?? 'Nearby Centers', style: const TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.crimson,
                  side: const BorderSide(color: AppColors.crimson, width: 0.8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: Text(l10n?.updateInProfile ?? 'Update Profile', style: const TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.inkSoft,
                  side: const BorderSide(color: AppColors.cardBorder, width: 0.8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
