import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:canteen_frontend/utils/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final bool showTime;

  const MessageItem(this.message, {this.showTime = false});

  @override
  Widget build(BuildContext context) {
    final isSelf = message.isSelf;
    if (message is TextMessage) {
      if (showTime) {
        return Column(
          children: <Widget>[
            buildTimeStamp(context, message),
            buildMessageContainer(isSelf, message, context),
          ],
        );
      }

      return buildMessageContainer(isSelf, message, context);
    } else if (message is SystemMessage) {
      return Column(
        children: <Widget>[
          buildTimeStamp(context, message),
          buildSystemMessage(isSelf, message, context),
        ],
      );
    }

    return Container();
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
              borderRadius: BorderRadius.circular(20.0)),
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            right: isSelf ? 10.0 : 0,
            left: isSelf ? 0 : 10.0,
          ),
        )
      ],
      mainAxisAlignment:
          isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
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
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.only(top: 4, bottom: 4),
        )
      ],
    );
  }

  Widget buildMessageContent(
      bool isSelf, Message message, BuildContext context) {
    if (message is TextMessage) {
      return SelectableLinkify(
        text: message.text,
        onOpen: UrlUtils.onOpen,
        options: LinkifyOptions(humanize: false),
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
                child: SelectableText(
                  title,
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
                      TextSpan(
                          text: '$formattedTime ${dateTime?.timeZoneName}'),
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

  Widget buildTimeStamp(BuildContext context, Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text(
            DateFormat('MMM d,').add_jm().format(message.timestamp),
            style: Theme.of(context).textTheme.caption,
          ),
          margin: EdgeInsets.only(top: 8, bottom: 8),
        )
      ],
    );
  }
}
