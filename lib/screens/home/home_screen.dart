import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_list_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_screen.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final User user;

  HomeScreen({Key key, this.user, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex;

  Color _partyButtonColor;
  Color _friendsButtonColor;
  Color _strangersButtonColor;

  List<Widget> widgetOptions;

  @override
  void initState() {
    super.initState();

    _selectedIndex = 0;
    _partyButtonColor = Colors.white;
    _friendsButtonColor = Colors.white;
    _strangersButtonColor = Colors.white;

    widgetOptions = [
      MatchListScreen(
        matchRepository: MatchRepository(),
        userRepository: widget._userRepository,
      ),
      ProfileScreen(
        user: widget.user,
        userRepository: widget._userRepository,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Games'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: widgetOptions.elementAt(_selectedIndex),
    );
  }
}
