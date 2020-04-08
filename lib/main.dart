import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/user/firebase_user_repository.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_bloc.dart';
import 'package:canteen_frontend/screens/prospect_profile/bloc/prospect_profile_bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:flutter/material.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = FirebaseUserRepository();
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
              matchRepository: MatchRepository(),
              userRepository: userRepository,
            );
          },
        ),
        BlocProvider<RequestBloc>(
          create: (context) {
            return RequestBloc(
              requestRepository: RequestRepository(),
            );
          },
        ),
      ],
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(),
          primaryColor: Color.fromARGB(255, 34, 145, 133)),
      routes: {
        '/': (context) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is Authenticated) {
                BlocProvider.of<UserBloc>(context)
                    .add(InitializeUser(state.user));

                BlocProvider.of<MatchBloc>(context)
                    .add(LoadMatches(state.user.uid));

                BlocProvider.of<RequestBloc>(context)
                    .add(LoadRequests(state.user.uid));
              }
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
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
                      BlocProvider<SearchBloc>(
                        create: (context) => SearchBloc(
                          userRepository: _userRepository,
                        ),
                      ),
                      BlocProvider<UserProfileBloc>(
                        create: (context) => UserProfileBloc(
                          userRepository: _userRepository,
                          userBloc: BlocProvider.of<UserBloc>(context),
                        ),
                      ),
                      BlocProvider<ProspectProfileBloc>(
                        create: (context) => ProspectProfileBloc(),
                      )
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
