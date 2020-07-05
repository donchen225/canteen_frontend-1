import 'package:canteen_frontend/screens/request/send_request_dialog/bloc/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendRequestDialog extends StatefulWidget {
  SendRequestDialog();

  @override
  _SendRequestDialogState createState() => _SendRequestDialogState();
}

class _SendRequestDialogState extends State<SendRequestDialog> {
  String _message = '';

  Widget _buildDialogContent(BuildContext context, SendRequestState state) {
    if (state is RequestSent) {
      return Column(
        children: [
          Expanded(
            flex: 3,
            child: Icon(
              Icons.check_circle_outline,
              size: dialogIconSize,
              color: Colors.green[600],
            ),
          ),
          Expanded(
            child: Text(_message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
          ),
        ],
      );
    } else if (state is RequestSending) {
      return Column(
        children: [
          Expanded(
            flex: 3,
            child: Icon(
              Icons.send,
              size: dialogIconSize,
              color: Palette.primaryColor.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Text('Sending request...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
          ),
        ],
      );
    } else if (state is RequestFailed) {
      return Column(
        children: [
          Expanded(
            flex: 3,
            child: Icon(
              Icons.error_outline,
              size: dialogIconSize,
              color: Palette.primaryColor.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Text(_message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
          ),
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendRequestBloc, SendRequestState>(
        builder: (BuildContext context, SendRequestState state) {
      if (state is RequestSent) {
        _message = state.message;
      }

      if (state is RequestFailed) {
        _message = state.message;
      }

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Container(
          height: 140,
          width: 200,
          child: _buildDialogContent(context, state),
        ),
      );
    });
  }
}
