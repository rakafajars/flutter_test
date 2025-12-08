import '../database_helper.dart';
import '../../../widgets/chat_bubble.dart';

class ChatMessageDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertMessage(ChatMessage message) async {
    final db = await _dbHelper.database;
    return await db.insert('chat_messages', {
      'text': message.text,
      'imagePath': message.imagePath,
      'isUser': message.isUser ? 1 : 0,
      'time': message.time.toIso8601String(),
    });
  }

  Future<void> insertMessages(List<ChatMessage> messages) async {
    final db = await _dbHelper.database;
    final batch = db.batch();

    for (final message in messages) {
      batch.insert('chat_messages', {
        'text': message.text,
        'imagePath': message.imagePath,
        'isUser': message.isUser ? 1 : 0,
        'time': message.time.toIso8601String(),
      });
    }

    await batch.commit(noResult: true);
  }

  Future<List<ChatMessage>> getAllMessages() async {
    final db = await _dbHelper.database;
    final maps = await db.query('chat_messages', orderBy: 'time ASC');
    return maps.map((map) => _messageFromMap(map)).toList();
  }

  Future<int> deleteAllMessages() async {
    final db = await _dbHelper.database;
    return await db.delete('chat_messages');
  }

  ChatMessage _messageFromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] ?? '',
      imagePath: map['imagePath'],
      isUser: map['isUser'] == 1,
      time: DateTime.tryParse(map['time'] ?? ''),
    );
  }
}
