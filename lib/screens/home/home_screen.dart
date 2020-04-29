import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_list_screen.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/onboarding_bloc.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/user_profile_screen.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/screens/recommended/recommended_screen.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_screen.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_screen.dart';
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

  @override
  void initState() {
    super.initState();

    _homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  void _onItemTapped(int index) {
    _homeBloc.add(PageTapped(index: index));
  }

  @override
  Widget build(BuildContext context) {
    print('HOME SCREEN BUILD');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
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

              BlocProvider.of<MatchBloc>(context).add(LoadMatches());

              BlocProvider.of<RequestBloc>(context).add(LoadRequests());

              BlocProvider.of<RecommendedBloc>(context).add(LoadRecommended());
            }

            if (state is SearchScreenLoaded) {
              if (state.reset) {
                BlocProvider.of<SearchBloc>(context).add(SearchHome());
              }
            }

            if (state is RequestScreenLoaded) {
              if (state.reset) {
                BlocProvider.of<RequestListBloc>(context)
                    .add(LoadRequestList());
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

              return BottomNavigationBar(
                currentIndex: _homeBloc.currentIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                selectedItemColor: Palette.orangeColor,
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    title: Text(''),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                    ),
                    title: Text(''),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.email,
                    ),
                    title: Text(''),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.sms,
                    ),
                    title: Text(''),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    title: Text(''),
                  ),
                ],
                onTap: _onItemTapped,
              );
            },
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _homeBloc,
        builder: (BuildContext context, HomeState state) {
          print('IN HOME SCREEN BLOC BUILDER');

          if (state is HomeUninitialized) {
            _homeBloc.add(CheckOnboardStatus());
          }

          if (state is HomeInitializing ||
              state is PageLoading ||
              state is CurrentIndexChanged) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (state is RecommendedScreenLoaded) {
            print('IN HOME SCREEN - RECOMMENDEDSCREENLOADED STATE');
            return RecommendedScreen();
          }
          if (state is SearchScreenLoaded) {
            return SearchScreen();
          }
          if (state is RequestScreenLoaded) {
            return RequestScreen();
          }
          if (state is MatchScreenLoaded) {
            return MatchListScreen();
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
        },
      ),
    );
  }
}
