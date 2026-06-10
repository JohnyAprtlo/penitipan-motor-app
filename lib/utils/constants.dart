import 'package:flutter/material.dart';

class AppColors {
  // Saweria Color Palette
  static const Color primary = Color(0xFFFFCC00); // Saweria Yellow
  static const Color primaryDark = Color(0xFFE6B800); // Darker Yellow
  static const Color primaryLight = Color(0xFFFFD633); // Lighter Yellow
  static const Color accent = Color(0xFF2E2E2E); // Dark accent
  static const Color background = Color(0xFFF8F9FA); // Off-white/gray
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color textPrimary = Color(0xFF1F1F1F); // Almost black
  static const Color textSecondary = Color(0xFF6B7280); // Gray
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFEF4444); // Red
  static const Color cardShadow = Color(0x1A000000); // Shadow
}

class AppStrings {
  static const String appName = 'Penitipan Motor';
  static const String login = 'Masuk dengan Google';
  static const String dashboard = 'Dashboard';
  static const String motorIn = 'Motor Masuk';
  static const String motorOut = 'Motor Keluar';
  static const String history = 'Riwayat';
  static const String shiftReport = 'Laporan Shift';
  static const String scanPlat = 'Scan Plat (Coming Soon)';
}

class VehicleTypes {
  static const List<String> types = [
    'Matic',
    'Bebek',
    'Sport',
    'Kopling',
    'Lainnya',
  ];
}
