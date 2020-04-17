import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/user/firebase_user_repository.dart';
import 'package:canteen_frontend/screens/message/bloc/message_bloc.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_bloc.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/screens/recommended/bloc/recommended_bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:canteen_frontend/utils/algolia.dart';
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
import 'package:canteen_frontend/screens/login/login_screen.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/splash/splash_screen.dart';
import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/simple_bloc_delegate.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = FirebaseUserRepository();
  final MatchRepository matchRepository = MatchRepository();
  final RequestRepository requestRepository = RequestRepository();
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
        BlocProvider<RecommendedBloc>(
          create: (context) {
            return RecommendedBloc(
              userRepository: userRepository,
            );
          },
        ),
      ],
      child: App(
        userRepository: userRepository,
        requestRepository: requestRepository,
      ),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;
  final RequestRepository _requestRepository;

  App(
      {Key key,
      @required UserRepository userRepository,
      @required RequestRepository requestRepository})
      : assert(userRepository != null),
        assert(requestRepository != null),
        _userRepository = userRepository,
        _requestRepository = requestRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        primaryColor: Color.fromARGB(255, 34, 145, 133),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      routes: {
        '/': (context) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is Authenticated) {
                BlocProvider.of<UserBloc>(context)
                    .add(InitializeUser(state.user));

                BlocProvider.of<MatchBloc>(context).add(LoadMatches());

                BlocProvider.of<RequestBloc>(context).add(LoadRequests());

                BlocProvider.of<RecommendedBloc>(context)
                    .add(LoadRecommended());
              }
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                SizeConfig.instance.init(context);
                if (state is Uninitialized) {
                  return SplashScreen();
                }
                if (state is Unauthenticated) {
                  return LoginScreen(userRepository: _userRepository);
                }
                if (state is Authenticated) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<MatchListBloc>(
                        create: (context) => MatchListBloc(
                          matchBloc: BlocProvider.of<MatchBloc>(context),
                          userRepository: _userRepository,
                        ),
                      ),
                      BlocProvider<RequestListBloc>(
                        create: (context) => RequestListBloc(
                          requestBloc: BlocProvider.of<RequestBloc>(context),
                          userRepository: _userRepository,
                          requestRepository: _requestRepository,
                        ),
                      ),
                      BlocProvider<SearchBloc>(
                        create: (context) => SearchBloc(
                          userRepository: _userRepository,
                        )..add(SearchHome()),
                      ),
                      BlocProvider<UserProfileBloc>(
                        create: (context) => UserProfileBloc(
                          userRepository: _userRepository,
                          userBloc: BlocProvider.of<UserBloc>(context),
                        ),
                      ),
                    ],
                    child: HomeScreen(userRepository: _userRepository),
                  );
                }
              },
            ),
          );
        },
        "/splash": (context) => SplashScreen(),
      },
    );
  }
}
