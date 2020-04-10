import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/screens/chat/chat_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_list.dart';
import 'package:canteen_frontend/screens/request/profile_grid.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestGrid extends StatelessWidget {
  RequestGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestListBloc, RequestListState>(
        builder: (context, state) {
      if (state is RequestListLoading || state is RequestListLoaded) {
        // TODO: show something when in MatchListLoaded state
        return Center(child: CircularProgressIndicator());
      } else if (state is DetailedRequestListLoaded) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Requests'),
          ),
          body: ProfileGrid(
            state.requestList.map((request) => request.sender).toList(),
            items: state.requestList,
            onTap: (request) {
              BlocProvider.of<RequestListBloc>(context)
                  .add(InspectDetailedRequest(request));
            },
          ),
        );
      } else if (state is IndividualDetailedRequestLoaded) {
        return Scaffold(
            appBar: AppBar(
              title: Text(state.request.sender.displayName ?? ''),
            ),
            body: Stack(
              children: <Widget>[
                ProfileList(
                  state.request.sender,
                  height: 100,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: FloatingActionButton(
                      onPressed: () {
                        BlocProvider.of<RequestBloc>(context)
                            .add(DeclineRequest(state.request));
                      },
                      child: Icon(Icons.clear),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: FloatingActionButton(
                      onPressed: () {
                        final userList = [
                          state.request.senderId,
                          state.request.receiverId
                        ];
                        BlocProvider.of<RequestBloc>(context)
                            .add(AcceptRequest(state.request));

                        BlocProvider.of<MatchBloc>(context).add(
                          AddMatch(
                            Match.create(userId: userList),
                          ),
                        );

                        BlocProvider.of<ChatBloc>(context).add(
                          AddChat(
                            Chat.create(userId: userList),
                          ),
                        );
                      },
                      child: Icon(Icons.check),
                    ),
                  ),
                ),
              ],
            ));
      }
    });
  }
}
