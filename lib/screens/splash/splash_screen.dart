import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animationController.forward();
    animationController.addListener(() {
      setState(() {
        if (animationController.status == AnimationStatus.completed) {
          animationController.repeat();
        }
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
        child: Container(
          height: SizeConfig.instance.blockSizeHorizontal * 30,
          width: SizeConfig.instance.blockSizeHorizontal * 30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loading-icon.png'),
            ),
          ),
        ),
      ),
    );
  }
}
