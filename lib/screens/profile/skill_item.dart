import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SkillItem extends StatelessWidget {
  final double verticalPadding;
  final double horizontalPadding;
  final Skill skill;
  final bool tapEnabled;
  final bool showButton;
  final Function onTap;

  SkillItem(
      {this.verticalPadding = 0,
      this.horizontalPadding = 0,
      this.skill,
      this.tapEnabled = false,
      this.showButton = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;

    return Container(
      padding: EdgeInsets.only(
        top: verticalPadding,
        bottom: verticalPadding,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      decoration: BoxDecoration(
          color: Palette.containerColor,
          border: Border(
              bottom: BorderSide(
            width: 0.5,
            color: Palette.borderSeparatorColor,
          ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Text(
              skill.name,
              style: titleStyle,
            ),
          ),
          Visibility(
            visible: skill.description?.isNotEmpty ?? false,
            child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical,
                bottom: SizeConfig.instance.safeBlockVertical,
              ),
              child: Text(skill.description, style: bodyTextStyle),
            ),
          ),
          Visibility(
            visible: onTap != null,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '\$${(skill.price).toString()}' +
                        (skill.duration != null
                            ? ' / ${skill.duration} minutes'
                            : ''),
                    style: bodyTextStyle.apply(fontWeightDelta: 1),
                  ),
                  Visibility(
                    visible: showButton,
                    child: FlatButton(
                      color: tapEnabled
                          ? Palette.primaryColor
                          : Palette.primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Connect',
                        style: Theme.of(context).textTheme.button.apply(
                              fontWeightDelta: 1,
                              color: Palette.buttonDarkTextColor,
                            ),
                      ),
                      onPressed: onTap != null
                          ? () {
                              if (tapEnabled) {
                                final authenticated =
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .state is Authenticated;

                                if (authenticated) {
                                  onTap();
                                } else {
                                  UnauthenticatedFunctions.showSignUp(context);
                                }
                              }
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
