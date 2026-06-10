import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/shift_report_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ShiftReportScreen extends StatefulWidget {
  const ShiftReportScreen({super.key});

  @override
  State<ShiftReportScreen> createState() => _ShiftReportScreenState();
}

class _ShiftReportScreenState extends State<ShiftReportScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  void _showAddReportDialog() {
    final incomeController = TextEditingController();
    final notesController = TextEditingController();
    String selectedShift = 'Pagi';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Tambah Laporan Shift',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Shift',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedShift,
                      isExpanded: true,
                      items: ['Pagi', 'Siang', 'Malam'].map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedShift = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Total Pendapatan (Rp)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: incomeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Contoh: 150000',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Catatan (opsional)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Catatan shift...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final income = int.tryParse(incomeController.text.trim()) ?? 0;
                if (income <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Masukkan total pendapatan yang valid'),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                  return;
                }

                final report = ShiftReportModel(
                  shiftName: selectedShift,
                  totalIncome: income,
                  notes: notesController.text.trim(),
                );

                await _firestoreService.addShiftReport(report);
                if (context.mounted) Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Laporan Shift',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getShiftReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assessment, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada laporan shift',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final reports = snapshot.data!.docs
              .map((doc) => ShiftReportModel.fromFirestore(doc))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final r = reports[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Shift icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _shiftColor(r.shiftName).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _shiftIcon(r.shiftName),
                          color: _shiftColor(r.shiftName),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shift ${r.shiftName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Helpers.formatTimestamp(r.shiftDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (r.notes.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                r.notes,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Income
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          Helpers.formatCurrency(r.totalIncome),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReportDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.textPrimary, width: 2),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _shiftColor(String shiftName) {
    switch (shiftName.toLowerCase()) {
      case 'pagi':
        return AppColors.warning;
      case 'siang':
        return AppColors.primary;
      case 'malam':
        return const Color(0xFF6366F1);
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _shiftIcon(String shiftName) {
    switch (shiftName.toLowerCase()) {
      case 'pagi':
        return Icons.wb_sunny;
      case 'siang':
        return Icons.wb_cloudy;
      case 'malam':
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
    }
  }
}

