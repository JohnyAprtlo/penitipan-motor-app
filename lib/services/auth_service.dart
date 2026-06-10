import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream untuk memantau status login
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // User saat ini
  User? get currentUser => _auth.currentUser;

  // Login dengan Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User membatalkan login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Simpan/update data user ke Firestore dengan UID sebagai doc ID
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // User baru → buat dokumen
          await userDoc.set({
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'role': 'petugas',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // User lama → update timestamp
          await userDoc.update({'updatedAt': FieldValue.serverTimestamp()});
        }
      }

      return user;
    } catch (e) {
      // Error signing in with Google: $e
      return null;
    }
  }

  // Login Anonymous (Testing/Guest)
  Future<User?> signInAnonymously() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      final User? user = userCredential.user;

      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'name': 'Guest Tester',
            'email': 'guest@local.test',
            'role': 'petugas',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return user;
    } catch (e) {
      // Error anonymous sign-in: $e
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
