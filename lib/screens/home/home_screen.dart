import 'package:badges/badges.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/message_screen.dart';
import 'package:canteen_frontend/screens/notifications/notification_screen.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/onboarding_bloc.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_frontend/screens/posts/arguments.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_home_screen.dart';
import 'package:canteen_frontend/screens/posts/routes.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/user_profile_screen.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/home_drawer.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_screen.dart';
import 'package:canteen_frontend/screens/search/view_user_profile_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
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
  HomeBloc _homeBloc;
  int _previousIndex;
  int _currentIndex = 0;
  final _postScreen = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(CheckOnboardStatus());
  }

  void _onItemTapped(int index) {
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });

    if (_previousIndex != null && _previousIndex == _currentIndex) {
      switch (_currentIndex) {
        case 0:
          // TODO: clean up this animation so only one screen is shown
          _postScreen.currentState.popUntil((route) => route.isFirst);
          // _postScreen.currentState.pushAndRemoveUntil(
          //     PageRouteBuilder(
          //       pageBuilder: (c, a1, a2) => PostHomeScreen(),
          //       transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          //         position: Tween<Offset>(
          //           begin: const Offset(-1, 0),
          //           end: Offset.zero,
          //         ).animate(anim),
          //         child: child,
          //       ),
          //       transitionDuration: Duration(milliseconds: 200),
          //     ),
          //     (Route<dynamic> route) => false);
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
      }
    }
  }

  Widget _buildBadge(int count, Widget child) {
    return Badge(
      badgeColor: Palette.primaryColor,
      toAnimate: false,
      badgeContent: Text(
        count.toString(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
      showBadge: count != 0,
      child: child,
    );
  }

  Widget _buildHomeScreen(HomeState state) {
    if (state is HomeUninitialized ||
        state is HomeInitializing ||
        state is PageLoading ||
        state is CurrentIndexChanged) {
      return Center(child: CupertinoActivityIndicator());
    }

    if (state is PostScreenLoaded) {
      return Navigator(
        key: _postScreen,
        onGenerateRoute: (RouteSettings settings) {
          return buildPostScreenRoutes(settings);
        },
      );
    }

    if (state is SearchScreenLoaded) {
      return SearchScreen();
    }
    if (state is MessageScreenLoaded) {
      return MessageScreen();
    }
    if (state is NotificationScreenLoaded) {
      return NotificationScreen();
    }
    if (state is UserProfileScreenLoaded) {
      return UserProfileScreen(
        userRepository: widget._userRepository,
      );
    }

    if (state is OnboardScreenLoaded) {
      print('ONBOARDSCREEN LOADED');
      return BlocProvider<OnboardingBloc>(
        create: (context) =>
            OnboardingBloc(userRepository: widget._userRepository),
        child: OnboardingScreen(),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    print('HOME SCREEN BUILD');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      drawerEnableOpenDragGesture: false,
      drawer: HomeDrawer(
        onUserTap: () => _postScreen.currentState.pushNamed(
          ViewUserProfileScreen.routeName,
          arguments: UserPostArguments(
            user: widget._userRepository.currentUserNow(),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BlocListener<HomeBloc, HomeState>(
          listener: (BuildContext context, HomeState state) {
            print('HOME SCREEN BLOC LISTENER INITIALIZED');
            if (state is HomeInitializing) {
              print(
                  'IN HOME INITIALIZING - LOADING MATCHES/REQUESTS/RECOMMENDATIONS');
              BlocProvider.of<SearchBloc>(context).add(SearchHome());

              BlocProvider.of<MatchBloc>(context).add(LoadMatches());

              BlocProvider.of<RequestBloc>(context).add(LoadRequests());

              BlocProvider.of<RecommendedBloc>(context).add(LoadRecommended());

              BlocProvider.of<PostBloc>(context).add(LoadPosts());
            }

            if (state is PostScreenLoaded) {
              // if (state.reset) {
              //   BlocProvider.of<PostScreenBloc>(context).add(PostsHome());
              // }
            }

            if (state is SearchScreenLoaded) {
              if (state.reset) {
                BlocProvider.of<SearchBloc>(context).add(SearchHome());
              }
            }

            if (state is UserProfileScreenLoaded) {
              if (state.reset) {
                BlocProvider.of<UserProfileBloc>(context)
                    .add(ShowUserProfile());
              }
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            bloc: _homeBloc,
            builder: (BuildContext context, HomeState state) {
              if (state is HomeUninitialized || state is OnboardScreenLoaded) {
                return Visibility(visible: false, child: Container());
              }

              return BlocBuilder<HomeNavigationBarBloc, HomeNavigationBarState>(
                  builder: (BuildContext context,
                      HomeNavigationBarState navBarState) {
                return BottomNavigationBar(
                  currentIndex: _currentIndex,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedFontSize: kBottomNavigationBarFontSize,
                  unselectedFontSize: kBottomNavigationBarFontSize,
                  selectedItemColor: Palette.primaryColor,
                  backgroundColor: Palette.appBarBackgroundColor,
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(IconData(0xf38f,
                          fontFamily: CupertinoIcons.iconFont,
                          fontPackage: CupertinoIcons.iconFontPackage)),
                      title: Text(''),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(IconData(0xf2f5,
                          fontFamily: CupertinoIcons.iconFont,
                          fontPackage: CupertinoIcons.iconFontPackage)),
                      title: Text(''),
                    ),
                    // BottomNavigationBarItem(
                    //   icon: _buildBadge(
                    //     navBarState.numRequests,
                    //     Icon(
                    //       Icons.email,
                    //     ),
                    //   ),
                    //   title: Text(''),
                    // ),
                    BottomNavigationBarItem(
                      icon: const Icon(IconData(0xf2eb,
                          fontFamily: CupertinoIcons.iconFont,
                          fontPackage: CupertinoIcons.iconFontPackage)),
                      title: Text(''),
                    ),

                    BottomNavigationBarItem(
                      icon: const Icon(IconData(0xf39b,
                          fontFamily: CupertinoIcons.iconFont,
                          fontPackage: CupertinoIcons.iconFontPackage)),
                      title: Text(''),
                    ),
                  ],
                  onTap: _onItemTapped,
                );
              });
            },
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Navigator(
            key: _postScreen,
            onGenerateRoute: (RouteSettings settings) {
              return buildPostScreenRoutes(settings);
            },
          ),
          SearchScreen(),
          MessageScreen(),
          NotificationScreen(),
        ],
      ),
    );
  }
}
