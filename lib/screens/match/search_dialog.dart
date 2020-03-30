import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/search_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class SearchDialog extends StatefulWidget {
  final UserRepository _userRepository;
  final MatchRepository _matchRepository;

  SearchDialog(
      {Key key,
      @required UserRepository userRepository,
      @required MatchRepository matchRepository})
      : assert(userRepository != null),
        assert(matchRepository != null),
        _userRepository = userRepository,
        _matchRepository = matchRepository,
        super(key: key);

  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // TODO: move BlocProvider above this widget
  // Can't move BlocProvider out of this widget because showDialog creates a separate context
  @override
  Widget build(BuildContext context) {
    final user = (BlocProvider.of<UserBloc>(context).state as UserLoaded).user;

    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
          userRepository: widget._userRepository,
          userBloc: BlocProvider.of<UserBloc>(context)),
      child: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchCompleteWithResults) {
            final opponentUserId =
                state.userList.map((user) => user.id).toList();
            final uuid = Uuid();
            final matchId = uuid.v4();
            final quizId = uuid.v4();
            final messageId = uuid.v4();

            BlocProvider.of<MatchBloc>(context).add(
              AddMatch(
                Match(
                  id: matchId,
                  userId: ([user.id] + opponentUserId)
                      .asMap()
                      .map((k, v) => MapEntry(v, k)),
                  quizId: [quizId],
                  messageId: [messageId],
                ),
              ),
            );

            // TODO: add match
            // // TODO: add quizId to existing match
            // BlocProvider.of<QuizzesBloc>(context).add(
            //   AddQuiz(
            //     Quiz.create(
            //         id: quizId,
            //         matchId: matchId,
            //         senderId: user.id,
            //         receiverId: opponentUserId,
            //         category: "life"),
            //   ),
            // ); // TODO: update category once implemented
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return AlertDialog(
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Send Invite'),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        onChanged: (text) =>
                            BlocProvider.of<SearchBloc>(context).add(
                          SearchCleared(),
                        ),
                      ),
                    ),
                    state is SearchCompleteNoResults
                        ? Text(
                            state.message,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          )
                        : Container(),
                    state is SearchCompleteWithResults
                        ? Text(
                            'Invite sent',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                            ),
                          )
                        : Container(),
                    state is SearchLoading
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Submit"),
                              onPressed: () {
                                BlocProvider.of<SearchBloc>(context).add(
                                  SearchStarted(_usernameController.text),
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
