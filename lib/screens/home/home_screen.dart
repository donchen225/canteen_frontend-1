import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_list_screen.dart';
import 'package:canteen_frontend/screens/potential_match/potential_match_screen.dart';
import 'package:canteen_frontend/screens/profile/user_profile_screen.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository _userRepository;

  HomeScreen({Key key, @required UserRepository userRepository})
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
      SearchScreen(
        userRepository: widget._userRepository,
      ),
      PotentialMatchScreen(),
      MatchListScreen(
        matchRepository: MatchRepository(),
        userRepository: widget._userRepository,
      ),
      UserProfileScreen(
        userRepository: widget._userRepository,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex == index) {
        if (_selectedIndex == 0) {
          BlocProvider.of<SearchBloc>(context).add(SearchCleared());
        }
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.offline_bolt),
            title: Text('Likes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Matches'),
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
