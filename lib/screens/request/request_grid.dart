import 'package:canteen_frontend/components/profile_list.dart';
import 'package:canteen_frontend/screens/request/detailed_request_grid.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
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
        return Scaffold(
          body: DetailedRequestGrid(
            items: state.requestList,
            onTap: (request) {
              BlocProvider.of<RequestListBloc>(context)
                  .add(InspectDetailedRequest(request));
            },
          ),
        );
      } else if (state is IndividualDetailedRequestLoaded) {
        return Scaffold(
            body: Stack(
          children: <Widget>[
            Container(
              color: Palette.backgroundColor,
              child: CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  brightness: Brightness.light,
                  backgroundColor: Palette.backgroundColor,
                  title: Text(
                    state.request.sender.displayName ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                      bottom: SizeConfig.instance.blockSizeVertical * 13,
                      left: SizeConfig.instance.blockSizeHorizontal * 3,
                      right: SizeConfig.instance.blockSizeHorizontal * 3),
                  sliver: ProfileList(
                    state.request.sender,
                    key: Key('search-show-profile'),
                    skillListHeight:
                        SizeConfig.instance.blockSizeHorizontal * 33,
                  ),
                ),
              ]),
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
                    BlocProvider.of<RequestBloc>(context)
                        .add(AcceptRequest(state.request));
                  },
                  child: Icon(Icons.check),
                ),
              ),
            ),
          ],
        ));
      }
      return Container();
    });
  }
}
