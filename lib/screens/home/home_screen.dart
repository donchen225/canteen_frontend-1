import 'package:badges/badges.dart';
import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/discover/discover_repository.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/notification/notification_repository.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/recommendation/recommendation_repository.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/models/user_settings/settings_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_list_bloc/match_list_bloc.dart';
import 'package:canteen_frontend/screens/match/routes.dart';
import 'package:canteen_frontend/screens/notifications/bloc/bloc.dart';
import 'package:canteen_frontend/screens/notifications/notification_view_bloc/notification_view_bloc.dart';
import 'package:canteen_frontend/screens/notifications/routes.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_group_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_skill_screen.dart';
import 'package:canteen_frontend/screens/onboarding/routes.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/comment_bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_list_bloc/comment_list_bloc.dart';
import 'package:canteen_frontend/screens/posts/post_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/routes.dart';
import 'package:canteen_frontend/screens/posts/single_post_bloc/single_post_bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/home_drawer.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/request_list_bloc.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/routes.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:canteen_frontend/screens/splash/splash_screen.dart';
import 'package:canteen_frontend/services/home_navigation_bar_service.dart';
import 'package:canteen_frontend/services/navigation_service.dart';
import 'package:canteen_frontend/services/service_locator.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group/group_bloc.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:canteen_frontend/shared_blocs/settings/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final RequestRepository _requestRepository;
  final SettingsRepository _settingsRepository;
  final PostRepository _postRepository;
  final NotificationRepository _notificationRepository;

  HomeScreen({
    Key key,
    @required UserRepository userRepository,
    @required RequestRepository requestRepository,
    @required SettingsRepository settingsRepository,
    @required PostRepository postRepository,
    @required NotificationRepository notificationRepository,
  })  : assert(userRepository != null),
        assert(requestRepository != null),
        assert(settingsRepository != null),
        assert(postRepository != null),
        assert(notificationRepository != null),
        _userRepository = userRepository,
        _requestRepository = requestRepository,
        _settingsRepository = settingsRepository,
        _postRepository = postRepository,
        _notificationRepository = notificationRepository,
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HomeBloc _homeBloc;
  int _previousIndex;
  int _currentIndex = 0;
  DateTime _appPaused;

  final GroupRepository _groupRepository = GroupRepository();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _homeBloc = BlocProvider.of<HomeBloc>(context);

    final authenticated =
        BlocProvider.of<AuthenticationBloc>(context).state is Authenticated;
    if (!authenticated) {
      _homeBloc.add(CheckOnboardStatus());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _appPaused = DateTime.now();
        break;
      case AppLifecycleState.resumed:
        if (_appPaused != null) {
          final appResumed = DateTime.now().difference(_appPaused).inSeconds;

          if (appResumed > 600) {
            BlocProvider.of<HomeNavigationBarBadgeBloc>(context)
                .add(LoadBadgeCounts());

            BlocProvider.of<MatchBloc>(context).add(LoadMatches());

            // BlocProvider.of<RequestListBloc>(context).add(LoadRequestList());
            BlocProvider.of<RequestBloc>(context).add(LoadRequests());

            BlocProvider.of<GroupHomeBloc>(context)
                .add(LoadUserGroups(showLoading: false));

            BlocProvider.of<SettingBloc>(context).add(InitializeSettings());

            BlocProvider.of<NotificationListBloc>(context)
                .add(LoadNotifications());

            BlocProvider.of<DiscoverBloc>(context).add(LoadDiscover());
          }
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });

    // Double tap on tab logic
    if (_previousIndex != null && _previousIndex == _currentIndex) {
      switch (_currentIndex) {
        case 0:
          // TODO: clean up this animation so only one screen is shown
          getIt<NavigationService>()
              .homeNavigatorKey
              .currentState
              .popUntil((route) => route.isFirst);
          BlocProvider.of<SearchBloc>(context).add(ResetSearch());
          break;
        case 1:
          getIt<NavigationService>()
              .searchNavigatorKey
              .currentState
              .popUntil((route) => route.isFirst);
          break;
        case 2:
          getIt<NavigationService>()
              .messageNavigatorKey
              .currentState
              .popUntil((route) => route.isFirst);
          break;
        case 3:
          getIt<NavigationService>()
              .notificationNavigatorKey
              .currentState
              .popUntil((route) => route.isFirst);
          break;
      }
    }

    switch (_currentIndex) {
      case 3:
        BlocProvider.of<HomeNavigationBarBadgeBloc>(context)
            .add(ReadNotificationCount());
        break;
    }
  }

  Widget _buildBadge(int count, Widget child) {
    if (count == 0) {
      return child;
    }

    return Badge(
      badgeColor: Palette.badgeColor,
      toAnimate: false,
      badgeContent: Text(
        count.toString(),
        style: count < 10
            ? TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              )
            : TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 9,
              ),
      ),
      position: BadgePosition.topRight(top: -7, right: -8),
      showBadge: count != 0,
      child: child,
    );
  }

  Future _getDrawerUserNavFunction() {
    GlobalKey<NavigatorState> key;
    switch (_currentIndex) {
      case 0:
        key = getIt<NavigationService>().homeNavigatorKey;
        break;
      case 1:
        key = getIt<NavigationService>().searchNavigatorKey;
        break;
      case 2:
        key = getIt<NavigationService>().messageNavigatorKey;
        break;
      case 3:
        key = getIt<NavigationService>().notificationNavigatorKey;
        break;
    }

    return key.currentState.pushNamed(
      ViewUserProfileScreen.routeName,
      arguments: UserArguments(
        user: widget._userRepository.currentUserNow(),
      ),
    );
  }

  Future _getDrawerSettingsFunction() {
    GlobalKey<NavigatorState> key;
    switch (_currentIndex) {
      case 0:
        key = getIt<NavigationService>().homeNavigatorKey;
        break;
      case 1:
        key = getIt<NavigationService>().searchNavigatorKey;
        break;
      case 2:
        key = getIt<NavigationService>().messageNavigatorKey;
        break;
      case 3:
        key = getIt<NavigationService>().notificationNavigatorKey;
        break;
    }

    return key.currentState.pushNamed(
      SettingsScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomAppBarHeight = (SizeConfig.instance.paddingBottom == 0
            ? kBottomNavBarHeightNoNotch
            : kBottomNavBarHeightWithNotch) +
        SizeConfig.instance.paddingBottom;
    final iconHeight = SizeConfig.instance.paddingBottom == 0
        ? bottomAppBarHeight
        : bottomAppBarHeight * 0.7;

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
          listener: (BuildContext context, HomeState state) {},
          child: BlocBuilder<HomeBloc, HomeState>(
            bloc: _homeBloc,
            builder: (BuildContext context, HomeState state) {
              if (state is HomeUninitialized ||
                  state is OnboardScreenLoaded ||
                  state is HomeLoading) {
                return Visibility(visible: false, child: Container());
              }

              return BlocBuilder<HomeNavigationBarBadgeBloc,
                      HomeNavigationBarBadgeState>(
                  builder: (BuildContext context,
                      HomeNavigationBarBadgeState navBarState) {
                return SizedBox(
                  height: bottomAppBarHeight,
                  child: BottomNavigationBar(
                    key: getIt<NavigationBarService>().homeNavigationBarKey,
                    currentIndex: _currentIndex,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    selectedFontSize: kBottomNavigationBarFontSize,
                    unselectedFontSize: kBottomNavigationBarFontSize,
                    backgroundColor: Palette.appBarBackgroundColor,
                    type: BottomNavigationBarType.fixed,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: FaIcon(
                          FontAwesomeIcons.home,
                          size: iconHeight * 0.38,
                        ),
                        title: Text(''),
                      ),
                      BottomNavigationBarItem(
                        icon: FaIcon(
                          FontAwesomeIcons.search,
                          size: iconHeight * 0.38,
                        ),
                        title: Text(''),
                      ),
                      BottomNavigationBarItem(
                        icon: _buildBadge(
                          navBarState.numRequests + navBarState.numMessages,
                          FaIcon(
                            FontAwesomeIcons.envelope,
                            size: iconHeight * 0.4,
                          ),
                        ),
                        title: Text(''),
                      ),
                      BottomNavigationBarItem(
                        icon: _buildBadge(
                          navBarState.numNotifications,
                          FaIcon(
                            FontAwesomeIcons.bell,
                            size: iconHeight * 0.4,
                          ),
                        ),
                        title: Text(''),
                      ),
                    ],
                    onTap: (int index) => _onItemTapped(context, index),
                  ),
                );
              });
            },
          ),
        ),
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (BuildContext context, HomeState state) {
          if (state is HomeLoaded) {
            if (state.authenticated && !state.dataLoaded) {
              BlocProvider.of<HomeNavigationBarBadgeBloc>(context)
                  .add(LoadBadgeCounts());

              BlocProvider.of<MatchBloc>(context).add(LoadMatches());

              // BlocProvider.of<RequestListBloc>(context).add(LoadRequestList());
              BlocProvider.of<RequestBloc>(context).add(LoadRequests());

              BlocProvider.of<GroupHomeBloc>(context)
                  .add(LoadUserGroups(showLoading: true));

              BlocProvider.of<SettingBloc>(context).add(InitializeSettings());

              BlocProvider.of<NotificationListBloc>(context)
                  .add(LoadNotifications());

              BlocProvider.of<DiscoverBloc>(context).add(LoadDiscover());

              BlocProvider.of<SearchBloc>(context).add(ResetSearch());

              _homeBloc.add(UserHomeLoaded());
            }
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeBloc,
          builder: (BuildContext context, HomeState state) {
            if (state is HomeUninitialized || state is HomeLoading) {
              return SplashScreen();
            }

            if (state is OnboardScreenLoaded) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<OnboardingBloc>(
                    create: (context) => OnboardingBloc(
                        userRepository: widget._userRepository,
                        groupRepository: _groupRepository),
                  ),
                ],
                child: Navigator(
                  initialRoute: OnboardingSkillScreen.routeName,
                  onGenerateRoute: (RouteSettings settings) {
                    return buildOnboardingScreenRoutes(settings);
                  },
                ),
              );
            }

            if (state is HomeLoaded) {
              if (state.authenticated && !state.dataLoaded) {
                _homeBloc.add(LoadHome());
              }

              return IndexedStack(
                index: _currentIndex,
                children: [
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<PostListBloc>(
                        create: (context) => PostListBloc(
                          userRepository: widget._userRepository,
                          postRepository: widget._postRepository,
                          groupHomeBloc:
                              BlocProvider.of<GroupHomeBloc>(context),
                          postBloc: BlocProvider.of<PostBloc>(context),
                        ),
                      ),
                      BlocProvider<SinglePostBloc>(
                        create: (context) => SinglePostBloc(
                          postBloc: BlocProvider.of<PostBloc>(context),
                          postRepository: widget._postRepository,
                        ),
                      ),
                      BlocProvider<CommentListBloc>(
                        create: (context) => CommentListBloc(
                          commentBloc: BlocProvider.of<CommentBloc>(context),
                          postRepository: widget._postRepository,
                        ),
                      ),
                    ],
                    child: Navigator(
                      key: getIt<NavigationService>().homeNavigatorKey,
                      onGenerateRoute: (RouteSettings settings) {
                        return buildHomeScreenRoutes(context, settings);
                      },
                    ),
                  ),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<PostListBloc>(
                        create: (context) => PostListBloc(
                          userRepository: widget._userRepository,
                          postRepository: widget._postRepository,
                          postBloc: BlocProvider.of<PostBloc>(context),
                          groupBloc: BlocProvider.of<GroupBloc>(context),
                        ),
                      ),
                      BlocProvider<SinglePostBloc>(
                        create: (context) => SinglePostBloc(
                          postBloc: BlocProvider.of<PostBloc>(context),
                          postRepository: widget._postRepository,
                        ),
                      ),
                      BlocProvider<CommentListBloc>(
                        create: (context) => CommentListBloc(
                          commentBloc: BlocProvider.of<CommentBloc>(context),
                          postRepository: widget._postRepository,
                        ),
                      ),
                    ],
                    child: Navigator(
                      key: getIt<NavigationService>().searchNavigatorKey,
                      onGenerateRoute: (RouteSettings settings) {
                        return buildSearchScreenRoutes(context, settings);
                      },
                    ),
                  ),
                  Navigator(
                    key: getIt<NavigationService>().messageNavigatorKey,
                    onGenerateRoute: (RouteSettings settings) {
                      return buildMessageScreenRoutes(settings);
                    },
                  ),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<NotificationViewBloc>(
                        create: (context) => NotificationViewBloc(
                          userRepository: widget._userRepository,
                          notificationRepository:
                              widget._notificationRepository,
                          postRepository: widget._postRepository,
                        ),
                      ),
                      BlocProvider<CommentListBloc>(
                        create: (context) => CommentListBloc(
                          commentBloc: BlocProvider.of<CommentBloc>(context),
                          postRepository: widget._postRepository,
                        ),
                      ),
                    ],
                    child: Navigator(
                      key: getIt<NavigationService>().notificationNavigatorKey,
                      onGenerateRoute: (RouteSettings settings) {
                        return buildNotificationScreenRoutes(settings);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
