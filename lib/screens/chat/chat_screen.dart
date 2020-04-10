import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/chat/bloc/bloc.dart';
import 'package:canteen_frontend/screens/chat/chat_input.dart';
import 'package:canteen_frontend/screens/chat/message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final Chat chat;

  const ChatScreen({@required this.chat, this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState(chat, user);
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final User user;
  final Chat chat;
  ChatBloc _chatBloc;
  bool isFirstLaunch = true;
  bool configMessagePeek = true;

  _ChatScreenState(this.chat, this.user);

  @override
  void initState() {
    print('INITIALIZE CHAT SCREEN');
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    // chatBloc.add(RegisterActiveChatEvent(user.chatId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
              child: Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: MessageList(chat),
              ),
            ],
          )),
          ChatInput(),
          // BlocBuilder<ConfigBloc, ConfigState>(builder: (context, state) {
          //   if (state is UnConfigState)
          //     configMessagePeek =
          //         SharedObjects.prefs.getBool(Constants.configMessagePeek);
          //   if (state is ConfigChangeState) if (state.key ==
          //       Constants.configMessagePeek) configMessagePeek = state.value;
          //   return GestureDetector(
          //     child: ChatInput(),
          //   );
          // })
        ],
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
