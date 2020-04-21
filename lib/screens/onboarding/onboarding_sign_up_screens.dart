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

  void initState() {
    super.initState();

    _currentIndex = 0;
    _pageValidated = [false, false];
    _teachSkillSelected = true;
    _nameController = TextEditingController();
    _teachSkillNameController = TextEditingController();
    _learnSkillNameController = TextEditingController();
    _teachSkillPriceController = TextEditingController();
    _learnSkillPriceController = TextEditingController();
    _teachSkillDescriptionController = TextEditingController();
    _learnSkillDescriptionController = TextEditingController();
    _nameController.addListener(_validateNamePage);
    _teachSkillNameController.addListener(_validateSkillNamePage);

    _nameController.text = widget.user.displayName ?? '';
    _teachSkillNameController.text =
        widget.user.teachSkill.length > 0 ? widget.user.teachSkill[0].name : '';
    _learnSkillNameController.text =
        widget.user.learnSkill.length > 0 ? widget.user.learnSkill[0].name : '';
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
      _pageValidated[1] = _teachSkillNameController.text != '' ? true : false;
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
          Row(),
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

  PageViewModel _buildSkillPage(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('Teach'),
                  color: _teachSkillSelected
                      ? Palette.orangeColor
                      : Palette.buttonInvalidBackgroundColor,
                  onPressed: () {
                    setState(() {
                      _teachSkillSelected = true;
                    });
                  },
                ),
                RaisedButton(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('Learn'),
                  color: _teachSkillSelected
                      ? Palette.buttonInvalidBackgroundColor
                      : Palette.orangeColor,
                  onPressed: () {
                    setState(() {
                      _teachSkillSelected = false;
                    });
                  },
                ),
              ],
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

  PageViewModel _buildNamePage(
      TextEditingController controller, bool pageValidation) {
    return PageViewModel(
      pageColor: Palette.backgroundColor,
      // iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: null,
      nextValidated: pageValidation,
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
      _buildNamePage(_nameController, _pageValidated[0]),
      _buildSkillPage(
          _teachSkillSelected
              ? _teachSkillNameController
              : _learnSkillNameController,
          _teachSkillSelected
              ? _teachSkillPriceController
              : _learnSkillPriceController,
          _teachSkillSelected
              ? _teachSkillDescriptionController
              : _learnSkillDescriptionController,
          _pageValidated[1]),
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
