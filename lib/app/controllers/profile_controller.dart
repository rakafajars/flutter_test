import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;

  String get displayName {
    final user = _authService.currentUser;
    if (user == null) return '';
    if (user.isAnonymous) return 'Guest';
    return user.displayName ?? user.email ?? 'User';
  }

  String? get userEmail => _authService.currentUser?.email;

  String? get userPhotoUrl => _authService.currentUser?.photoURL;

  bool get isGuest => _authService.currentUser?.isAnonymous ?? true;

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
      Get.offAllNamed(AppRoutes.login);
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
