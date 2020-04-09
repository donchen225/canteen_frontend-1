import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  static const String messages = "messages";
  final chatCollection = Firestore.instance.collection('chat');

  ChatRepository();

  Future<void> addChat(Chat chat) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.set(
        chatCollection.document(chat.id),
        chat.toEntity().toDocument(),
      );
    });
  }

  Future<void> addMessage(Chat chat, Message message) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.set(
        chatCollection.document(chat.id).collection(messages).document(),
        message.toEntity().toDocument(),
      );
    });
  }
}
