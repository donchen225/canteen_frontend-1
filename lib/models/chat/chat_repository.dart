import 'dart:async';

import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/models/chat/chat_entity.dart';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:canteen_frontend/models/chat/message_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
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

      tx.update(chatCollection.document(chatId), {
        "last_updated": message.timestamp,
      });
    });
  }

  Future<Message> getMessage(String chatId, DateTime dateTime) {
    try {
      return chatCollection
          .document(chatId)
          .collection(messages)
          .where("timestamp", isEqualTo: Timestamp.fromDate(dateTime))
          .limit(1)
          .getDocuments()
          .then((doc) {
        return Message.fromEntity(
            MessageEntity.fromSnapshot(doc.documents.first));
      });
    } catch (e) {
      print("ERROR: NO MESSAGE FOUND - $e");
    }
  }

  // TODO: change this to document changes
  Stream<List<Chat>> getChats() {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    return chatCollection
        .where("user_id", arrayContains: userId)
        .orderBy("last_updated", descending: true)
        .snapshots()
        .map((snapshot) {
      print('GETTING SNAPSHOT');
      return snapshot.documents
          .map((doc) => Chat.fromEntity(ChatEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  Stream<List<Message>> getMessages(String chatId) {
    return chatCollection
        .document(chatId)
        .collection(messages)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .transform(
      StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<Message>> sink) {
          sink.add(
            snapshot.documents
                .map((doc) =>
                    Message.fromEntity(MessageEntity.fromSnapshot(doc)))
                .toList(),
          );
        },
      ),
    );
  }

  Future<List<Message>> getPreviousMessages(
      String chatId, Message message) async {
    DocumentSnapshot lastMessage = await chatCollection
        .document(chatId)
        .collection(messages)
        .document(message.id)
        .get();
    return (await chatCollection
            .document(chatId)
            .collection(messages)
            .startAfterDocument(lastMessage)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .getDocuments())
        .documents
        .map((doc) => Message.fromEntity(MessageEntity.fromSnapshot(doc)))
        .toList();
  }
}
