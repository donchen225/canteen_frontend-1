import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/user/firebase_user_repository.dart';
import 'package:canteen_frontend/models/user_settings/settings_repository.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/bloc.dart';
import 'package:canteen_frontend/screens/login/login_screen.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/message/bloc/message_bloc.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/comment_bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group/group_bloc.dart';
import 'package:canteen_frontend/shared_blocs/login_navigation/login_navigation_bloc.dart';
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
        BlocProvider<PostBloc>(
          create: (context) {
            return PostBloc(
              userRepository: userRepository,
              postRepository: postRepository,
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
            settingBloc: BlocProvider.of<SettingBloc>(context),
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
      ),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;
  final RequestRepository _requestRepository;
  final SettingsRepository _settingsRepository;
  final GroupRepository _groupRepository = GroupRepository();

  App(
      {Key key,
      @required UserRepository userRepository,
      @required RequestRepository requestRepository,
      @required SettingsRepository settingsRepository})
      : assert(userRepository != null),
        assert(requestRepository != null),
        assert(settingsRepository != null),
        _userRepository = userRepository,
        _requestRepository = requestRepository,
        _settingsRepository = settingsRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: '.SF UI Pro',
        textTheme: TextTheme(
          headline4: TextStyle(fontSize: 34),
          headline5: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          headline6: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          button: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
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
                  return BlocProvider<LoginNavigationBloc>(
                    create: (context) => LoginNavigationBloc(),
                    child: LoginScreen(userRepository: _userRepository),
                  );
                }
                if (state is Authenticated) {
                  return BlocProvider<GroupBloc>(
                    create: (context) => GroupBloc(
                      userRepository: _userRepository,
                      groupRepository: _groupRepository,
                    ),
                    child: HomeScreen(
                      userRepository: _userRepository,
                      requestRepository: _requestRepository,
                      settingsRepository: _settingsRepository,
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
