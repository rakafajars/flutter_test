import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade600,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_open_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
                const Spacer(flex: 2),
                Obx(
                  () => Column(
                    children: [
                      _buildLoginButton(
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
                      ),
                      const SizedBox(height: 16),
                      _buildLoginButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.signInAsGuest,
                        icon: const Icon(
                          Icons.person_outline,
                          size: 24,
                          color: Colors.white,
                        ),
                        text: 'Continue as Guest',
                        backgroundColor: Colors.white.withAlpha(51),
                        textColor: Colors.white,
                        borderColor: Colors.white.withAlpha(128),
                      ),
                      const SizedBox(height: 32),
                      if (controller.isLoading.value)
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
