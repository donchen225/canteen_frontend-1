import 'package:canteen_frontend/components/platform/platform_loading_indicator.dart';
import 'package:canteen_frontend/components/user_profile_body.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/request/confirm_request_dialog.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/profile_bloc/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewUserRequestScreen extends StatefulWidget {
  final Request request;
  final User user;
  static const routeName = '/request';

  ViewUserRequestScreen({this.request, this.user});

  @override
  _ViewUserRequestScreenState createState() => _ViewUserRequestScreenState();
}

class _ViewUserRequestScreenState extends State<ViewUserRequestScreen> {
  String _buildRequestText(DetailedRequest request) {
    if (request is Referral) {
      return "${request.sender.displayName} asked you for a referral to connect with ${request.receiver.displayName} for ${request.skill} - \$${request.price.toStringAsFixed(2)}";
    } else if (request is ReferredRequest) {
      return "${request.referral.displayName} referred ${request.sender.displayName} to you for ${request.skill} - \$${request.price.toStringAsFixed(2)}";
    } else {
      return "Sent you a request for ${request.skill} - \$${request.price.toStringAsFixed(2)}";
    }
  }

  Widget _buildCommentText(BuildContext context, DetailedRequest request) {
    String comment = "";
    if (request is Referral) {
      if (request.referralComment != null &&
          request.referralComment.isNotEmpty) {
        comment = "\"${request.referralComment}\"";
      }
    } else {
      if (request.comment != null && request.comment.isNotEmpty) {
        comment = "\"${request.comment}\"";
      }
    }

    if (comment.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          comment,
          style: Theme.of(context).textTheme.bodyText2.apply(
                fontStyle: FontStyle.italic,
              ),
        ),
      );
    }

    return Container();
  }

  Widget _buildProfileWidget(BuildContext context, User user) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;

    return user != null
        ? UserProfileBody(
            user: user,
            canConnect: false,
            headerWidget: Container(
              margin: EdgeInsets.only(
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: SizeConfig.instance.safeBlockHorizontal * 6,
                  right: SizeConfig.instance.safeBlockHorizontal * 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _buildRequestText(widget.request),
                      style: bodyTextStyle.apply(
                        fontWeightDelta: 1,
                      ),
                    ),
                    _buildCommentText(context, widget.request),
                  ],
                ),
              ),
            ),
          )
        : _buildBlocProfile(context);
  }

  Widget _buildBlocProfile(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (BuildContext context, ProfileState state) {
        if (state is ProfileUninitialized) {
          return Container();
        }

        if (state is ProfileLoading) {
          return Center(child: PlatformLoadingIndicator());
        }

        if (state is ProfileLoaded) {
          final user = state.user;
          return UserProfileBody(
            user: user,
            canConnect: false,
          );
        }

        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.scaffoldBackgroundDarkColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.instance.appBarHeight),
        child: AppBar(
          backgroundColor: Palette.containerColor,
          elevation: 0,
          leading: BackButton(
            color: Palette.primaryColor,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.white,
              onPressed: () {
                BlocProvider.of<RequestBloc>(context).add(DeclineRequest(
                  requestId: widget.request.id,
                  isReferral: widget.request is Referral,
                ));
                Navigator.maybePop(context);
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: Palette.textColor,
              ),
            ),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Palette.primaryColor,
              onPressed: () async {
                final val = await showDialog(
                    context: context,
                    builder: (BuildContext context) => ConfirmRequestDialog(
                        user: widget.user,
                        request: widget.request,
                        onTap: (String comment) {
                          BlocProvider.of<RequestBloc>(context)
                              .add(AcceptRequest(
                            requestId: widget.request.id,
                            isReferral: widget.request is Referral,
                            comment: comment,
                          ));
                        }));
                if (val != null && val) {
                  Navigator.maybePop(context);
                }
              },
              child: Icon(
                Icons.check,
                size: 30,
              ),
            )
          ],
        ),
      ),
      body: _buildProfileWidget(context, widget.user),
    );
  }
}
