import 'package:badges/badges.dart';
import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/recommendation/recommendation_repository.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/models/user_settings/settings_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_list_bloc/match_list_bloc.dart';
import 'package:canteen_frontend/screens/match/routes.dart';
import 'package:canteen_frontend/screens/notifications/routes.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_frontend/screens/onboarding/routes.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/routes.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/home_drawer.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/request_list_bloc.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/routes.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:canteen_frontend/shared_blocs/group/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final RequestRepository _requestRepository;
  final SettingsRepository _settingsRepository;
  final PostRepository _postRepository;

  HomeScreen({
    Key key,
    @required UserRepository userRepository,
    @required RequestRepository requestRepository,
    @required SettingsRepository settingsRepository,
    @required PostRepository postRepository,
  })  : assert(userRepository != null),
        assert(requestRepository != null),
        assert(settingsRepository != null),
        assert(postRepository != null),
        _userRepository = userRepository,
        _requestRepository = requestRepository,
        _settingsRepository = settingsRepository,
        _postRepository = postRepository,
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _homeBloc;
  int _previousIndex;
  int _currentIndex = 0;
  final _postScreen = GlobalKey<NavigatorState>();
  final _searchScreen = GlobalKey<NavigatorState>();
  final _messageScreen = GlobalKey<NavigatorState>();
  final _notificationScreen = GlobalKey<NavigatorState>();
  final RecommendationRepository _recommendationRepository =
      RecommendationRepository();
  final GroupRepository _groupRepository = GroupRepository();

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
          _searchScreen.currentState.popUntil((route) => route.isFirst);
          break;
        case 2:
          _messageScreen.currentState.popUntil((route) => route.isFirst);
          break;
        case 3:
          _notificationScreen.currentState.popUntil((route) => route.isFirst);
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

  Future _getDrawerUserNavFunction() {
    GlobalKey<NavigatorState> key;
    switch (_currentIndex) {
      case 0:
        key = _postScreen;
        break;
      case 1:
        key = _searchScreen;
        break;
      case 2:
        key = _messageScreen;
        break;
      case 3:
        key = _notificationScreen;
        break;
    }

    return key.currentState.pushNamed(
      ViewUserProfileScreen.routeName,
      arguments: UserArguments(
        user: widget._userRepository.currentUserNow(),
        editable: true,
      ),
    );
  }

  Future _getDrawerSettingsFunction() {
    GlobalKey<NavigatorState> key;
    switch (_currentIndex) {
      case 0:
        key = _postScreen;
        break;
      case 1:
        key = _searchScreen;
        break;
      case 2:
        key = _messageScreen;
        break;
      case 3:
        key = _notificationScreen;
        break;
    }

    return key.currentState.pushNamed(
      SettingsScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('HOME SCREEN BUILD');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      drawerEnableOpenDragGesture: false,
      drawer: HomeDrawer(
        onUserTap: () => _getDrawerUserNavFunction(),
        onSettingsTap: () => _getDrawerSettingsFunction(),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BlocListener<HomeBloc, HomeState>(
          listener: (BuildContext context, HomeState state) {
            print('HOME SCREEN BLOC LISTENER INITIALIZED');
            if (state is HomeLoaded) {
              BlocProvider.of<MatchBloc>(context).add(LoadMatches());

              BlocProvider.of<RequestBloc>(context).add(LoadRequests());

              BlocProvider.of<GroupHomeBloc>(context).add(LoadUserGroups());
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            bloc: _homeBloc,
            builder: (BuildContext context, HomeState state) {
              if (state is HomeUninitialized || state is OnboardScreenLoaded) {
                return Visibility(visible: false, child: Container());
              }

              return BlocBuilder<HomeNavigationBarBadgeBloc,
                      HomeNavigationBarBadgeState>(
                  builder: (BuildContext context,
                      HomeNavigationBarBadgeState navBarState) {
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
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _homeBloc,
        builder: (BuildContext context, HomeState state) {
          if (state is HomeUninitialized || state is HomeInitializing) {
            return Container(
              color: Palette.containerColor,
            );
          }

          if (state is OnboardScreenLoaded) {
            return BlocProvider<OnboardingBloc>(
              create: (context) => OnboardingBloc(
                  userRepository: widget._userRepository,
                  groupRepository: _groupRepository),
              child: Navigator(
                onGenerateRoute: (RouteSettings settings) {
                  return buildOnboardingScreenRoutes(settings);
                },
              ),
            );
          }

          if (state is HomeLoaded) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<UserProfileBloc>(
                  create: (context) => UserProfileBloc(
                    userRepository: widget._userRepository,
                    settingsRepository: widget._settingsRepository,
                    userBloc: BlocProvider.of<UserBloc>(context),
                  ),
                ),
              ],
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<PostBloc>(
                        create: (context) {
                          return PostBloc(
                            userRepository: widget._userRepository,
                            postRepository: widget._postRepository,
                            groupHomeBloc:
                                BlocProvider.of<GroupHomeBloc>(context),
                          );
                        },
                      ),
                    ],
                    child: Navigator(
                      key: _postScreen,
                      onGenerateRoute: (RouteSettings settings) {
                        return buildPostScreenRoutes(settings);
                      },
                    ),
                  ),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<GroupBloc>(
                        create: (context) => GroupBloc(
                          userRepository: widget._userRepository,
                          groupRepository: _groupRepository,
                          groupHomeBloc:
                              BlocProvider.of<GroupHomeBloc>(context),
                        ),
                      ),
                      BlocProvider<SearchBloc>(
                        create: (context) => SearchBloc(
                          userRepository: widget._userRepository,
                        )..add(SearchHome()),
                      ),
                      BlocProvider<DiscoverBloc>(
                        create: (context) => DiscoverBloc(
                            userRepository: widget._userRepository,
                            recommendationRepository: _recommendationRepository,
                            groupRepository: _groupRepository)
                          ..add(LoadDiscover()),
                      ),
                      BlocProvider<PostBloc>(
                        create: (context) {
                          return PostBloc(
                            userRepository: widget._userRepository,
                            postRepository: widget._postRepository,
                            groupBloc: BlocProvider.of<GroupBloc>(context),
                          );
                        },
                      ),
                    ],
                    child: Navigator(
                      key: _searchScreen,
                      onGenerateRoute: (RouteSettings settings) {
                        return buildSearchScreenRoutes(settings);
                      },
                    ),
                  ),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<RequestListBloc>(
                        create: (context) => RequestListBloc(
                          requestBloc: BlocProvider.of<RequestBloc>(context),
                          userRepository: widget._userRepository,
                          requestRepository: widget._requestRepository,
                        ),
                      ),
                      BlocProvider<MatchListBloc>(
                        create: (context) => MatchListBloc(
                          matchBloc: BlocProvider.of<MatchBloc>(context),
                        ),
                      ),
                    ],
                    child: Navigator(
                      key: _messageScreen,
                      onGenerateRoute: (RouteSettings settings) {
                        return buildMessageScreenRoutes(settings);
                      },
                    ),
                  ),
                  Navigator(
                    key: _notificationScreen,
                    onGenerateRoute: (RouteSettings settings) {
                      return buildNotificationScreenRoutes(settings);
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
