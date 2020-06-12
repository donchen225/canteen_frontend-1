import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/user/firebase_user_repository.dart';
import 'package:canteen_frontend/models/user_settings/settings_repository.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/bloc.dart';
import 'package:canteen_frontend/screens/landing/landing_screen.dart';
import 'package:canteen_frontend/screens/landing/routes.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/message/bloc/message_bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/comment_bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:canteen_frontend/shared_blocs/profile_bloc/profile_bloc.dart';
import 'package:canteen_frontend/shared_blocs/settings/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:canteen_frontend/utils/algolia.dart';
import 'package:canteen_frontend/utils/palette.dart';
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
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = FirebaseUserRepository();
  final SettingsRepository settingsRepository = SettingsRepository();
  final MatchRepository matchRepository = MatchRepository();
  final RequestRepository requestRepository = RequestRepository();
  final PostRepository postRepository = PostRepository();
  final VideoChatRepository videoChatRepository = VideoChatRepository();
  final GroupRepository groupRepository = GroupRepository();
  await CachedSharedPreferences.getInstance();
  AlgoliaSearch.getInstance();
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
              matchRepository: matchRepository,
              videoChatRepository: videoChatRepository),
        ),
        BlocProvider<HomeNavigationBarBadgeBloc>(
          create: (BuildContext context) => HomeNavigationBarBadgeBloc(
              requestBloc: BlocProvider.of<RequestBloc>(context)),
        ),
      ],
      child: App(
        userRepository: userRepository,
        requestRepository: requestRepository,
        settingsRepository: settingsRepository,
        postRepository: postRepository,
        groupRepository: groupRepository,
      ),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;
  final RequestRepository _requestRepository;
  final SettingsRepository _settingsRepository;
  final PostRepository _postRepository;
  final GroupRepository _groupRepository;

  App({
    Key key,
    @required UserRepository userRepository,
    @required RequestRepository requestRepository,
    @required SettingsRepository settingsRepository,
    @required PostRepository postRepository,
    @required GroupRepository groupRepository,
  })  : assert(userRepository != null),
        assert(requestRepository != null),
        assert(settingsRepository != null),
        assert(postRepository != null),
        assert(groupRepository != null),
        _userRepository = userRepository,
        _requestRepository = requestRepository,
        _settingsRepository = settingsRepository,
        _postRepository = postRepository,
        _groupRepository = groupRepository,
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
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: -0.25),
          headline6: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: -0.1),
          subtitle1: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -0.2),
          subtitle2: TextStyle(
              fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.2),
          bodyText1: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -0.1),
          bodyText2: TextStyle(
              fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.1),
          button: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -0.1),
        ),
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(brightness: Brightness.light),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Palette.scaffoldBackgroundDarkColor,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      routes: {
        '/': (context) {
          SizeConfig.instance.init(context);
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is Authenticated) {
                BlocProvider.of<UserBloc>(context)
                    .add(InitializeUser(state.user));
              }
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is Uninitialized) {
                  return SplashScreen();
                }
                if (state is Unauthenticated) {
                  return Navigator(
                    onGenerateRoute: (RouteSettings settings) {
                      return buildLandingScreenRoutes(settings);
                    },
                  );
                }
                if (state is Authenticated) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<GroupHomeBloc>(
                        create: (context) => GroupHomeBloc(
                          userRepository: _userRepository,
                          groupRepository: _groupRepository,
                        ),
                      ),
                      BlocProvider<ProfileBloc>(
                        create: (context) => ProfileBloc(
                          userRepository: _userRepository,
                        ),
                      ),
                    ],
                    child: HomeScreen(
                      userRepository: _userRepository,
                      requestRepository: _requestRepository,
                      settingsRepository: _settingsRepository,
                      postRepository: _postRepository,
                    ),
                  );
                }
                return Container();
              },
            ),
          );
        },
      },
    );
  }
}
