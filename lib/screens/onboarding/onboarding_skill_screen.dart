import 'package:canteen_frontend/components/duration_picker.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/next_button.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_group_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_profile_picture_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingSkillScreen extends StatefulWidget {
  static const routeName = '/skill';

  final Widget child;

  OnboardingSkillScreen({this.child});

  @override
  _OnboardingSkillScreenState createState() => _OnboardingSkillScreenState();
}

class _OnboardingSkillScreenState extends State<OnboardingSkillScreen> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;
  bool _nextEnabled;
  FocusNode _nameFocusNode;
  FocusNode _priceFocusNode;
  FocusNode _descriptionFocusNode;
  final int _nameTextFieldMaxChars = 40;
  final int _priceTextFieldMaxChars = 6;
  final int _descriptionTextFieldMaxChars = 200;
  bool _offeringSelected;
  bool _requestSelected;
  int _selectedDurationIndex;
  final List<int> durationOptions = <int>[
    30,
    60,
    90,
    120,
  ];

  void initState() {
    super.initState();

    _nextEnabled = false;
    _offeringSelected = false;
    _requestSelected = false;
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();

    _nameFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _priceFocusNode = FocusNode();

    _nameController.addListener(_enableButton);
    _descriptionController.addListener(_enableButton);
    _priceController.addListener(_enableButton);
  }

  void _enableButton() {
    setState(() {
      _checkButton();
    });
  }

  void _checkButton() {
    final price = int.tryParse(_priceController.text);
    _nextEnabled = _nameController.text.length > 1 &&
        _descriptionController.text.length > 1 &&
        price != null &&
        price >= 0 &&
        _selectedDurationIndex != null &&
        (_offeringSelected || _requestSelected);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  Widget _buildDurationPicker(BuildContext context) {
    final hintTextStyle = Theme.of(context)
        .textTheme
        .bodyText1
        .apply(color: Color(0x8a000000), fontWeightDelta: 2);

    return GestureDetector(
      onTap: () async {
        if (_selectedDurationIndex == null) {
          setState(() {
            _selectedDurationIndex = 0;
          });
        }

        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return DurationPicker(
              durationOptions: durationOptions,
              initialItem: _selectedDurationIndex ?? 0,
              onChanged: (index) {
                setState(() {
                  _selectedDurationIndex = index;
                });
              },
            );
          },
        );
        _enableButton();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          _selectedDurationIndex != null
              ? '${durationOptions[_selectedDurationIndex]} minutes'
              : 'Duration',
          style: _selectedDurationIndex != null
              ? hintTextStyle.apply(color: Palette.textColor)
              : hintTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.headline4;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    final buttonTextStyle = Theme.of(context).textTheme.button;
    final nextFunction = () {
      BlocProvider.of<OnboardingBloc>(context).add(UpdateSkill(
        name: _nameController.text,
        description: _descriptionController.text,
        price: int.tryParse(_priceController.text),
        duration: durationOptions[_selectedDurationIndex],
        isOffering: _offeringSelected ? true : false,
      ));
      Navigator.pushNamed(context, OnboardingGroupScreen.routeName);
    };

    return OnboardingScreen(
      next: NextButton(
          onTap: _nextEnabled
              ? () {
                  if (_nameController.text.length > 1) {
                    nextFunction();
                  }
                }
              : null),
      onSkip: () =>
          Navigator.pushNamed(context, OnboardingGroupScreen.routeName),
      nodes: [_nameFocusNode, _descriptionFocusNode, _priceFocusNode],
      child: Container(
        width: double.infinity,
        child: ListView(
          padding: EdgeInsets.only(
            top: SizeConfig.instance.safeBlockVertical * 3,
            bottom: SizeConfig.instance.safeBlockVertical * 3,
          ),
          children: [
            Text(
              'List an offering or request',
              style: titleTextStyle.apply(
                color: Palette.titleColor,
                fontWeightDelta: 3,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.instance.safeBlockVertical * 1.5,
              ),
              child: Text(
                "Add a skill, service, or experience that you can offer to others or add a request that you are seeking from others. These will show up publicly on your Canteen profile.",
                style: bodyTextStyle,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: FlatButton(
                    color: _offeringSelected
                        ? Palette.primaryColor
                        : Palette.disabledButtonPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('Offering',
                        style: buttonTextStyle.apply(
                          fontWeightDelta: 1,
                          color: Palette.whiteColor,
                        )),
                    onPressed: () {
                      setState(() {
                        _offeringSelected = true;
                        _requestSelected = false;
                        _checkButton();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.instance.safeBlockHorizontal * 6,
                  ),
                  child: SizedBox(
                    width: 100,
                    child: FlatButton(
                      color: _requestSelected
                          ? Palette.primaryColor
                          : Palette.disabledButtonPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('Request',
                          style: buttonTextStyle.apply(
                            fontWeightDelta: 1,
                            color: Palette.whiteColor,
                          )),
                      onPressed: () {
                        setState(() {
                          _offeringSelected = false;
                          _requestSelected = true;
                          _checkButton();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.instance.safeBlockVertical * 2,
              ),
              child: TextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Palette.primaryColor,
                style: bodyTextStyle.apply(
                  color: Palette.textColor,
                  fontWeightDelta: 2,
                ),
                decoration: InputDecoration(
                  counterText:
                      (_nameTextFieldMaxChars - _nameController.text.length)
                              ?.toString() ??
                          "",
                  hintText: "Name of offering/request",
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  isDense: true,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                maxLength: _nameTextFieldMaxChars,
                maxLines: null,
                minLines: 1,
              ),
            ),
            Container(
              // color: Colors.red,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: SizeConfig.instance.safeBlockHorizontal * 15,
                      ),
                      child: TextField(
                        controller: _priceController,
                        focusNode: _priceFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: Palette.primaryColor,
                        style: bodyTextStyle.apply(
                          color: Palette.textColor,
                          fontWeightDelta: 2,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "Price",
                          prefixText: '\$',
                          contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: _priceTextFieldMaxChars,
                        maxLines: null,
                        minLines: 1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: SizeConfig.instance.safeBlockHorizontal * 15,
                      ),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          border: Border(
                            bottom:
                                BorderSide(width: 1, color: Color(0x5a000000)),
                          ),
                        ),
                        child: _buildDurationPicker(context),
                      ),
                      // child: TextField(
                      //   textCapitalization: TextCapitalization.sentences,
                      //   cursorColor: Palette.primaryColor,
                      //   style: bodyTextStyle.apply(
                      //     color: Palette.primaryColor,
                      //     fontWeightDelta: 2,
                      //   ),
                      //   decoration: InputDecoration(
                      //     counterText: "",
                      //     hintText: "Duration",
                      //     contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      //     isDense: true,
                      //     border: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.black),
                      //     ),
                      //     focusedBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.black),
                      //     ),
                      //   ),
                      //   maxLength: _nameTextFieldMaxChars,
                      //   maxLines: null,
                      //   minLines: 1,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical * 4,
                bottom: SizeConfig.instance.safeBlockVertical * 5,
              ),
              child: TextField(
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Palette.primaryColor,
                style: bodyTextStyle.apply(
                  color: Palette.textColor,
                  fontWeightDelta: 2,
                ),
                decoration: InputDecoration(
                  counterText: (_descriptionTextFieldMaxChars -
                              _descriptionController.text.length)
                          ?.toString() ??
                      "",
                  hintText: "Description of offering/request",
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  isDense: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                maxLength: _nameTextFieldMaxChars,
                maxLines: null,
                minLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
