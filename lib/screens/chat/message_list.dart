import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:canteen_frontend/screens/chat/bloc/bloc.dart';
import 'package:canteen_frontend/screens/chat/message_item.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageList extends StatefulWidget {
  final Chat chat;

  MessageList(this.chat);

  @override
  _MessageListState createState() => _MessageListState(chat);
}

class _MessageListState extends State<MessageList> {
  final ScrollController listScrollController = ScrollController();
  List<Message> messages = List();
  final Chat chat;

  _MessageListState(this.chat);

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        BlocProvider.of<ChatBloc>(context)
            .add(FetchPreviousMessagesEvent(this.chat, messages.last));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = chat.userId.keys.firstWhere((id) =>
        id != CachedSharedPreferences.getString(PreferenceConstants.userId));
    // TODO: implement build
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      print(state);
      if (state is FetchedMessagesState) {
        print('Received Messages');
        if (state.userId == userId) {
          print(state.messages.length);
          print(state.isPrevious);
          if (state.isPrevious)
            messages.addAll(state.messages);
          else
            messages = state.messages;
        }
      }
      return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => MessageItem(messages[index]),
        itemCount: messages.length,
        reverse: true,
        controller: listScrollController,
      );
    });
  }
}
