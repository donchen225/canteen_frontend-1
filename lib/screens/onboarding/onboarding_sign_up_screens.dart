import 'package:canteen_frontend/components/duration_picker.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class OnboardingSignUpScreens extends StatefulWidget {
  final User user;

  OnboardingSignUpScreens(this.user);

  _OnboardingSignUpScreensState createState() =>
      _OnboardingSignUpScreensState();
}

class _OnboardingSignUpScreensState extends State<OnboardingSignUpScreens> {
  TextEditingController _nameController;
  TextEditingController _teachSkillNameController;
  TextEditingController _teachSkillPriceController;
  TextEditingController _teachSkillDescriptionController;
  TextEditingController _learnSkillNameController;
  TextEditingController _learnSkillPriceController;
  TextEditingController _learnSkillDescriptionController;
  int _currentIndex;
  List<PageViewModel> pages;
  List<bool> _pageValidated;
  bool _teachSkillSelected;
  bool _learnSkillSelected;
  String _skillType;

  List<int> _durationOptions;
  int _selectedDurationIndex;

  void initState() {
    super.initState();

    _currentIndex = 0;
    _selectedDurationIndex = 0;
    _durationOptions = <int>[30, 60, 90, 120];
    _pageValidated = [false, false, false, true, false, false];
    _teachSkillSelected = false;
    _learnSkillSelected = false;
    _nameController = TextEditingController();
    _teachSkillNameController = TextEditingController();
    _learnSkillNameController = TextEditingController();
    _teachSkillPriceController = TextEditingController();
    _learnSkillPriceController = TextEditingController();
    _teachSkillDescriptionController = TextEditingController();
    _learnSkillDescriptionController = TextEditingController();

    pages = [
      _buildNamePage(_nameController),
      _buildSkillPage(),
      _buildSkillNamePage(_teachSkillSelected
          ? _teachSkillNameController
          : _learnSkillNameController),
      _buildSkillDurationPage(),
      _buildSkillPricePage(_teachSkillSelected
          ? _teachSkillPriceController
          : _learnSkillPriceController),
      _buildSkillDescriptionPage(_teachSkillSelected
          ? _teachSkillDescriptionController
          : _learnSkillDescriptionController),
    ];

    _nameController.addListener(_validateNamePage);
    _teachSkillNameController.addListener(_validateSkillNamePage);
    _learnSkillNameController.addListener(_validateSkillNamePage);
    _teachSkillPriceController.addListener(_validateSkillPricePage);
    _learnSkillPriceController.addListener(_validateSkillPricePage);
    _teachSkillDescriptionController.addListener(_validateSkillDescriptionPage);
    _learnSkillDescriptionController.addListener(_validateSkillDescriptionPage);

    _nameController.text = widget.user.displayName ?? '';
    _teachSkillNameController.text =
        widget.user.teachSkill.length > 0 ? widget.user.teachSkill[0].name : '';
    _learnSkillNameController.text =
        widget.user.learnSkill.length > 0 ? widget.user.learnSkill[0].name : '';

    _teachSkillPriceController.text = widget.user.teachSkill.length > 0
        ? widget.user.teachSkill[0].price.toString()
        : '0';
    _learnSkillPriceController.text = widget.user.learnSkill.length > 0
        ? widget.user.learnSkill[0].price.toString()
        : '0';

    _teachSkillDescriptionController.text = widget.user.teachSkill.length > 0
        ? widget.user.teachSkill[0].description
        : '';
    _learnSkillDescriptionController.text = widget.user.learnSkill.length > 0
        ? widget.user.learnSkill[0].description
        : '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teachSkillNameController.dispose();
    _learnSkillNameController.dispose();
    _teachSkillPriceController.dispose();
    _learnSkillPriceController.dispose();
    _teachSkillDescriptionController.dispose();
    _learnSkillDescriptionController.dispose();
    super.dispose();
  }

  void _validateNamePage() {
    setState(() {
      // pages[0].nextValidated = _nameController.text != '' ? true : false;
      _pageValidated[0] = _nameController.text != '' ? true : false;

      pages[0] = _buildNamePage(_nameController);
    });
  }

  void _validateSkillNamePage() {
    setState(() {
      _pageValidated[2] = _teachSkillSelected
          ? (_teachSkillNameController.text != '' ? true : false)
          : (_learnSkillNameController.text != '' ? true : false);

      pages[2] = _buildSkillNamePage(_teachSkillSelected
          ? _teachSkillNameController
          : _learnSkillNameController);
    });
  }

  void _validateSkillPricePage() {
    setState(() {
      _pageValidated[4] = _teachSkillSelected
          ? (_teachSkillPriceController.text != '' ? true : false)
          : (_learnSkillPriceController.text != '' ? true : false);

      pages[4] = _buildSkillPricePage(_teachSkillSelected
          ? _teachSkillPriceController
          : _learnSkillPriceController);
    });
  }

