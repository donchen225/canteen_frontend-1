import 'package:canteen_frontend/components/sign_up_button.dart';
import 'package:canteen_frontend/screens/request/request_list.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestScreen extends StatelessWidget {
  RequestScreen();

  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RequestListBloc, RequestListState>(
          builder: (context, state) {
        if (state is RequestListLoading || state is RequestListLoaded) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is RequestListUnauthenticated) {
          return Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sms,
                  size: 50,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.safeBlockVertical,
                  ),
                  child: Text('Requests will appear here'),
                ),
                SignUpButton(),
              ],
            ),
          );
        } else if (state is DetailedRequestListLoaded) {
          return RequestList(
            items: state.requestList,
          );
        }
        return Container();
      }),
    );
  }
}
