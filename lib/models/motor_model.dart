import 'package:cloud_firestore/cloud_firestore.dart';

class MotorModel {
  final String? id;
  final String plateNumber;
  final String vehicleType;
  final Timestamp? checkInAt;
  final Timestamp? checkOutAt; // nullable sampai motor keluar
  final String status; // 'in' atau 'out'
  final String notes;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  MotorModel({
    this.id,
    required this.plateNumber,
    required this.vehicleType,
    this.checkInAt,
    this.checkOutAt,
    this.status = 'in',
    this.notes = '',
    this.createdAt,
    this.updatedAt,
  });

  factory MotorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MotorModel(
      id: doc.id,
      plateNumber: data['plateNumber'] ?? '',
      vehicleType: data['vehicleType'] ?? '',
      checkInAt: data['checkInAt'] as Timestamp?,
      checkOutAt: data['checkOutAt'] as Timestamp?,
      status: data['status'] ?? 'in',
      notes: data['notes'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestoreCreate() {
    return {
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
      'checkInAt': FieldValue.serverTimestamp(),
      'checkOutAt': null, // null saat motor baru masuk
      'status': 'in',
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Hanya dipanggil saat motor keluar
  static Map<String, dynamic> checkOutUpdate() {
    return {
      'checkOutAt': FieldValue.serverTimestamp(),
      'status': 'out',
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
