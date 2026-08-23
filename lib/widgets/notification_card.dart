import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  final ValueChanged<NotificationModel> onChanged;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onChanged,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late NotificationModel _item;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _item = widget.notification;
  }

  @override
  void didUpdateWidget(covariant NotificationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notification != widget.notification) {
      _item = widget.notification;
    }
  }

  Future<void> _launchCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchMaps(double lat, double lng, String name) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _respond(String response) async {
    setState(() => _isLoading = true);
    try {
      final res = response == 'accepted'
          ? await NotificationService.accept(_item.id)
          : await NotificationService.decline(_item.id);

      if (!mounted) return;

      if (res['success'] == true) {
        final nextSteps = res['nextSteps'] as Map<String, dynamic>?;
        final hospPhone = nextSteps?['hospitalPhone'] as String? ?? _item.hospitalPhone;
        final hospLoc = nextSteps?['hospitalLocation'] as Map<String, dynamic>?;

        double? hospLat = _item.hospitalLat;
        double? hospLng = _item.hospitalLng;
        if (hospLoc != null) {
          final lat = hospLoc['lat'] as num?;
          final lng = hospLoc['lng'] as num?;
          if (lat != null && lng != null) {
            hospLat = lat.toDouble();
            hospLng = lng.toDouble();
          }
        }

        setState(() {
          _item = _item.copyWith(
            myResponseStatus: response,
            hospitalPhone: hospPhone,
            hospitalLat: hospLat,
            hospitalLng: hospLng,
          );
        });
        widget.onChanged(_item);
        if (response == 'accepted') {
          _showAcceptSuggestions(res);
        }
      } else {
        final error = res['error'] as String? ?? 'Something went wrong.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: AppColors.crimson),
          );
        }
        setState(() {
          _item = _item.copyWith(requestStatus: 'closed');
        });
        widget.onChanged(_item);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.crimson),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAcceptSuggestions(Map<String, dynamic> res) {
    final nextSteps = res['nextSteps'] as Map<String, dynamic>?;
    final hospitalName = nextSteps?['hospitalName'] as String? ?? _item.hospitalName;
    final hospitalPhone = nextSteps?['hospitalPhone'] as String? ?? _item.hospitalPhone;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.verified, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Request Accepted!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.verified,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Thank you for stepping up to save lives. Here are your next steps:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.md),
            if (hospitalPhone != null && hospitalPhone.isNotEmpty) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.crimson.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.call, color: AppColors.crimson, size: 20),
                ),
                title: const Text('Call Hospital', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(hospitalPhone, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                onTap: () {
                  Navigator.pop(ctx);
                  _launchCall(hospitalPhone);
                },
              ),
              const Divider(height: 1),
            ],
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.crimson.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: AppColors.crimson, size: 20),
              ),
              title: const Text('Hospital Facility', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: Text(hospitalName, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              onTap: () => Navigator.pop(ctx),
            ),
            const Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.paperDim,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.schedule, color: AppColors.textSecondary, size: 20),
              ),
              title: const Text('Visit When Ready', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('The hospital will prepare for your donation', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              onTap: () => Navigator.pop(ctx),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgent = _item.isPending && _item.isOpen;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: urgent ? AppColors.crimson : AppColors.cardBorder,
          width: urgent ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _item.isAccepted
                      ? AppColors.pillGreen
                      : _item.isDenied
                          ? AppColors.paperDim
                          : AppColors.crimson.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _item.bloodType,
                    style: TextStyle(
                      color: _item.isAccepted
                          ? AppColors.verified
                          : _item.isDenied
                              ? AppColors.textSecondary
                              : AppColors.crimson,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _item.hospitalName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Needed: ${_item.quantityNeeded} unit${_item.quantityNeeded > 1 ? 's' : ''} • ${_item.bloodType} blood',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (urgent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.crimson,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    'URGENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
              else if (_item.isAccepted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pillGreen,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    'ACCEPTED',
                    style: TextStyle(
                      color: AppColors.verified,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
              else if (_item.isDenied)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.paperDim,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    'DENIED',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),

          if (_item.description != null && _item.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _item.description!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          // Action section depending on status
          if (_item.isPending && _item.isOpen) ...[
            const Text(
              'Accepting reveals your phone number to the hospital to coordinate donation.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _isLoading ? null : () => _respond('accepted'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.crimson,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Accept Request',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => _respond('denied'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: const Text(
                      'Decline',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (_item.isPending && _item.isClosed) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.paperDim,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Text(
                'This blood request has closed or expired.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ] else if (_item.isAccepted) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.pillGreen.withOpacity(0.4),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.verified, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'You accepted — the hospital can see your contact info.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.verified,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_item.hospitalPhone != null && _item.hospitalPhone!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => _launchCall(_item.hospitalPhone!),
                          icon: const Icon(Icons.call, size: 16, color: AppColors.crimson),
                          label: Text(
                            'Call (${_item.hospitalPhone})',
                            style: const TextStyle(
                              color: AppColors.crimson,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        if (_item.hospitalLat != null && _item.hospitalLng != null) ...[
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => _launchMaps(
                              _item.hospitalLat!,
                              _item.hospitalLng!,
                              _item.hospitalName,
                            ),
                            icon: const Icon(Icons.directions, size: 16, color: AppColors.textPrimary),
                            label: const Text(
                              'Directions',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ] else if (_item.isDenied) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.paperDim,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Text(
                'You declined this request. You will not receive further alerts for it.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}