import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_list_screen.dart';
import 'package:canteen_frontend/screens/profile/user_profile_screen.dart';
import 'package:canteen_frontend/screens/recommended/recommended_screen.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_screen.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
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

  final _searchKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _selectedIndex = 0;
    _partyButtonColor = Colors.white;
    _friendsButtonColor = Colors.white;
    _strangersButtonColor = Colors.white;

    widgetOptions = [
      RecommendedScreen(),
      SearchScreen(key: _searchKey),
      RequestScreen(),
      MatchListScreen(),
      UserProfileScreen(
        userRepository: widget._userRepository,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex == index) {
        if (_selectedIndex == 1) {
          BlocProvider.of<SearchBloc>(context).add(SearchHome());
        } else if (_selectedIndex == 2) {
          BlocProvider.of<RequestListBloc>(context).add(LoadRequestList());
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
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xf38f,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage),
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xf2f5,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage),
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xf2eb,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage),
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xf3b2,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage),
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xf3a0,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage),
              ),
              title: Text(''),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange[500],
          onTap: _onItemTapped,
        ),
      ),
      body: widgetOptions.elementAt(_selectedIndex),
    );
  }
}
