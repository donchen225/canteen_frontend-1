import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class OnboardingSignUpScreens extends StatefulWidget {
  OnboardingSignUpScreens();

  _OnboardingSignUpScreensState createState() =>
      _OnboardingSignUpScreensState();
}

class _OnboardingSignUpScreensState extends State<OnboardingSignUpScreens> {
  TextEditingController _nameController;
  TextEditingController _teachSkillNameController;
  TextEditingController _teachSkillDescriptionController;
  TextEditingController _learnSkillNameController;
  TextEditingController _learnSkillDescriptionController;
  bool _namePageValidated;
  bool _pageValidated;
  PageViewModel _currentPage;

  void initState() {
    super.initState();

    _namePageValidated = false;
    _nameController = TextEditingController();
    _teachSkillNameController = TextEditingController();
    _learnSkillNameController = TextEditingController();
    _teachSkillDescriptionController = TextEditingController();
    _learnSkillDescriptionController = TextEditingController();
    _nameController.addListener(_validateNamePage);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teachSkillNameController.dispose();
    _learnSkillNameController.dispose();
    _teachSkillDescriptionController.dispose();
    _learnSkillDescriptionController.dispose();
    super.dispose();
  }

  void _validateNamePage() {
    setState(() {
      _namePageValidated = _nameController.text != '' ? true : false;
    });
  }

  PageViewModel _buildProfilePicturePage() {}

  PageViewModel _buildSkillPage() {
    _currentPage = PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('Teach'),
                ),
                RaisedButton(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('Learn'),
                ),
              ],
            ),
          ),
          TextField(
            controller: _teachSkillNameController,
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
          TextField(
            controller: _teachSkillNameController,
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
    return _currentPage;
  }

  PageViewModel _buildNamePage(TextEditingController controller) {
    _currentPage = PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: _namePageValidated,
      bubbleBackgroundColor: Palette.orangeColor,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text("What's your name?"),
              ),
            ],
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
    return _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [
        _buildNamePage(_nameController),
        _buildSkillPage(),
      ],
      onTapNextButton: () {
        print('PRESSED NEXT');
      },
      onTapDoneButton: () {
        BlocProvider.of<HomeBloc>(context).add(
          PageTapped(index: 0),
        );
      },
      showNextButton: true,
      showSkipButton: false,
      doneText: Container(
          margin: EdgeInsets.all(SizeConfig.instance.blockSizeHorizontal * 3),
          height: SizeConfig.instance.blockSizeHorizontal * 12,
          width: SizeConfig.instance.blockSizeHorizontal * 12,
          decoration: BoxDecoration(
            color: Palette.orangeColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: SizeConfig.instance.blockSizeHorizontal * 5,
            color: Palette.whiteColor,
          )),
      nextText: Container(
          margin: EdgeInsets.all(SizeConfig.instance.blockSizeHorizontal * 3),
          height: SizeConfig.instance.blockSizeHorizontal * 12,
          width: SizeConfig.instance.blockSizeHorizontal * 12,
          decoration: BoxDecoration(
            color: (_currentPage != null && _currentPage.nextValidated)
                ? Palette.orangeColor
                : Palette.buttonInvalidBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: SizeConfig.instance.blockSizeHorizontal * 5,
            color: (_currentPage != null && _currentPage.nextValidated)
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
