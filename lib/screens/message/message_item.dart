import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem(this.message);

  @override
  Widget build(BuildContext context) {
    final isSelf = message.isSelf;
    if (message is TextMessage) {
      return Container(
        child: Column(
          children: <Widget>[
            buildMessageContainer(isSelf, message, context),
            buildTimeStamp(context, isSelf, message)
          ],
        ),
      );
    } else if (message is SystemMessage) {
      return Container(
        child: buildSystemMessage(isSelf, message, context),
      );
    }
  }

  Row buildMessageContainer(
      bool isSelf, Message message, BuildContext context) {
    double lrEdgeInsets = 1.0;
    double tbEdgeInsets = 1.0;
    if (message is TextMessage) {
      lrEdgeInsets = 15.0;
      tbEdgeInsets = 10.0;
    }
    return Row(
      children: <Widget>[
        Container(
          child: buildMessageContent(isSelf, message, context),
          padding: EdgeInsets.fromLTRB(
              lrEdgeInsets, tbEdgeInsets, lrEdgeInsets, tbEdgeInsets),
          constraints: BoxConstraints(maxWidth: 200.0),
          decoration: BoxDecoration(
              color: isSelf
                  ? Palette.selfMessageBackgroundColor
                  : Palette.otherMessageBackgroundColor,
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(
              right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
        )
      ],
      mainAxisAlignment: isSelf
          ? MainAxisAlignment.end
          : MainAxisAlignment.start, // aligns the chatitem to right end
    );
  }

  Widget buildSystemMessage(
      bool isSelf, Message message, BuildContext context) {
    double lrEdgeInsets = 15.0;
    double tbEdgeInsets = 10.0;

    final messageContent = buildMessageContent(isSelf, message, context);

    if (messageContent == null) {
      return null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: messageContent,
          padding: EdgeInsets.fromLTRB(
              lrEdgeInsets, tbEdgeInsets, lrEdgeInsets, tbEdgeInsets),
          constraints: BoxConstraints(
              maxWidth: SizeConfig.instance.safeBlockHorizontal * 70),
          decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(top: 10, bottom: 10),
        )
      ],
    );
  }

  Widget buildMessageContent(
      bool isSelf, Message message, BuildContext context) {
    if (message is TextMessage) {
      return Text(
        message.text,
        style: TextStyle(
          color: isSelf ? Palette.selfMessageColor : Palette.otherMessageColor,
          fontStyle: message.isItalics ? FontStyle.italic : FontStyle.normal,
        ),
      );
    } else if (message is SystemMessage) {
      if (message.event == 'match_start') {
        final title = message.data['title'];
        final time = message.data['time'];
        final skill = message.data['skill'];
        final price = message.data['price'];

        if (title == null || skill == null || price == null) {
          return null;
        }

        final DateFormat timeFormat = DateFormat.jm();
        String formattedTime;
        String formattedDate;
        DateTime dateTime;
        if (time != null) {
          try {
            dateTime = time.toDate();
            formattedTime = timeFormat.format(dateTime);
            formattedDate = DateFormat('yMMMMEEEEd').format(dateTime);
          } catch (error) {
            print('Error formatting system message time: $error');
            return null;
          }
        }

        final bodyTextStyle = Theme.of(context).textTheme.bodyText2;

        return Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 5,
                ),
                child: Text(
                  message.data['title'],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .apply(fontWeightDelta: 1),
                ),
              ),
              Container(
                width: double.infinity,
                child: RichText(
                  text: TextSpan(style: bodyTextStyle, children: [
                    TextSpan(
                      text: 'Offering/Ask: ',
                      style: bodyTextStyle.apply(
                        fontWeightDelta: 1,
                      ),
                    ),
                    TextSpan(text: '$skill'),
                  ]),
                ),
              ),
              Container(
                width: double.infinity,
                child: RichText(
                  text: TextSpan(style: bodyTextStyle, children: [
                    TextSpan(
                      text: 'Price: ',
                      style: bodyTextStyle.apply(
                        fontWeightDelta: 1,
                      ),
                    ),
                    TextSpan(text: '\$$price'),
                  ]),
                ),
              ),
              Visibility(
                visible: formattedDate != null,
                child: Container(
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(style: bodyTextStyle, children: [
                      TextSpan(
                        text: 'Date: ',
                        style: bodyTextStyle.apply(
                          fontWeightDelta: 1,
                        ),
                      ),
                      TextSpan(text: '$formattedDate'),
                    ]),
                  ),
                ),
              ),
              Visibility(
                visible: formattedTime != null,
                child: Container(
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(style: bodyTextStyle, children: [
                      TextSpan(
                        text: 'Time: ',
                        style: bodyTextStyle.apply(
                          fontWeightDelta: 1,
                        ),
                      ),
                      TextSpan(text: '$formattedTime ${dateTime.timeZoneName}'),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    return null;
  }

  Row buildTimeStamp(BuildContext context, bool isSelf, Message message) {
    return Row(
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              DateFormat('dd MMM kk:mm').format(message.timestamp),
              style: Theme.of(context).textTheme.caption,
            ),
            margin: EdgeInsets.only(
                left: isSelf ? 5.0 : 0.0,
                right: isSelf ? 0.0 : 5.0,
                top: 5.0,
                bottom: 5.0),
          )
        ]);
  }
}
