import 'package:flutter/material.dart';
import '../models/motor_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class MotorListTile extends StatelessWidget {
  final MotorModel motor;
  final VoidCallback? onCheckOut;

  const MotorListTile({super.key, required this.motor, this.onCheckOut});

  @override
  Widget build(BuildContext context) {
    final isActive = motor.status == 'in';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textPrimary, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.textPrimary,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon kendaraan
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.two_wheeler,
                color: isActive ? AppColors.primary : AppColors.success,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        motor.plateNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isActive ? 'PARKIR' : 'KELUAR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${motor.vehicleType}  •  Masuk: ${Helpers.formatTime(motor.checkInAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (motor.notes.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      motor.notes,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Checkout button
            if (isActive && onCheckOut != null)
              SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: onCheckOut,
                  icon: const Icon(Icons.logout, size: 16),
                  label: const Text('Keluar', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: AppColors.textPrimary, width: 2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

