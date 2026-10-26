import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../utils/wellness_content.dart';
import 'nearby_centers_screen.dart';
import 'profile_screen.dart';

class HealthScreen extends StatefulWidget {
  final bool isActive;
  const HealthScreen({super.key, this.isActive = true});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showAlert = false;
  Timer? _autoDismissTimer;

  static const _validBloodTypes = {'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    if (widget.isActive) {
      _triggerAlert();
    }
  }

  @override
  void didUpdateWidget(covariant HealthScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _triggerAlert();
    }
  }

  void _triggerAlert() {
    _autoDismissTimer?.cancel();
    setState(() {
      _showAlert = true;
    });
    _autoDismissTimer = Timer(const Duration(milliseconds: 4500), () {
      if (mounted) {
        setState(() {
          _showAlert = false;
        });
      }
    });
  }

  void _dismissAlert() {
    _autoDismissTimer?.cancel();
    setState(() {
      _showAlert = false;
    });
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  bool _isKnownBloodType(String? bloodType) {
    if (bloodType == null) return false;
    final normalized = bloodType.trim().toUpperCase();
    return _validBloodTypes.contains(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final donor = auth.donor;
    final rawBloodType = donor?.bloodType;
    final isKnown = _isKnownBloodType(rawBloodType);
    final normalizedType = isKnown ? rawBloodType!.trim().toUpperCase() : null;
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final wellness = getWellnessForBloodType(normalizedType, lang);

    final pageTitle = lang == 'am'
        ? 'ጤና እና ደህንነት'
        : lang == 'om'
            ? 'Fayyaa & Nageenya'
            : 'Health & Wellness';

    final foodsSubtitle = lang == 'am'
        ? 'የለጋሾችን ሄሞግሎቢን እና ህያውነት የሚደግፉ አልሚ ምግቦች፦'
        : lang == 'om'
            ? 'Nyaatawwan madaalawaa heemoogiloobiinii fi fayyaa arjoomaa deeggaran:'
            : 'Nutritious foods supporting donor hemoglobin and vitality:';

    final activitySubtitle = lang == 'am'
        ? 'ለእረፍት፣ ለአስተማማኝ እንቅስቃሴ እና ለማገገም በማስረጃ የተደገፈ መመሪያ፦'
        : lang == 'om'
            ? 'Qajeelfama qorannoon deeggarame kan boqonnaa, sochii nagaa fi bayyanannaaf ta\'u:'
            : 'Evidence-based guidance for rest, safe activity, and recovery:';

    final mindfulSubtitle = lang == 'am'
        ? 'ተገቢ ጥንቃቄዎች እና ከልገሳ በኋላ የሚወሰዱ የጤንነት እርምጃዎች፦'
        : lang == 'om'
            ? 'Of-eeggannoo barbaachisaa fi tarkaanfiiwwan fayyaa arjooma boodaa:'
            : 'Sensible precautions and post-donation wellness steps:';

    final habitsSubtitle = lang == 'am'
        ? 'ዓመቱን ሙሉ የለጋሽነት ጤናን ለመጠበቅ የሚረዱ ጤናማ ልማዶች፦'
        : lang == 'om'
            ? 'Amaloota gaarii waggaa guutuu fayyaa arjoomaa eeguuf gargaaran:'
            : 'Healthy habits to maintain vital donor wellness year-round:';

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, size: 20),
            tooltip: 'Caution Info',
            onPressed: _triggerAlert,
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A. Caution Alert (Appears on open, auto-disappears, comes when opened again)
                  _buildCautionAlert(l10n),

                  // B. Blood Type Header or Unknown Type Notice
                  if (isKnown)
                    _buildKnownBloodTypeHeader(normalizedType!, wellness.engagementNote, lang)
                  else
                    _buildUnknownBloodTypeNotice(context, l10n, lang),

                  const SizedBox(height: AppSpacing.sm),

                  // Section Tabs
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: AppColors.crimson,
                      indicatorWeight: 3,
                      labelColor: AppColors.crimson,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      tabAlignment: TabAlignment.start,
                      tabs: [
                        Tab(
                          icon: const Icon(Icons.restaurant_outlined, size: 18),
                          text: l10n?.foodsForDonorsTab ?? 'Foods for Donors',
                        ),
                        Tab(
                          icon: const Icon(Icons.directions_run_outlined, size: 18),
                          text: l10n?.activityRestTab ?? 'Activity & Rest',
                        ),
                        Tab(
                          icon: const Icon(Icons.health_and_safety_outlined, size: 18),
                          text: l10n?.mindfulCareTab ?? 'Mindful Care',
                        ),
                        Tab(
                          icon: const Icon(Icons.spa_outlined, size: 18),
                          text: l10n?.dailyHabitsTab ?? 'Daily Habits',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Foods Tab
            _buildTipList(wellness.foods, foodsSubtitle),

            // Activity Tab
            _buildTipList(wellness.activities, activitySubtitle),

            // Mindful Care Tab
            _buildTipList(wellness.mindfulNotes, mindfulSubtitle),

            // Daily Habits Tab
            _buildTipList(wellness.additionalTips, habitsSubtitle),
          ],
        ),
      ),
    );
  }

  /// Caution alert displayed when the page opens and auto-disappears
  Widget _buildCautionAlert(AppLocalizations? l10n) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _showAlert ? 1.0 : 0.0,
        child: _showAlert
            ? Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.xs,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7E6), // Warm caution amber tint
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: const Color(0xFFFFD591), width: 1.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1AD46B08),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFD46B08),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n?.cautionAlertTitle ?? 'CAUTION',
                            style: const TextStyle(
                              color: Color(0xFF873800),
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n?.cautionAlertBody ??
                                'Note: These are only wellness tips and are not a substitute for real medical tests.',
                            style: const TextStyle(
                              color: Color(0xFF595959),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: _dismissAlert,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Color(0xFF873800),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  /// Known blood type personalization header
  Widget _buildKnownBloodTypeHeader(String bloodType, String engagementNote, String lang) {
    final title = lang == 'am'
        ? 'የ $bloodType ለጋሾች የጤንነት ምክሮች'
        : lang == 'om'
            ? 'Gorsa fayyaa arjoomtoota $bloodType\'f'
            : 'Wellness tips for $bloodType donors';

    final disclaimer = lang == 'am'
        ? 'ማስታወሻ፦ ለተጠቃሚዎች ምቹ እንዲሆን በደም ዓይነት የተዘጋጀ። የአመጋገብ መመሪያዎች ለሁሉም የደም ለጋሾች ተግባራዊ ይሆናሉ።'
        : lang == 'om'
            ? 'Hubachiisa: Appilikeeshiniif akka toluuf gosa dhiigaan qindaa\'e. Gorsi nyaataa arjoomtoota dhiigaa hundaaf ni hojjeta.'
            : 'Note: Organized by blood type for app engagement. Nutritional recommendations apply to all whole blood donors.';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.crimson,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  bloodType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            engagementNote,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            disclaimer,
            style: const TextStyle(
              color: AppColors.sand,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Unknown blood type guidance banner
  Widget _buildUnknownBloodTypeNotice(BuildContext context, AppLocalizations? l10n, String lang) {
    final title = lang == 'am'
        ? 'አጠቃላይ የለጋሽ ጤና'
        : lang == 'om'
            ? 'Fayyaa Waliigalaa Arjoomaa'
            : 'General Donor Wellness';

    final body = lang == 'am'
        ? 'የደም ዓይነትዎን በአቅራቢያዎ በሚገኝ ሆስፒታል ወይም የደም ማዕከል ማወቅ እና በማንኛውም ጊዜ በመገለጫዎ ውስጥ ማዘመን ይችላሉ። የደም ዓይነትዎን ማወቅ ለጋሽ በአካባቢዎ ካሉ የአደጋ ጊዜ የልገሳ ጥሪዎች ጋር እንዲያዛምድዎት ያስችላል።'
        : lang == 'om'
            ? 'Gosa dhiiga keessanii hospitaala yookiin wiirtuu dhiigaa dhihoo jiru irraa baruu fi yeroo kamiyyuu piroofayilii keessatti haaromsuu dandeessu. Gosa dhiiga keessan beekuun Legaashiin beeksisa balaa tasaa naannoo keessanii wajjin akka walitti isin fidu dandeessisa.'
            : 'You can find your blood type at your nearest hospital or donation center and update it in your profile anytime. Setting your blood type allows Legash to match you with emergency donation alerts in your area.';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, color: AppColors.crimson, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
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
                label: Text(l10n?.findBloodCenter ?? 'Find Centers', style: const TextStyle(fontSize: 12)),
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
                label: Text(l10n?.updateInProfile ?? 'Set in Profile', style: const TextStyle(fontSize: 12)),
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

  /// List of wellness tips
  Widget _buildTipList(List<WellnessTip> tips, String header) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: tips.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              header,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        final tip = tips[index - 1];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.cardBorder, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tip.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tip.description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              if (tip.bulletPoints.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.paperDim,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Column(
                    children: tip.bulletPoints.map((bp) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: AppColors.crimson,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                bp,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12.5,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
