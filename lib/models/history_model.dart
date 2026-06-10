import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String? id;
  final String motorId;
  final String plateNumber;
  final String vehicleType;
  final Timestamp? checkInAt;
  final Timestamp checkOutAt; // wajib diisi di history
  final String duration;
  final String notes;
  final Timestamp? createdAt;

  HistoryModel({
    this.id,
    required this.motorId,
    required this.plateNumber,
    required this.vehicleType,
    this.checkInAt,
    required this.checkOutAt,
    required this.duration,
    this.notes = '',
    this.createdAt,
  });

  factory HistoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HistoryModel(
      id: doc.id,
      motorId: data['motorId'] ?? '',
      plateNumber: data['plateNumber'] ?? '',
      vehicleType: data['vehicleType'] ?? '',
      checkInAt: data['checkInAt'] as Timestamp?,
      checkOutAt: data['checkOutAt'] as Timestamp,
      duration: data['duration'] ?? '',
      notes: data['notes'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'motorId': motorId,
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
      'checkInAt': checkInAt,
      'checkOutAt': checkOutAt,
      'duration': duration,
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
