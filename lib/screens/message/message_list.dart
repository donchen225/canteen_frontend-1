import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/message/bloc/bloc.dart';
import 'package:canteen_frontend/screens/message/message_item.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageList extends StatefulWidget {
  final Match match;

  MessageList(this.match);

  @override
  _MessageListState createState() => _MessageListState(match);
}

class _MessageListState extends State<MessageList> {
  final ScrollController listScrollController = ScrollController();
  List<Message> messages = List();
  DetailedMatch match;

  _MessageListState(this.match);

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        BlocProvider.of<MessageBloc>(context)
            .add(FetchPreviousMessagesEvent(this.match, messages.last));
      }
    });
  }

  @override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = match.userId.firstWhere((id) =>
        id != CachedSharedPreferences.getString(PreferenceConstants.userId));
    return BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
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
