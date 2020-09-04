import 'package:canteen_frontend/models/discover/discover_repository.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/notification/notification_repository.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/recommendation/recommendation_repository.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/user/firebase_user_repository.dart';
import 'package:canteen_frontend/models/user_settings/settings_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_list_bloc/match_list_bloc.dart';
import 'package:canteen_frontend/screens/message/bloc/message_bloc.dart';
import 'package:canteen_frontend/screens/notifications/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/comment_bloc.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/services/navigation_service.dart';
import 'package:canteen_frontend/services/service_locator.dart';
import 'package:canteen_frontend/shared_blocs/group/group_bloc.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:canteen_frontend/shared_blocs/profile_bloc/profile_bloc.dart';
import 'package:canteen_frontend/shared_blocs/settings/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:canteen_frontend/utils/algolia.dart';
import 'package:canteen_frontend/utils/app_config.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/push_notifications.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/home/home_screen.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/splash/splash_screen.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/simple_bloc_delegate.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting();
  await AppConfig.getInstance();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = FirebaseUserRepository();
  final SettingsRepository settingsRepository = SettingsRepository();
  final MatchRepository matchRepository = MatchRepository();
  final RequestRepository requestRepository = RequestRepository();
  final PostRepository postRepository = PostRepository();
  final GroupRepository groupRepository = GroupRepository();
  final NotificationRepository notificationRepository =
      NotificationRepository();
  setupServiceLocator();
  AlgoliaSearch.getInstance();
  await CachedSharedPreferences.getInstance();
  await PushNotificationsManager().init(settingsRepository);

  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) {
            return AuthenticationBloc(
              userRepository: userRepository,
            )..add(AppStarted());
          },
        ),
        BlocProvider<UserBloc>(
          create: (context) {
            return UserBloc(
              userRepository: userRepository,
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            );
          },
        ),
        BlocProvider<SettingBloc>(
          create: (context) {
            return SettingBloc(
              userRepository: userRepository,
              settingsRepository: settingsRepository,
            );
          },
        ),
        BlocProvider<MatchBloc>(
          create: (context) {
            return MatchBloc(
              matchRepository: matchRepository,
              userRepository: userRepository,
            );
          },
        ),
        BlocProvider<RequestBloc>(
          create: (context) {
            return RequestBloc(
              requestRepository: requestRepository,
              userRepository: userRepository,
            );
          },
        ),
        BlocProvider<MessageBloc>(
          create: (context) {
            return MessageBloc(
              matchRepository: matchRepository,
              userRepository: userRepository,
            );
          },
        ),
        BlocProvider<CommentBloc>(
          create: (context) {
            return CommentBloc(
              userRepository: userRepository,
              postRepository: postRepository,
              userBloc: BlocProvider.of<UserBloc>(context),
            );
          },
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            userRepository: userRepository,
            groupRepository: groupRepository,
          ),
        ),
        BlocProvider<MatchDetailBloc>(
          create: (BuildContext context) => MatchDetailBloc(
              matchRepository: matchRepository, userRepository: userRepository),
        ),
        BlocProvider<GroupHomeBloc>(
          create: (context) => GroupHomeBloc(
            userRepository: userRepository,
            groupRepository: groupRepository,
          ),
        ),
        BlocProvider<NotificationListBloc>(
          create: (context) => NotificationListBloc(
            userRepository: userRepository,
            notificationRepository: notificationRepository,
          ),
        ),
        BlocProvider<UserProfileBloc>(
          create: (context) => UserProfileBloc(
            userRepository: userRepository,
            settingsRepository: settingsRepository,
            userBloc: BlocProvider.of<UserBloc>(context),
          ),
        ),
      ],
      child: App(
        userRepository: userRepository,
        requestRepository: requestRepository,
        matchRepository: matchRepository,
        settingsRepository: settingsRepository,
        postRepository: postRepository,
        groupRepository: groupRepository,
        notificationRepository: notificationRepository,
      ),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;
  final RequestRepository _requestRepository;
  final MatchRepository _matchRepository;
  final SettingsRepository _settingsRepository;
  final PostRepository _postRepository;
  final GroupRepository _groupRepository;
  final NotificationRepository _notificationRepository;
  final RecommendationRepository _recommendationRepository =
      RecommendationRepository();
  final DiscoverRepository _discoverRepository = DiscoverRepository();

  App({
    Key key,
    @required UserRepository userRepository,
    @required RequestRepository requestRepository,
    @required MatchRepository matchRepository,
    @required SettingsRepository settingsRepository,
    @required PostRepository postRepository,
    @required GroupRepository groupRepository,
    @required NotificationRepository notificationRepository,
  })  : assert(userRepository != null),
        assert(requestRepository != null),
        assert(matchRepository != null),
        assert(settingsRepository != null),
        assert(postRepository != null),
        assert(groupRepository != null),
        assert(notificationRepository != null),
        _userRepository = userRepository,
        _requestRepository = requestRepository,
        _matchRepository = matchRepository,
        _settingsRepository = settingsRepository,
        _postRepository = postRepository,
        _groupRepository = groupRepository,
        _notificationRepository = notificationRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: '.SF UI Pro',
        textTheme: TextTheme(
          headline2: TextStyle(fontSize: 48),
          headline3: TextStyle(fontSize: 34, height: 1.1),
          headline4: TextStyle(fontSize: 24),
          headline5: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
            height: 1.2,
          ),
          headline6: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          subtitle1: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -0.2),
          subtitle2: TextStyle(
              fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.2),
          bodyText1: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -0.1),
          bodyText2: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            letterSpacing: -0.1,
            height: 1.2,
          ),
          button: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: -0.1),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
        brightness: Brightness.light,
        appBarTheme:
            AppBarTheme(brightness: Brightness.light, centerTitle: true),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Palette.scaffoldBackgroundDarkColor,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      navigatorKey: getIt<NavigationService>().rootNavigatorKey,
      routes: {
        '/': (context) {
          SizeConfig.instance.init(context);
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is Authenticated) {
                BlocProvider.of<UserBloc>(context)
                    .add(InitializeUser(state.user));

                AlgoliaSearch.getInstance(reset: true);

                BlocProvider.of<HomeBloc>(context).add(CheckOnboardStatus());
              }

              if (state is Unauthenticated) {
                BlocProvider.of<GroupHomeBloc>(context).add(LoadDefaultGroup());
              }
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is Uninitialized) {
                  return SplashScreen();
                }

                return MultiBlocProvider(
                  providers: [
                    BlocProvider<ProfileBloc>(
                      create: (context) => ProfileBloc(
                        userRepository: _userRepository,
                      ),
                    ),
                    BlocProvider<GroupBloc>(
                      create: (context) => GroupBloc(
                        userRepository: _userRepository,
                        groupRepository: _groupRepository,
                        groupHomeBloc: BlocProvider.of<GroupHomeBloc>(context),
                      ),
                    ),
                    BlocProvider<PostBloc>(
                      create: (context) => PostBloc(
                        userRepository: _userRepository,
                        postRepository: _postRepository,
                        groupHomeBloc: BlocProvider.of<GroupHomeBloc>(context),
                        groupBloc: BlocProvider.of<GroupBloc>(context),
                        commentBloc: BlocProvider.of<CommentBloc>(context),
                      ),
                    ),
                    BlocProvider<MatchListBloc>(
                      create: (context) => MatchListBloc(
                          matchBloc: BlocProvider.of<MatchBloc>(context),
                          matchRepository: _matchRepository),
                    ),
                    BlocProvider<RequestListBloc>(
                      create: (context) => RequestListBloc(
                        requestBloc: BlocProvider.of<RequestBloc>(context),
                        userRepository: _userRepository,
                        requestRepository: _requestRepository,
                      ),
                    ),
                    BlocProvider<SearchBloc>(
                      create: (context) => SearchBloc(),
                    ),
                    BlocProvider<HomeNavigationBarBadgeBloc>(
                      create: (BuildContext context) =>
                          HomeNavigationBarBadgeBloc(
                        matchBloc: BlocProvider.of<MatchBloc>(context),
                        requestBloc: BlocProvider.of<RequestBloc>(context),
                        notificationListBloc:
                            BlocProvider.of<NotificationListBloc>(context),
                      ),
                    ),
                    BlocProvider<DiscoverBloc>(
                      create: (context) => DiscoverBloc(
                          userRepository: _userRepository,
                          discoverRepository: _discoverRepository,
                          recommendationRepository: _recommendationRepository,
                          groupRepository: _groupRepository)
                        ..add(LoadDiscover()),
                    ),
                  ],
                  child: HomeScreen(
                    userRepository: _userRepository,
                    requestRepository: _requestRepository,
                    settingsRepository: _settingsRepository,
                    postRepository: _postRepository,
                    notificationRepository: _notificationRepository,
                  ),
                );
              },
            ),
          );
        },
      },
    );
  }
}
