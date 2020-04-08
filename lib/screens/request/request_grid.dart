import 'package:canteen_frontend/screens/profile/profile_list.dart';
import 'package:canteen_frontend/screens/request/profile_grid.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
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
        return ProfileGrid(
          state.requestList.map((request) => request.sender).toList(),
          items: state.requestList,
          onTap: (request) {
            BlocProvider.of<RequestListBloc>(context)
                .add(InspectDetailedRequest(request));
          },
        );
      } else if (state is IndividualDetailedRequestLoaded) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.request.sender.displayName ?? ''),
          ),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 5,
            child: Icon(Icons.message),
            onPressed: () {
              // BlocProvider.of<ProspectProfileBloc>(context)
              //     .add(ConfirmProspectProfile(user));
            },
          ),
          body: ProfileList(
            state.request.sender,
            height: 100,
          ),
        );
      }
    });
  }
}
