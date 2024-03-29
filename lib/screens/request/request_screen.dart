import 'package:canteen_frontend/components/platform/platform_loading_indicator.dart';
import 'package:canteen_frontend/components/small_button.dart';
import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/screens/request/request_list.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestScreen extends StatelessWidget {
  RequestScreen();

  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RequestListBloc, RequestListState>(
          builder: (context, state) {
        if (state is RequestListLoading || state is RequestListLoaded) {
          return Center(child: PlatformLoadingIndicator());
        } else if (state is RequestListUnauthenticated) {
          return Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.commentDots,
                  color: Colors.grey,
                  size: 80,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.instance.safeBlockVertical,
                    bottom: SizeConfig.instance.safeBlockVertical * 2,
                  ),
                  child: Text('Requests will appear here',
                      style: Theme.of(context).textTheme.bodyText2),
                ),
                SmallButton(
                  text: 'Sign Up',
                  onPressed: () => UnauthenticatedFunctions.showSignUp(context),
                ),
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
