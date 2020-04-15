import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/screens/profile/profile_list.dart';
import 'package:canteen_frontend/screens/recommended/skip_user_button.dart';
import 'package:canteen_frontend/screens/request/profile_grid.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_empty_results.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
  }

  Widget _loadSearchWidget(SearchState state) {
    if (state is SearchUninitialized) {
      return ProfileGrid(
        state.allUsers,
        key: Key('search-home-page'),
        onTap: (user) {
          BlocProvider.of<SearchBloc>(context).add(SearchInspectUser(user));
        },
      );
    } else if (state is SearchShowProfile) {
      return Scaffold(
        floatingActionButton: SkipUserFloatingActionButton(
          onTap: () {
            BlocProvider.of<SearchBloc>(context).add(SearchNextUser());
          },
        ),
        body: Container(
          color: Colors.grey[100],
          child: CustomScrollView(slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: SizeConfig.instance.blockSizeVertical * 13,
                  left: SizeConfig.instance.blockSizeHorizontal * 3,
                  right: SizeConfig.instance.blockSizeHorizontal * 3),
              sliver: ProfileList(
                state.user,
                key: Key('search-show-profile'),
                height: SizeConfig.instance.blockSizeHorizontal * 33,
                showName: true,
                onTapLearnFunction: (skill) {
                  BlocProvider.of<RequestBloc>(context).add(
                    AddRequest(
                      Request.create(
                        skill: skill,
                        receiverId: state.user.id,
                      ),
                    ),
                  );
                },
                onTapTeachFunction: (skill) {
                  BlocProvider.of<RequestBloc>(context).add(
                    AddRequest(
                      Request.create(
                        skill: skill,
                        receiverId: state.user.id,
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      );
    } else if (state is SearchCompleteNoResults) {
      return SearchEmptyResults();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Container(
          height: 40,
          color: Colors.grey[300],
          child: Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey[800],
                      ),
                      border: InputBorder.none,
                      hintText: "Search",
                    ),
                    onSubmitted: (query) {
                      print('SUBMITTED: $query');
                      BlocProvider.of<SearchBloc>(context)
                          .add(SearchStarted(query));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTapDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                switchOutCurve: Threshold(0),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.5, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: _loadSearchWidget(state),
              );
            }
          },
        ),
      ),
    );
  }
}
