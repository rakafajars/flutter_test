import 'package:get/get.dart';

import '../widgets/chat_bubble.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;

  final List<String> botResponses = [
    'Sure, could you please provide your order number?',
    'Thanks! I\'ll check the details for you.',
    'Your order is being processed and will be delivered soon.',
    'Is there anything else I can help you with?',
    'I\'m here to assist you 24/7!',
  ];

  int _responseIndex = 0;

  void sendMessage(String text, {String? imageUrl}) {
    if (text.isEmpty && imageUrl == null) return;

    messages.add(ChatMessage(text: text, imageUrl: imageUrl, isUser: true));

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

  void sendImage(String imageUrl) {
    sendMessage('', imageUrl: imageUrl);
  }
}
