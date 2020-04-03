import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_list.dart';
import 'package:flutter/material.dart';

class MatchListScreen extends StatelessWidget {
  final MatchRepository _matchRepository;
  final UserRepository _userRepository;

  MatchListScreen(
      {Key key,
      @required MatchRepository matchRepository,
      @required UserRepository userRepository})
      : assert(matchRepository != null),
        assert(userRepository != null),
        _matchRepository = matchRepository,
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Matches',
        ),
        automaticallyImplyLeading: false,
        elevation: 2,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.add,
          //     color: Colors.black,
          //   ),
          //   onPressed: () => showDialog(
          //       context: context,
          //       child: SearchDialog(
          //         userRepository: _userRepository,
          //         matchRepository: _matchRepository,
          //       )),
          // )
        ],
      ),
      body: MatchList(),
    );
  }
}
