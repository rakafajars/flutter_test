import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/custom_login_button.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9C27B0), Color(0xFFE1BEE7), Colors.white],
            stops: [0.0, 0.4, 0.7],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withAlpha(100),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to your account',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 48),
                Obx(
                  () => Column(
                    children: [
                      CustomLoginButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.signInWithGoogle,
                        icon: Image.network(
                          'https://www.google.com/favicon.ico',
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.g_mobiledata,
                                size: 24,
                                color: Colors.red,
                              ),
                        ),
                        text: 'Sign in with Google',
                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                        borderColor: const Color(0xFFE0E0E0),
                      ),
                      const SizedBox(height: 24),
                      if (controller.isLoading.value)
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF9C27B0),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                Obx(
                  () => TextButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.signInAsGuest,
                    child: const Text(
                      'Continue as guest',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
