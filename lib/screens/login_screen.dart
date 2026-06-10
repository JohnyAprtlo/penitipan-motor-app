import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithGoogle();
    setState(() => _isLoading = false);

    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login dibatalkan atau gagal'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _handleAnonymousSignIn() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInAnonymously();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Guest gagal, cek setingan Firebase Auth'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
          color: AppColors.primary,
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.textPrimary,
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.textPrimary,
                        blurRadius: 0,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.two_wheeler,
                    size: 64,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Penitipan Motor',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sistem Pencatatan Parkir',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 64),

                // Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.textPrimary, width: 2),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.primary,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                  height: 24,
                                  width: 24,
                                      errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.g_mobiledata, size: 28),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Masuk dengan Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Guest / Testing Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _handleAnonymousSignIn,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        backgroundColor: AppColors.primaryLight,
                        side: const BorderSide(color: AppColors.textPrimary, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
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
                          : const Text(
                              'Masuk sebagai Tamu (Testing)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Footer
                Text(
                  'v1.0.0 — Tugas Kuliah',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

