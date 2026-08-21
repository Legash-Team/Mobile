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

  @override
  void didUpdateWidget(covariant NotificationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notification != widget.notification) {
      setState(() => _item = widget.notification);
    }
  }

  Future<void> _handleAccept() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        title: const Text(
          'Accept Blood Request?',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        content: Text(
          'By accepting, your contact details and ${_item.bloodType} blood type will be shared with ${_item.hospitalName}.',
          style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.crimson),
            child: const Text('Confirm & Accept'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _respond('accepted');
    }
  }

  Future<void> _respond(String response) async {
    setState(() => _isLoading = true);
    try {
      final res = response == 'accepted'
          ? await NotificationService.accept(_item.id)
          : await NotificationService.decline(_item.id);

      if (!mounted) return;

      if (res['success'] == true || res.containsKey('data')) {
        setState(() {
          _item = _item.copyWith(myResponseStatus: response);
        });
        widget.onChanged(_item);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response == 'accepted'
                  ? 'Request accepted. The hospital has been notified!'
                  : 'Request declined.',
            ),
            backgroundColor: response == 'accepted' ? AppColors.verified : AppColors.inkSoft,
          ),
        );
      } else {
        final error = res['error'] as String? ?? 'Failed to update request.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.crimson),
        );
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
                    'ACCEPTED',
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
              'Accepting shares your blood type and phone with the hospital staff.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: AppColors.crimson),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _respond('denied'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        side: const BorderSide(color: AppColors.cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: const Text(
                        'Decline',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: _handleAccept,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.crimson,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: const Text(
                        'Accept Request',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
          ] else if (_item.isAccepted) ...[
            Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.verified, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'You accepted this request — Hospital staff can now reach out.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.verified,
                      fontSize: 13,
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
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}