import 'package:flutter/material.dart';
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

  Future<void> _respond(String response) async {
    setState(() => _isLoading = true);
    try {
      final res = response == 'accepted'
          ? await NotificationService.accept(_item.id)
          : await NotificationService.decline(_item.id);

      if (!mounted) return;

      if (res['success'] == true) {
        setState(() {
          _item = _item.copyWith(myResponseStatus: response);
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
    final hospitalPhone = nextSteps?['hospitalPhone'] as String?;

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
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Request Accepted!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.verified,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Here are some things you can do:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: const Icon(Icons.call, color: AppColors.crimson),
              title: const Text('Contact Hospital', style: TextStyle(fontSize: 14)),
              subtitle: hospitalPhone != null
                  ? Text(hospitalPhone, style: TextStyle(fontSize: 13, color: AppColors.textSecondary))
                  : null,
              onTap: () => Navigator.pop(ctx),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.location_on, color: AppColors.crimson),
              title: const Text('Go to Hospital Location', style: TextStyle(fontSize: 14)),
              subtitle: Text(hospitalName, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              onTap: () => Navigator.pop(ctx),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.schedule, color: AppColors.crimson),
              title: const Text('Visit When Ready', style: TextStyle(fontSize: 14)),
              subtitle: const Text('The hospital can also reach out to you', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              onTap: () => Navigator.pop(ctx),
            ),
            const SizedBox(height: AppSpacing.md),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: urgent ? AppColors.crimson : AppColors.cardBorder,
          width: urgent ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.paperDim,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: AppColors.crimson,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency: ${_item.bloodType} needed',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_item.hospitalName} • ${_item.quantityNeeded} units',
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
                      fontSize: 11,
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
                    'MATCHED',
                    style: TextStyle(
                      color: AppColors.verified,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (_item.isPending && _item.isOpen) ...[
            const Text(
              'Accepting reveals your details to the hospital.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : () => _respond('accepted'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.crimson,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Accept Request',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: TextButton(
                onPressed: _isLoading ? null : () => _respond('declined'),
                child: const Text(
                  'Decline',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ] else if (_item.isPending && _item.isClosed) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.paperDim,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Text(
                'Request Closed / Expired',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ] else if (_item.isAccepted) ...[
            Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.verified, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'You accepted this request — The hospital can now see your contact info.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.verified,
                      fontSize: 14,
                      height: 20 / 14,
                    ),
                  ),
                ),
              ],
            ),
          ] else if (_item.isDenied) ...[
            Text(
              'You declined this request.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}