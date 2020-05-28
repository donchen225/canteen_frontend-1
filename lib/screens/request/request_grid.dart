import 'package:canteen_frontend/components/profile_list.dart';
import 'package:canteen_frontend/screens/request/detailed_request_grid.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/view_user_profile_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestGrid extends StatelessWidget {
  RequestGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestListBloc, RequestListState>(
        builder: (context, state) {
      if (state is RequestListLoading || state is RequestListLoaded) {
        return Center(child: CupertinoActivityIndicator());
      } else if (state is DetailedRequestListLoaded) {
        return DetailedRequestGrid(
          items: state.requestList,
          onTap: (request) {
            BlocProvider.of<RequestListBloc>(context)
                .add(InspectDetailedRequest(request));
          },
        );
      } else if (state is IndividualDetailedRequestLoaded) {
        return ViewUserProfileScreen(
            user: state.request.sender,
            onTapBack: () => BlocProvider.of<RequestListBloc>(context)
                .add(LoadRequestList()));
      }
      return Container();
    });
  }
}
