import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Helpers {
  // Format Timestamp ke string tanggal & waktu
  static String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    final date = timestamp.toDate();
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  // Format Timestamp ke string tanggal saja
  static String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    final date = timestamp.toDate();
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Format Timestamp ke string waktu saja
  static String formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    final date = timestamp.toDate();
    return DateFormat('HH:mm').format(date);
  }

  // Format angka ke Rupiah
  static String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Hitung durasi dari dua Timestamp
  static String calculateDuration(Timestamp? checkIn, Timestamp? checkOut) {
    if (checkIn == null || checkOut == null) return '-';
    final diff = checkOut.toDate().difference(checkIn.toDate());
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}j ${minutes}m';
    }
    return '${minutes}m';
  }
}
