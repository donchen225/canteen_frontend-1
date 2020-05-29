import 'package:canteen_frontend/screens/request/detailed_request_grid.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
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
        );
      }
      return Container();
    });
  }
}
