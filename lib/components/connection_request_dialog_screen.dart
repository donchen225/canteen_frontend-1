import 'package:canteen_frontend/components/searching_dialog_screen.dart';
import 'package:canteen_frontend/components/time_list_selector.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/calendar_date_time_selector.dart';
import 'package:canteen_frontend/screens/posts/action_button.dart';
import 'package:canteen_frontend/screens/posts/text_dialog_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/request/send_request_dialog/bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/send_request_dialog/send_request_dialog.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/searching_screen_dialog.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ConnectionRequestDialogScreen extends StatefulWidget {
  final User user;
  final Function onConfirm;

  ConnectionRequestDialogScreen(
      {@required this.user, @required this.onConfirm});

  @override
  _ConnectionRequestDialogScreenState createState() =>
      _ConnectionRequestDialogScreenState();
}

class _ConnectionRequestDialogScreenState
    extends State<ConnectionRequestDialogScreen> {
  List<DateTime> _timeList;
  DateTime _selectedDay;
  DateTime _selectedTime;
  Skill _selectedPurpose;
  int _selectedPurposeIndex;
  String _selectedPurposeButton;
  User _selectedReferral;
  User _confirmedReferral;
  String _referralError = '';
  bool _referralComplete = false;
  String _message = '';
  TextEditingController _messageController;
  final DateFormat timeFormat = DateFormat.jm();

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List<Widget> _buildTimeSelectorWidget() {
    if (widget.user.availability == null ||
        widget.user.availability.timeRangeRaw.isEmpty) {
      return [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            '${widget.user.displayName} has not set their availability.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: SizeConfig.instance.safeBlockVertical * 2,
            bottom: SizeConfig.instance.safeBlockVertical,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
              'However, you can still send ${widget.user.displayName} a request. Requests sent with messages have higher response rates.'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.instance.safeBlockVertical,
          ),
          child: TextField(
            controller: _messageController,
            textCapitalization: TextCapitalization.sentences,
            autofocus: false,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
              ),
              hintText: 'Add a message',
            ),
          ),
        ),
      ];
    } else if (_timeList == null || _timeList.length == 0) {
      return [
        CalendarDateTimeSelector(
          user: widget.user,
          duration: 30,
          height: 350,
          onDaySelected: (List<DateTime> times, DateTime selectedDay) {
            setState(() {
              if (times.length > 0) {
                _timeList = times;
                _selectedDay = selectedDay;
              }
            });
          },
        )
      ];
    } else if (_timeList != null &&
        _selectedDay != null &&
        _selectedTime == null) {
      return [
        TimeListSelector(
          day: _selectedDay,
          times: _timeList,
          duration: 30,
          onTap: (DateTime time) {
            setState(() {
              _selectedTime = time;
            });
          },
        )
      ];
    }

    return [Container()];
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subTitleStyle = Theme.of(context).textTheme.subtitle1;
    final height =
        SizeConfig.instance.blockSizeVertical * kDialogScreenHeightBlocks;

    return TextDialogScreen(
      title: 'Request Time',
      hasPadding: false,
      sendWidget: ActionButton(
          text: 'Send',
          enabled: _selectedPurpose != null &&
              (_selectedTime != null ||
                  (widget.user.availability == null ||
                      widget.user.availability.timeRangeRaw.isEmpty)) &&
              _referralComplete &&
              (((_selectedPurpose.name == 'Personal' ||
                          _selectedPurpose.name == 'Business') &&
                      _confirmedReferral != null) ||
                  (_selectedPurpose.name != 'Personal' &&
                      _selectedPurpose.name != 'Business')),
          onTap: (BuildContext context) async {
            if (_selectedPurpose != null &&
                (_selectedTime != null ||
                    (widget.user.availability == null ||
                        widget.user.availability.timeRangeRaw.isEmpty)) &&
                _referralComplete &&
                (((_selectedPurpose.name == 'Personal' ||
                            _selectedPurpose.name == 'Business') &&
                        _confirmedReferral != null) ||
                    (_selectedPurpose.name != 'Personal' &&
                        _selectedPurpose.name != 'Business'))) {
              if (widget.onConfirm != null) {
                widget.onConfirm(
                  _message,
                  _selectedTime,
                  _selectedPurpose,
                  _selectedPurposeIndex,
                );
                await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) => BlocProvider.value(
                    value: BlocProvider.of<SendRequestBloc>(context),
                    child: SendRequestDialog(),
                  ),
                );
              }
              Navigator.maybePop(context);
            } else {
              final snackBar = SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
                duration: Duration(seconds: 2),
                content: Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: SizeConfig.instance.blockSizeVertical * 3,
                      color: Colors.red,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.instance.blockSizeHorizontal * 3),
                      child: Text(
                        'Please select a time',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            }
          }),
      child: ListView(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.instance.safeBlockVertical * 2,
        ),
        children: <Widget>[
              Container(
                height: height * 0.1,
                margin: EdgeInsets.only(
                  bottom: SizeConfig.instance.safeBlockVertical * 2,
                ),
                child: Row(
                  children: <Widget>[
                    ProfilePicture(
                      photoUrl: widget.user.photoUrl,
                      editable: false,
                      size: height * 0.1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.instance.safeBlockHorizontal * 3,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: SizeConfig.instance.safeBlockVertical *
                                    0.25,
                              ),
                              child: Text(
                                '${widget.user.displayName ?? ''}',
                                style: titleStyle,
                              ),
                            ),
                            Text(
                              '${widget.user.title ?? ''}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: subTitleStyle.apply(
                                  color: Palette.textSecondaryBaseColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: SizeConfig.instance.safeBlockVertical * 2,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 0.5,
                      color: Palette.borderSeparatorColor,
                    ),
                  ),
                ),
              ),
            ] +
            _buildConnectionWidget(context),
      ),
    );
  }

  List<Widget> _buildConnectionWidget(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;
    final boldedBodyTextStyle = bodyTextStyle.apply(fontWeightDelta: 1);
    final timeTextStyle = bodyTextStyle.apply(color: Colors.green);

    if (_selectedPurpose == null) {
      return <Widget>[
        Container(
          alignment: Alignment.center,
          child: Text(
            'Connection Details',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.instance.safeBlockVertical * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.instance.safeBlockVertical,
                ),
                child: Text(
                  'Purpose',
                  style: titleStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.instance.safeBlockVertical,
                ),
                child: Text(
                  'I want to connect with ${widget.user.displayName} for:',
                  style: bodyTextStyle,
                ),
              ),
              Visibility(
                  visible: widget.user.teachSkill.isNotEmpty,
                  child: _buildTitle(text: 'Offerings', style: titleStyle)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.user.teachSkill
                    .asMap()
                    .map((i, skill) {
                      return MapEntry(i,
                          _buildPurposeButton(context, skill: skill, index: i));
                    })
                    .values
                    .toList(),
              ),
              Visibility(
                  visible: widget.user.learnSkill.isNotEmpty,
                  child: _buildTitle(text: 'Requests', style: titleStyle)),
              Container(
                child: Column(
                  children: widget.user.learnSkill.map((skill) {
                    return _buildPurposeButton(context, skill: skill);
                  }).toList(),
                ),
              ),
              _buildTitle(text: 'Other', style: titleStyle),
              Container(
                child: Column(
                  children: [
                    _buildPurposeButton(
                      context,
                      skill: Skill(
                        name: 'Personal',
                        price: 0,
                        duration: 30,
                        type: SkillType.offer,
                      ),
                    ),
                    _buildPurposeButton(
                      context,
                      skill: Skill(
                        name: 'Business',
                        price: 0,
                        duration: 30,
                        type: SkillType.offer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ];
    } else if (_selectedPurpose != null &&
        (_timeList == null || _selectedDay == null || _selectedTime == null)) {
      return <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.instance.safeBlockVertical * 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_selectedPurpose != null &&
                          (_timeList == null || _selectedDay == null)) {
                        setState(() {
                          _selectedPurpose = null;
                        });
                      } else if (_selectedPurpose != null &&
                          _timeList != null &&
                          _selectedDay != null &&
                          _selectedTime != null) {
                        setState(() {
                          _selectedTime = null;
                        });
                      } else {
                        setState(() {
                          _timeList = null;
                          _selectedDay = null;
                        });
                      }
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Connection Details',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Container(
                    width: 24,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.instance.safeBlockVertical,
              ),
              child: Text(
                'Time',
                style: titleStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.instance.safeBlockVertical,
              ),
              child: Text(
                'Select a time to connect with ${widget.user.displayName}:',
                style: bodyTextStyle,
              ),
            ),
          ] +
          _buildTimeSelectorWidget();
    } else if (_selectedPurpose != null &&
        ((_timeList != null && _selectedDay != null && _selectedTime != null) ||
            (widget.user.availability == null ||
                widget.user.availability.timeRangeRaw.isEmpty)) &&
        !_referralComplete) {
      return <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (_selectedPurpose != null &&
                    (_timeList == null || _selectedDay == null)) {
                  setState(() {
                    _selectedPurpose = null;
                  });
                } else if (_selectedPurpose != null &&
                    _timeList != null &&
                    _selectedDay != null &&
                    _selectedTime != null) {
                  setState(() {
                    _selectedTime = null;
                  });
                } else {
                  setState(() {
                    _timeList = null;
                    _selectedDay = null;
                  });
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 24,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Connection Details',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              width: 24,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.instance.safeBlockVertical * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.instance.safeBlockVertical,
                ),
                child: Text(
                  'Referral',
                  style: titleStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.instance.safeBlockVertical,
                ),
                child: Text(
                  _selectedPurpose.name != 'Personal' &&
                          _selectedPurpose.name != 'Business'
                      ? 'Add a mutual connection to introduce you to ${widget.user.displayName} (optional):'
                      : 'For all connections outside of ${widget.user.displayName}\'s offerings and asks, you must list a mutual connection to introduce you:',
                  style: bodyTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.instance.safeBlockVertical * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final selectedUser = await showModalBottomSheet<User>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return BlocProvider<SearchBloc>(
                              create: (context) => SearchBloc(),
                              child: SearchingDialogScreen(
                                title: 'Select Referral',
                                sendWidget: Container(
                                  width: 50,
                                ),
                                child: SearchingScreenDialog(),
                              ),
                            );
                          },
                        );

                        final self = CachedSharedPreferences.getString(
                            PreferenceConstants.userId);

                        setState(() {
                          if (selectedUser.id == widget.user.id) {
                            _referralError =
                                'Referral must be different than who you are connecting with.';
                          } else if (selectedUser.id == self) {
                            _referralError = 'Referral cannot be yourself.';
                          } else {
                            _selectedReferral = selectedUser;
                            _referralError = '';
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        // height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Palette.borderSeparatorColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(
                          right: 16,
                          left: 16,
                          top: 10,
                          bottom: 10,
                        ),
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.instance.safeBlockVertical),
                        child: _selectedReferral != null
                            ? Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          ProfilePicture(
                                            photoUrl:
                                                _selectedReferral.photoUrl,
                                            size: 40,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _selectedReferral
                                                        .displayName,
                                                    style: titleStyle,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Visibility(
                                                    visible: _selectedReferral
                                                                .title !=
                                                            null &&
                                                        _selectedReferral
                                                            .title.isNotEmpty,
                                                    child: Text(
                                                      _selectedReferral.title ??
                                                          '',
                                                      style: bodyTextStyle.apply(
                                                          color: Palette
                                                              .textSecondaryBaseColor),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedReferral = null;
                                          _referralError = '';
                                        });
                                      },
                                      child: Container(
                                        child: Icon(Icons.close),
                                        height: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                'Select Referral',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                      ),
                    ),
                    Visibility(
                      visible:
                          _referralError != null && _referralError.isNotEmpty,
                      child: Container(
                        child: Text(
                          _referralError ?? '',
                          style: bodyTextStyle.apply(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.instance.safeBlockHorizontal,
                            ),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              color: _selectedReferral != null &&
                                      _referralError.isEmpty
                                  ? Palette.primaryColor
                                  : Palette.primaryColor.withOpacity(0.4),
                              child: Text(
                                'Confirm',
                                style: Theme.of(context).textTheme.button.apply(
                                      fontWeightDelta: 1,
                                      color: Palette.buttonDarkTextColor,
                                    ),
                              ),
                              onPressed: () {
                                if (_selectedReferral != null &&
                                    _referralError.isEmpty) {
                                  setState(() {
                                    _confirmedReferral = _selectedReferral;
                                    _referralComplete = true;
                                  });
                                }
                              },
                            ),
                          ),
                          Visibility(
                            visible: _selectedPurpose.name != 'Personal' &&
                                _selectedPurpose.name != 'Business',
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.instance.safeBlockHorizontal,
                              ),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                    width: 1,
                                    color: Palette.primaryColor,
                                  ),
                                ),
                                child: Text(
                                  'Skip',
                                  style:
                                      Theme.of(context).textTheme.button.apply(
                                            fontWeightDelta: 1,
                                            color: Palette.primaryColor,
                                          ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _referralComplete = true;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    } else if (_selectedPurpose != null &&
        ((_timeList != null && _selectedDay != null && _selectedTime != null) ||
            (widget.user.availability == null ||
                widget.user.availability.timeRangeRaw.isEmpty)) &&
        _referralComplete) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _referralComplete = false;
                });
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 24,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Connection Details',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              width: 24,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.instance.safeBlockVertical * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.instance.safeBlockVertical,
                ),
                child: Text(
                  'Confirmation',
                  style: titleStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.instance.safeBlockVertical,
                ),
                child: _selectedPurpose.name != 'Personal' &&
                        _selectedPurpose.name != 'Business'
                    ? RichText(
                        text: TextSpan(
                          style: bodyTextStyle,
                          children: [
                            TextSpan(
                              text: 'Your request will be sent directly to ',
                            ),
                            TextSpan(
                              text: '${widget.user.displayName}',
                              style: boldedBodyTextStyle,
                            ),
                            TextSpan(
                                text:
                                    '. Please add a message with any additional information.'),
                          ],
                        ),
                      )
                    : RichText(
                        text: TextSpan(style: bodyTextStyle, children: [
                          TextSpan(
                            text: 'Your request will be sent to ',
                          ),
                          TextSpan(
                            text: '${_confirmedReferral.displayName}',
                            style: boldedBodyTextStyle,
                          ),
                          TextSpan(text: ', who will then refer you to '),
                          TextSpan(
                            text: '${widget.user.displayName}',
                            style: boldedBodyTextStyle,
                          ),
                          TextSpan(text: '. Please add a message to '),
                          TextSpan(
                            text: '${_confirmedReferral.displayName}',
                            style: boldedBodyTextStyle,
                          ),
                          TextSpan(text: ' with any additional information.'),
                        ]),
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.instance.safeBlockVertical * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        bottom: SizeConfig.instance.safeBlockVertical,
                      ),
                      child: Text(
                        'Purpose',
                        style: titleStyle,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const FaIcon(
                          FontAwesomeIcons.comments,
                          size: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                SizeConfig.instance.safeBlockHorizontal * 3,
                          ),
                          child: Text(
                            '${_selectedPurpose.name}',
                            style: bodyTextStyle,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        top: SizeConfig.instance.safeBlockVertical * 2,
                        bottom: SizeConfig.instance.safeBlockVertical,
                      ),
                      child: Text(
                        'Time',
                        style: titleStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: SizeConfig.instance.safeBlockVertical,
                      ),
                      child: Row(
                        children: <Widget>[
                          const FaIcon(
                            FontAwesomeIcons.clock,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.instance.safeBlockHorizontal * 3,
                            ),
                            child: Text(
                              '${_selectedPurpose.duration.toString()} min',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const FaIcon(
                          FontAwesomeIcons.calendar,
                          size: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                SizeConfig.instance.safeBlockHorizontal * 3,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DateFormat('yMMMMEEEEd').format(_selectedTime),
                                style: timeTextStyle,
                              ),
                              Text(
                                '${timeFormat.format(_selectedTime)} - ${timeFormat.format(_selectedTime.add(Duration(minutes: _selectedPurpose?.duration ?? 30)))} ${_selectedTime.timeZoneName}',
                                style: timeTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        top: SizeConfig.instance.safeBlockVertical * 2,
                        bottom: SizeConfig.instance.safeBlockVertical,
                      ),
                      child: Text(
                        'Price',
                        style: titleStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: SizeConfig.instance.safeBlockVertical,
                      ),
                      child: Row(
                        children: <Widget>[
                          const FaIcon(
                            FontAwesomeIcons.dollarSign,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.instance.safeBlockHorizontal * 3,
                            ),
                            child: Text(
                              '${_selectedPurpose.price.toString()}.00',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        top: SizeConfig.instance.safeBlockVertical * 2,
                        bottom: SizeConfig.instance.safeBlockVertical,
                      ),
                      child: Text(
                        'Referral',
                        style: titleStyle,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Palette.borderSeparatorColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                        right: 16,
                        left: 16,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: _confirmedReferral != null
                                  ? Row(
                                      children: [
                                        ProfilePicture(
                                          photoUrl:
                                              _confirmedReferral?.photoUrl ??
                                                  '',
                                          size: 40,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _confirmedReferral
                                                          ?.displayName ??
                                                      '',
                                                  style: titleStyle,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Visibility(
                                                  visible:
                                                      _confirmedReferral !=
                                                              null &&
                                                          _confirmedReferral
                                                                  .title !=
                                                              null &&
                                                          _confirmedReferral
                                                              .title.isNotEmpty,
                                                  child: Text(
                                                    _confirmedReferral?.title ??
                                                        '',
                                                    style: bodyTextStyle.apply(
                                                        color: Palette
                                                            .textSecondaryBaseColor),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      child: Text('No referral selected')),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        top: SizeConfig.instance.safeBlockVertical * 2,
                        bottom: SizeConfig.instance.safeBlockVertical,
                      ),
                      child: Text(
                        'Message',
                        style: titleStyle,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: 60,
                      ),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Palette.borderSeparatorColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textCapitalization: TextCapitalization.sentences,
                        autofocus: false,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 10,
                            bottom: 10,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: 'Add a message',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    }
  }

  Widget _buildTitle({String text, TextStyle style}) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.instance.safeBlockVertical * 2,
        bottom: SizeConfig.instance.safeBlockVertical,
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }

  Widget _buildPurposeButton(BuildContext context, {Skill skill, int index}) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _selectedPurposeButton = skill.name;
        });
      },
      child: Container(
        width: double.infinity,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              width: _selectedPurposeButton == skill.name ? 2.5 : 1,
              color: Palette.primaryColor,
            ),
          ),
          child: Text(
            skill.name,
            style: Theme.of(context).textTheme.button.apply(
                  fontWeightDelta: 1,
                  color: Palette.primaryColor,
                ),
          ),
          onPressed: () {
            setState(() {
              _selectedPurpose = skill;

              if (_selectedPurpose.name == 'Personal') {
                _selectedPurposeIndex = 100;
              } else if (_selectedPurpose.name == 'Business') {
                _selectedPurposeIndex = 200;
              } else {
                _selectedPurposeIndex = index;
              }

              _selectedPurposeButton = null;
            });
          },
        ),
      ),
    );
  }
}
