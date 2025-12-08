import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../core/theme/app_colors.dart';
import '../widgets/chat_bubble.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final ImagePicker _imagePicker = ImagePicker();

  GenerativeModel? _model;
  ChatSession? _chatSession;

  @override
  void onInit() {
    super.onInit();
    _initGemini();
  }

  void _initGemini() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      debugPrint('GEMINI_API_KEY not found in .env');
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 1024,
      ),
    );

    _chatSession = _model?.startChat(
      history: [
        Content.text(
          'You are a helpful news assistant. Help users with questions about news, '
          'current events, and provide helpful information. Be friendly and concise.',
        ),
      ],
    );
  }

  Future<void> sendMessage(String text, {String? imagePath}) async {
    if (text.isEmpty && imagePath == null) return;

    messages.add(ChatMessage(text: text, imagePath: imagePath, isUser: true));

    await _getGeminiResponse(text, imagePath: imagePath);
  }

  Future<void> _getGeminiResponse(
    String userMessage, {
    String? imagePath,
  }) async {
    if (_chatSession == null) {
      _addBotMessage(
        'Sorry, AI is not configured. Please add GEMINI_API_KEY to .env file.',
      );
      return;
    }

    isTyping.value = true;

    try {
      GenerateContentResponse response;

      if (imagePath != null) {
        final imageBytes = await File(imagePath).readAsBytes();
        final imagePart = DataPart('image/jpeg', imageBytes);

        response = await _model!.generateContent([
          Content.multi([
            TextPart(
              userMessage.isEmpty ? 'What is in this image?' : userMessage,
            ),
            imagePart,
          ]),
        ]);
      } else {
        response = await _chatSession!.sendMessage(Content.text(userMessage));
      }

      final botReply =
          response.text ?? 'Sorry, I could not generate a response.';
      _addBotMessage(botReply);
    } catch (e) {
      debugPrint('Gemini Error: $e');
      _addBotMessage('Sorry, something went wrong. Please try again.');
    } finally {
      isTyping.value = false;
    }
  }

  void _addBotMessage(String text) {
    messages.add(ChatMessage(text: text, isUser: false));
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
