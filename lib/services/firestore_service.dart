import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/motor_model.dart';
import '../models/shift_report_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== MOTOR ====================

  // Tambah motor masuk
  Future<DocumentReference> addMotor(MotorModel motor) {
    return _db.collection('motor').add(motor.toFirestoreCreate());
  }

  // Stream motor yang sedang parkir (status = 'in')
  Stream<QuerySnapshot> getActiveMotors() {
    return _db
        .collection('motor')
        .where('status', isEqualTo: 'in')
        .orderBy('checkInAt', descending: true)
        .snapshots();
  }

  // Stream semua motor
  Stream<QuerySnapshot> getAllMotors() {
    return _db
        .collection('motor')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Motor keluar → update status & checkOutAt, lalu buat history
  Future<void> checkOutMotor(MotorModel motor) async {
    final motorRef = _db.collection('motor').doc(motor.id);

    // Update motor: status = 'out', checkOutAt = server timestamp
    await motorRef.update(MotorModel.checkOutUpdate());

    // Ambil data terbaru setelah update untuk mendapatkan checkOutAt
    final updatedDoc = await motorRef.get();
    final updatedData = updatedDoc.data() as Map<String, dynamic>;

    final checkInAt = updatedData['checkInAt'] as Timestamp?;
    final checkOutAt = updatedData['checkOutAt'] as Timestamp?;

    // Hitung durasi
    String duration = '-';
    if (checkInAt != null && checkOutAt != null) {
      final diff = checkOutAt.toDate().difference(checkInAt.toDate());
      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);
      duration = '${hours}j ${minutes}m';
    }

    // Buat history
    await _db.collection('history').add({
      'motorId': motor.id,
      'plateNumber': motor.plateNumber,
      'vehicleType': motor.vehicleType,
      'checkInAt': checkInAt,
      'checkOutAt': checkOutAt,
      'duration': duration,
      'notes': motor.notes,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== HISTORY ====================

  // Stream history (semua transaksi selesai)
  Stream<QuerySnapshot> getHistory() {
    return _db
        .collection('history')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ==================== SHIFT REPORTS ====================

  // Tambah shift report
  Future<DocumentReference> addShiftReport(ShiftReportModel report) {
    return _db.collection('shiftReports').add(report.toFirestore());
  }

  // Stream shift reports
  Stream<QuerySnapshot> getShiftReports() {
    return _db
        .collection('shiftReports')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Hitung total motor aktif
  Future<int> getActiveMotorCount() async {
    final snapshot = await _db
        .collection('motor')
        .where('status', isEqualTo: 'in')
        .get();
    return snapshot.docs.length;
  }

  // Hitung total motor keluar hari ini
  Future<int> getTodayCheckoutCount() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final snapshot = await _db
        .collection('history')
        .where(
          'checkOutAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .get();
    return snapshot.docs.length;
  }
}
