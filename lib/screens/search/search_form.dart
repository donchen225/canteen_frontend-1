import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchForm extends StatefulWidget {
  final UserRepository _userRepository;

  SearchForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          print('IN SEARCH FORM');
          if (state is SearchLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SearchEmpty) {
            return GridView.builder(
              padding: EdgeInsets.only(top: 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemCount: state.allUsers.length,
              itemBuilder: (context, index) {
                final user = state.allUsers[index];

                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<SearchBloc>(context)
                        .add(SearchInspectUser(user));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Container(
                          width: 150, // TODO: change this to be dynamic
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: (user.photoUrl != null &&
                                      user.photoUrl.isNotEmpty)
                                  ? CachedNetworkImageProvider(user.photoUrl)
                                  : AssetImage(
                                      'assets/blank-profile-picture.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                          child: Text(user.displayName ?? ''),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: user.teachSkill.length,
                            itemBuilder: (context, index) {
                              final skill = user.teachSkill[index];
                              return Text((skill.name ?? '') +
                                  ' - ' +
                                  ('\$${skill.price.toString()}' ?? ''));
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is SearchCompleteWithResults) {
            return ListView.builder(
              itemCount: state.userList.length,
              itemBuilder: (context, index) {
                final user = state.userList[index];

                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<SearchBloc>(context)
                        .add(SearchInspectUser(user));
                  },
                  child: ListTile(
                    leading: Container(
                      width: 50, // TODO: change this to be dynamic
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: (user.photoUrl != null &&
                                  user.photoUrl.isNotEmpty)
                              ? CachedNetworkImageProvider(user.photoUrl)
                              : AssetImage('assets/blank-profile-picture.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(user.displayName ?? ''),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
