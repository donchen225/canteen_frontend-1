import 'package:canteen_frontend/components/confirmation_dialog.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/components/profile_list.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/screens/recommended/skip_user_button.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/discover_screen.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_empty_results.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _onTapSkillFunction(
      BuildContext context, SearchShowProfile state, Skill skill) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        user: state.user,
        skill: skill,
        onConfirm: (comment) {
          BlocProvider.of<RequestBloc>(context).add(
            AddRequest(
              Request.create(
                skill: skill,
                comment: comment,
                receiverId: state.user.id,
              ),
            ),
          );

          state.isSearchResult
              ? BlocProvider.of<SearchBloc>(context).add(SearchNextUser())
              : BlocProvider.of<SearchBloc>(context).add(SearchHome());
        },
      ),
    );
  }

  Widget _loadSearchWidget(BuildContext context, SearchState state) {
    if (state is SearchUninitialized) {
      return DiscoverScreen(state.allUsers);
    } else if (state is SearchShowProfile) {
      return Scaffold(
        key: Key(state.user.id),
        floatingActionButton: SkipUserFloatingActionButton(
          onTap: () {
            state.isSearchResult
                ? BlocProvider.of<SearchBloc>(context).add(SearchNextUser())
                : BlocProvider.of<SearchBloc>(context).add(SearchHome());
          },
        ),
        body: Container(
          color: Palette.backgroundColor,
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
                onTapLearnFunction: (skill) =>
                    _onTapSkillFunction(context, state, skill),
                onTapTeachFunction: (skill) =>
                    _onTapSkillFunction(context, state, skill),
              ),
            ),
          ]),
        ),
      );
    } else if (state is SearchCompleteNoResults) {
      return SearchEmptyResults();
    } else if (state is SearchResultsEnd) {
      return Container(
        color: Palette.backgroundColor,
        child: Center(
          child: Text('No more results!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
        title: Container(
          height: 40,
          color: Colors.grey[200],
          child: Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
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
                      hintText: "Who do you want to connect with?",
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
                duration: Duration(milliseconds: animationDuration),
                switchOutCurve: Threshold(0),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(offsetdX, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: _loadSearchWidget(context, state),
              );
            }
          },
        ),
      ),
    );
  }
}
