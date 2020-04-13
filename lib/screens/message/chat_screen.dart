import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/message/bloc/bloc.dart';
import 'package:canteen_frontend/screens/message/chat_input.dart';
import 'package:canteen_frontend/screens/message/message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final DetailedMatch match;

  const ChatScreen({@required this.match, this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState(match, user);
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final User user;
  final Match match;
  MessageBloc _messageBloc;
  bool isFirstLaunch = true;
  bool configMessagePeek = true;

  _ChatScreenState(this.match, this.user);

  @override
  void initState() {
    super.initState();
    print('INITIALIZE CHAT SCREEN');
    _messageBloc = BlocProvider.of<MessageBloc>(context);
    _messageBloc.add(RegisterActiveChatEvent(match.id));
    _messageBloc.add(FetchConversationDetailsEvent(match));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTapDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: <Widget>[
            Expanded(
                child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: MessageList(match),
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
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
