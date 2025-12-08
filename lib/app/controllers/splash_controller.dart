import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_authService.currentUser != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
