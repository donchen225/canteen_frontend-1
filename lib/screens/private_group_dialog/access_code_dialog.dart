import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/private_group_dialog/bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccessCodeDialog extends StatefulWidget {
  final String groupId;
  final Function onSuccess;

  AccessCodeDialog({@required this.groupId, this.onSuccess});

  @override
  _AccessCodeDialogState createState() => _AccessCodeDialogState();
}

class _AccessCodeDialogState extends State<AccessCodeDialog> {
  TextEditingController _controller;
  String _error = '';

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _controller.addListener(_resetError);
  }

  void _resetError() {}

  Widget _buildDialogContent(BuildContext context, PrivateGroupState state) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    final buttonTextStyle = Theme.of(context).textTheme.button;

    if (state is PrivateGroupJoined) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green[600],
            ),
          ),
          Text('Successfully joined group!',
              style: Theme.of(context).textTheme.headline6),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          child: Text(
            'Enter access code',
            style: Theme.of(context).textTheme.bodyText1.apply(
                  fontWeightDelta: 2,
                ),
          ),
        ),
        Container(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                autocorrect: false,
                cursorColor: Palette.primaryColor,
                style: bodyTextStyle.apply(
                  color: Palette.textColor,
                ),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              Visibility(
                visible: state is PrivateGroupJoinFailed,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Container(
                  width: 240,
                  padding: EdgeInsets.only(top: 6),
                  child: Text(_error,
                      style:
                          bodyTextStyle.apply(color: Palette.textErrorColor)),
                ),
              ),
            ],
          ),
        ),
        RaisedButton(
          elevation: 0,
          focusElevation: 0,
          disabledElevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          color: Colors.transparent,
          focusColor: Palette.primaryColor.withOpacity(0.5),
          highlightColor: Palette.primaryColor.withOpacity(0.5),
          hoverColor: Palette.primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Palette.primaryColor,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            BlocProvider.of<PrivateGroupBloc>(context).add(JoinPrivateGroup(
              id: widget.groupId,
              accessCode: _controller.text,
            ));
          },
          child: Text(
            'Join',
            style: buttonTextStyle.apply(
              fontWeightDelta: 1,
              color: Palette.primaryColor,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrivateGroupBloc, PrivateGroupState>(
      listener: (BuildContext context, PrivateGroupState state) {
        if (state is PrivateGroupJoined) {
          if (widget.onSuccess != null) {
            widget.onSuccess(state.id);
          }
        }
      },
      child: BlocBuilder<PrivateGroupBloc, PrivateGroupState>(
          builder: (BuildContext context, PrivateGroupState state) {
        if (state is PrivateGroupJoined) {}

        if (state is PrivateGroupJoinFailed) {
          _error = state.message;
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            height: 140,
            child: _buildDialogContent(context, state),
          ),
        );
      }),
    );
  }
}
