import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/motor_model.dart';
import '../utils/constants.dart';

class MotorInScreen extends StatefulWidget {
  const MotorInScreen({super.key});

  @override
  State<MotorInScreen> createState() => _MotorInScreenState();
}

class _MotorInScreenState extends State<MotorInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _notesController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedType = VehicleTypes.types.first;
  bool _isLoading = false;

  @override
  void dispose() {
    _plateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitMotor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final motor = MotorModel(
        plateNumber: _plateController.text.trim().toUpperCase(),
        vehicleType: _selectedType,
        notes: _notesController.text.trim(),
      );

      await _firestoreService.addMotor(motor);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Motor berhasil dicatat masuk!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mencatat: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Catat Motor Masuk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.two_wheeler,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Plate Number
              const Text(
                'Nomor Plat',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _plateController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Contoh: B 1234 XYZ',
                  prefixIcon: const Icon(Icons.confirmation_number),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.textPrimary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.textPrimary, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryDark,
                      width: 3,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor plat wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Vehicle Type
              const Text(
                'Jenis Kendaraan',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.textPrimary, width: 2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: VehicleTypes.types.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Notes
              const Text(
                'Catatan (opsional)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Catatan tambahan...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.notes),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.textPrimary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.textPrimary, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryDark,
                      width: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitMotor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: AppColors.textPrimary, width: 2),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text(
                              'Simpan Motor Masuk',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

