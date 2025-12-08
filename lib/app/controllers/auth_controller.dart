import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  User? get currentUser => _authService.currentUser;
  bool get isLoggedIn => currentUser != null;
  bool get isGuest => currentUser?.isAnonymous ?? false;

  String get displayName {
    if (currentUser == null) return '';
    if (currentUser!.isAnonymous) return 'Guest';
    return currentUser!.displayName ?? currentUser!.email ?? 'User';
  }

  String? get userEmail => currentUser?.email;
  String? get userPhotoUrl => currentUser?.photoURL;

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges.listen(_handleAuthStateChange);
  }

  void _handleAuthStateChange(User? user) {
    final currentRoute = Get.currentRoute;

    if (user != null) {
      if (currentRoute != AppRoutes.home) {
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      if (currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      await _authService.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Authentication failed';
      Get.snackbar(
        'Error',
        errorMessage.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Google Sign-In failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInAsGuest() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      await _authService.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Authentication failed';
      Get.snackbar(
        'Error',
        errorMessage.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Guest login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sign out failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
