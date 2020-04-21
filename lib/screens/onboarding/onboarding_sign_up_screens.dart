import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
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

  void initState() {
    super.initState();

    _currentIndex = 0;
    _pageValidated = [false, false, false, false, false, false];
    _teachSkillSelected = false;
    _learnSkillSelected = false;
    _nameController = TextEditingController();
    _teachSkillNameController = TextEditingController();
    _learnSkillNameController = TextEditingController();
    _teachSkillPriceController = TextEditingController();
    _learnSkillPriceController = TextEditingController();
    _teachSkillDescriptionController = TextEditingController();
    _learnSkillDescriptionController = TextEditingController();
    _nameController.addListener(_validateNamePage);
    _teachSkillNameController.addListener(_validateSkillNamePage);
    _learnSkillNameController.addListener(_validateSkillNamePage);
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
    });
  }

  void _validateSkillNamePage() {
    setState(() {
      _pageValidated[2] = _teachSkillSelected
          ? (_teachSkillNameController.text != '' ? true : false)
          : (_learnSkillNameController.text != '' ? true : false);
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
          Row(
            children: <Widget>[
              Container(
                child: Text("Do you want to learn or teach?"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
                  });
                },
              ),
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
                  });
                },
              ),
            ],
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
            child: Text(
              "What's your name?",
              textAlign: TextAlign.start,
            ),
          ),
          TextField(
            controller: controller,
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
            child: Text(
              "What is the name of the skill?",
              textAlign: TextAlign.start,
            ),
          ),
          TextField(
            controller: controller,
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

  PageViewModel _buildSkillDescriptionPage(TextEditingController controller) {
    return PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: _pageValidated[5],
      bubbleBackgroundColor: Palette.orangeColor,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Text(
              "What is the description of the skill?",
              textAlign: TextAlign.start,
            ),
          ),
          TextField(
            controller: controller,
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
    pages = [
      _buildNamePage(_nameController),
      _buildSkillPage(),
      _buildSkillNamePage(_teachSkillSelected
          ? _teachSkillNameController
          : _learnSkillNameController),
      // _buildSkillDurationPage(_pageValidated[3]),
      // _buildSkillPricePage(_pageValidated[4]),
      _buildSkillDescriptionPage(_teachSkillSelected
          ? _teachSkillDescriptionController
          : _learnSkillDescriptionController),
    ];

    print(_pageValidated[_currentIndex]);

    return IntroViewsFlutter(
      pages,
      onTapNextButton: () {
        print('PRESSED NEXT');

        setState(() {
          _currentIndex += 1;
        });
      },
      onTapDoneButton: validateSkillPage()
          ? () {
              BlocProvider.of<HomeBloc>(context).add(
                PageTapped(index: 0),
              );
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
