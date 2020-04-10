import 'package:canteen_frontend/screens/chat/chat_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_item.dart';

class MatchList extends StatelessWidget {
  MatchList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchListBloc, MatchListState>(
      builder: (matchContext, matchState) {
        if (matchState is MatchListLoading || matchState is MatchListLoaded) {
          // TODO: show something when in MatchListLoaded state
          return Center(child: CircularProgressIndicator());
        } else if (matchState is DetailedMatchListLoaded) {
          final matches = matchState.matchList;

          return BlocBuilder<ChatBloc, ChatState>(
            builder: (chatContext, chatState) {
              print('CHAT STATE: $chatState');
              if (chatState is ChatListLoaded) {
                final chats = chatState.chatList;

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final match =
                        matches.firstWhere((m) => m.chatId == chat.id);
                    return MatchItem(
                        match: match,
                        chat: chat,
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) {
                              return MatchDetailScreen(
                                  match: match, chat: chat);
                            }),
                          );
                        });
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        }
      },
    );
  }
}
