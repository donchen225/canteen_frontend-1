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

  Future<void> sendMessage(String chatId, Message message) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.set(
        chatCollection.document(chatId).collection(messages).document(),
        message.toEntity().toDocument(),
      );
    });
  }

  // TODO: listen to document changes and process the changes
  Stream<List<Chat>> getChats() {}
}
