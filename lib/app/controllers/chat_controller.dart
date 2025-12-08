import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../core/theme/app_colors.dart';
import '../widgets/chat_bubble.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> botResponses = [
    'Sure, could you please provide your order number?',
    'Thanks! I\'ll check the details for you.',
    'Your order is being processed and will be delivered soon.',
    'Is there anything else I can help you with?',
    'I\'m here to assist you 24/7!',
  ];

  int _responseIndex = 0;

  void sendMessage(String text, {String? imagePath}) {
    if (text.isEmpty && imagePath == null) return;

    messages.add(ChatMessage(text: text, imagePath: imagePath, isUser: true));

    _simulateBotReply();
  }

  void _simulateBotReply() {
    isTyping.value = true;

    Future.delayed(const Duration(milliseconds: 1500), () {
      isTyping.value = false;
      messages.add(
        ChatMessage(
          text: botResponses[_responseIndex % botResponses.length],
          isUser: false,
        ),
      );
      _responseIndex++;
    });
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      sendMessage('', imagePath: image.path);
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (image != null) {
      sendMessage('', imagePath: image.path);
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primary,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }
}