  void _validateSkillDescriptionPage() {
    setState(() {
      _pageValidated[5] = _teachSkillSelected
          ? (_teachSkillDescriptionController.text != '' ? true : false)
          : (_learnSkillDescriptionController.text != '' ? true : false);
    });
  }

  PageViewModel _buildProfilePicturePage() {}

  Widget _buildSkillSection(
    TextEditingController nameController,
    TextEditingController priceController,
    TextEditingController descriptionController,
    bool teachSelected,
  ) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Palette.orangeColor,
            style: TextStyle(
                fontSize: 25,
                color: Palette.orangeColor,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.all(0),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            maxLines: 1,
            minLines: 1,
          ),
          Row(
            children: <Widget>[
              Container(
                width: SizeConfig.instance.blockSizeHorizontal * 30,
                child: TextField(
                  controller: priceController,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Palette.orangeColor,
                  style: TextStyle(
                      fontSize: 25,
                      color: Palette.orangeColor,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none),
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.all(0),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
            ],
          ),
          TextField(
            controller: descriptionController,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Palette.orangeColor,
            style: TextStyle(
                fontSize: 25,
                color: Palette.orangeColor,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.all(0),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            maxLines: 1,
            minLines: 1,
          ),
        ],
      ),
    );
  }

  PageViewModel _buildSkillPageOld(
    TextEditingController nameController,
    TextEditingController priceController,
    TextEditingController descriptionController,
    bool pageValidation,
  ) {
    return PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: pageValidation,
      bubbleBackgroundColor: Palette.orangeColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "What are your skills?",
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.instance.blockSizeVertical,
              bottom: SizeConfig.instance.blockSizeVertical,
              left: SizeConfig.instance.blockSizeHorizontal * 12,
              right: SizeConfig.instance.blockSizeHorizontal * 12,
            ),
          ),
          _buildSkillSection(nameController, priceController,
              descriptionController, _teachSkillSelected),
        ],
      ),
      bodyTextStyle: TextStyle(
          fontFamily: 'MyFont',
          color: Colors.black,
          fontWeight: FontWeight.w700),
    );
  }

  PageViewModel _buildSkillPage() {
    return PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: _pageValidated[1],
      bubbleBackgroundColor: Palette.orangeColor,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Text("Do you want to learn or teach?"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.instance.blockSizeVertical * 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('Learn'),
                  color: _learnSkillSelected
                      ? Palette.orangeColor
                      : Palette.buttonInvalidBackgroundColor,
                  onPressed: () {
                    setState(() {
                      _learnSkillSelected = true;
                      _teachSkillSelected = false;
                      _pageValidated[1] = true;
                      _skillType = 'learn';

                      pages[1] = _buildSkillPage();
                    });
                  },
                ),
                RaisedButton(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('Teach'),
                  color: (_teachSkillSelected)
                      ? Palette.orangeColor
                      : Palette.buttonInvalidBackgroundColor,
                  onPressed: () {
                    setState(() {
                      _teachSkillSelected = true;
                      _learnSkillSelected = false;
                      _pageValidated[1] = true;
                      _skillType = 'teach';
                      pages[1] = _buildSkillPage();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bodyTextStyle: TextStyle(
          fontFamily: 'MyFont',
          color: Colors.black,
          fontWeight: FontWeight.w700),
    );
  }

  PageViewModel _buildNamePage(TextEditingController controller) {
    return PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: _pageValidated[0],
      bubbleBackgroundColor: Palette.orangeColor,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "What's your name?",
              textAlign: TextAlign.start,
            ),
          ),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Palette.orangeColor,
            style: TextStyle(
                fontSize: 25,
                color: Palette.orangeColor,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.all(0),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            maxLines: 1,
            minLines: 1,
          ),
        ],
      ),
      bodyTextStyle: TextStyle(
          fontFamily: 'MyFont',
          color: Colors.black,
          fontWeight: FontWeight.w700),
    );
  }

  PageViewModel _buildSkillNamePage(TextEditingController controller) {
    return PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: _pageValidated[2],
      bubbleBackgroundColor: Palette.orangeColor,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "What is the name of the skill you want to $_skillType?",
              textAlign: TextAlign.start,
            ),
          ),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Palette.orangeColor,
            style: TextStyle(
                fontSize: 25,
                color: Palette.orangeColor,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.all(0),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            maxLines: 1,
            minLines: 1,
          ),
        ],
      ),
      bodyTextStyle: TextStyle(
          fontFamily: 'MyFont',
          color: Colors.black,
          fontWeight: FontWeight.w700),
    );
  }

  Widget _buildDurationPicker() {
    return DurationPicker(
      magnification: 1.3,
      backgroundColor: Colors.transparent,
      durationOptions: <int>[30, 60, 90, 120],
      onChanged: (index) {
        _selectedDurationIndex = index;
      },
    );
  }

  PageViewModel _buildSkillDurationPage() {
    return PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: _pageValidated[3],
      bubbleBackgroundColor: Palette.orangeColor,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "How long do you want to $_skillType for?",
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            height: 200,
            child: _buildDurationPicker(),
          ),
        ],
      ),
      bodyTextStyle: TextStyle(
        fontFamily: 'MyFont',
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  PageViewModel _buildSkillPricePage(TextEditingController controller) {
    return PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: _pageValidated[4],
      bubbleBackgroundColor: Palette.orangeColor,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "How much do you want to $_skillType for?",
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            width: SizeConfig.instance.blockSizeHorizontal * 33,
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              cursorColor: Palette.orangeColor,
              style: TextStyle(
                  fontSize: 25,
                  color: Palette.orangeColor,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                icon: Text("\$"),
                counterText: "",
                contentPadding: EdgeInsets.all(0),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              maxLines: 1,
              minLines: 1,
              maxLength: 4,
            ),
          ),
        ],
      ),
      bodyTextStyle: TextStyle(
          fontFamily: 'MyFont',
          color: Colors.black,
          fontWeight: FontWeight.w700),
    );
  }

  PageViewModel _buildSkillDescriptionPage(TextEditingController controller) {
    return PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: _pageValidated[5],
      bubbleBackgroundColor: Palette.orangeColor,
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "What is the description of the skill you want to $_skillType?",
              textAlign: TextAlign.start,
            ),
          ),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Palette.orangeColor,
            style: TextStyle(
                fontSize: 14,
                color: Palette.orangeColor,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.all(0),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            maxLines: 6,
            minLines: 1,
          ),
        ],
      ),
      bodyTextStyle: TextStyle(
        fontFamily: 'MyFont',
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  bool validateSkillPage() {
    if (_teachSkillSelected) {
      if (_teachSkillNameController.text != '' &&
          _teachSkillPriceController.text != '' &&
          _teachSkillDescriptionController.text != '') {
        return true;
      } else {
        return false;
      }
    } else {
      if (_learnSkillNameController.text != '' &&
          _learnSkillPriceController.text != '' &&
          _learnSkillDescriptionController.text != '') {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      onTapNextButton: () {
        setState(() {
          _currentIndex += 1;

          if (_currentIndex == 2) {
            pages[2] = _buildSkillNamePage(_teachSkillSelected
                ? _teachSkillNameController
                : _learnSkillNameController);
            pages[3] = _buildSkillDurationPage();
            pages[4] = _buildSkillPricePage(_teachSkillSelected
                ? _teachSkillPriceController
                : _learnSkillPriceController);
            pages[5] = _buildSkillDescriptionPage(_teachSkillSelected
                ? _teachSkillDescriptionController
                : _learnSkillDescriptionController);
          }
        });
      },
      onTapDoneButton: validateSkillPage()
          ? () {
              final skill = _teachSkillSelected
                  ? Skill(
                      _teachSkillNameController.text,
                      _teachSkillDescriptionController.text,
                      int.parse(_teachSkillPriceController.text),
                      _durationOptions[_selectedDurationIndex],
                      SkillType.teach,
                    )
                  : Skill(
                      _learnSkillNameController.text,
                      _learnSkillDescriptionController.text,
                      int.parse(_learnSkillPriceController.text),
                      _durationOptions[_selectedDurationIndex],
                      SkillType.learn,
                    );

              // Update user information and onboarding information here
              BlocProvider.of<OnboardingBloc>(context).add(CompleteOnboarding(
                name: _nameController.text,
                skill: skill,
              ));
            }
          : () {},
      showNextButton: true,
      showSkipButton: false,
      doneText: Container(
          margin: EdgeInsets.all(SizeConfig.instance.blockSizeHorizontal * 3),
          height: SizeConfig.instance.blockSizeHorizontal * 12,
          width: SizeConfig.instance.blockSizeHorizontal * 12,
          decoration: BoxDecoration(
            color: validateSkillPage()
                ? Palette.orangeColor
                : Palette.buttonInvalidBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: SizeConfig.instance.blockSizeHorizontal * 5,
            color: validateSkillPage()
                ? Palette.whiteColor
                : Palette.buttonInvalidTextColor,
          )),
      nextText: Container(
          margin: EdgeInsets.all(SizeConfig.instance.blockSizeHorizontal * 3),
          height: SizeConfig.instance.blockSizeHorizontal * 12,
          width: SizeConfig.instance.blockSizeHorizontal * 12,
          decoration: BoxDecoration(
            color: (_pageValidated[_currentIndex])
                ? Palette.orangeColor
                : Palette.buttonInvalidBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: SizeConfig.instance.blockSizeHorizontal * 5,
            color: (_pageValidated[_currentIndex])
                ? Palette.whiteColor
                : Palette.buttonInvalidTextColor,
          )),
      pageButtonTextStyles: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontFamily: "Regular",
      ),
    );
  }
}
