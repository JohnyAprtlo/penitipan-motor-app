import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftReportModel {
  final String? id;
  final Timestamp? shiftDate;
  final String shiftName;
  final int totalIncome;
  final String notes;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  ShiftReportModel({
    this.id,
    this.shiftDate,
    required this.shiftName,
    required this.totalIncome,
    this.notes = '',
    this.createdAt,
    this.updatedAt,
  });

  factory ShiftReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShiftReportModel(
      id: doc.id,
      shiftDate: data['shiftDate'] as Timestamp?,
      shiftName: data['shiftName'] ?? '',
      totalIncome: (data['totalIncome'] ?? 0).toInt(),
      notes: data['notes'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'shiftDate': FieldValue.serverTimestamp(),
      'shiftName': shiftName,
      'totalIncome': totalIncome,
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
