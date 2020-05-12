// import 'package:canteen_frontend/components/confirmation_dialog.dart';
// import 'package:canteen_frontend/models/request/request.dart';
// import 'package:canteen_frontend/components/profile_list.dart';
// import 'package:canteen_frontend/models/skill/skill.dart';
// import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
// import 'package:canteen_frontend/screens/recommended/recommended_empty_screen.dart';
// import 'package:canteen_frontend/screens/recommended/recommended_unavailable.dart';
// import 'package:canteen_frontend/screens/recommended/skip_user_button.dart';
// import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
// import 'package:canteen_frontend/utils/constants.dart';
// import 'package:canteen_frontend/utils/palette.dart';
// import 'package:canteen_frontend/utils/size_config.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class RecommendedScreen extends StatefulWidget {
//   RecommendedScreen();

//   _RecommendedScreenState createState() => _RecommendedScreenState();
// }

// class _RecommendedScreenState extends State<RecommendedScreen> {
//   void _onTapSkillFunction(
//       BuildContext context, RecommendedLoaded state, Skill skill) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => ConfirmationDialog(
//         user: state.user,
//         skill: skill,
//         onConfirm: (comment) {
//           BlocProvider.of<RequestBloc>(context).add(
//             AddRequest(
//               Request.create(
//                 skill: skill,
//                 comment: comment,
//                 receiverId: state.user.id,
//               ),
//             ),
//           );
//           BlocProvider.of<RecommendedBloc>(context).add(AcceptRecommended());
//         },
//       ),
//     );
//   }

//   Widget _getRecommendedWidget(RecommendedState state) {
//     if (state is RecommendedLoaded) {
//       final user = state.user;
//       return Scaffold(
//         key: UniqueKey(),
//         floatingActionButton: SkipUserFloatingActionButton(
//           onTap: () {
//             BlocProvider.of<RecommendedBloc>(context).add(NextRecommended());
//           },
//         ),
//         body: Container(
//           color: Palette.backgroundColor,
//           child: CustomScrollView(slivers: <Widget>[
//             SliverAppBar(
//               pinned: true,
//               brightness: Brightness.light,
//               backgroundColor: Palette.backgroundColor,
//               title: Text(
//                 user.displayName ?? '',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 25,
//                 ),
//               ),
//             ),
//             SliverPadding(
//               padding: EdgeInsets.only(
//                   bottom: SizeConfig.instance.blockSizeVertical * 13,
//                   left: SizeConfig.instance.blockSizeHorizontal * 3,
//                   right: SizeConfig.instance.blockSizeHorizontal * 3),
//               sliver: ProfileList(
//                 user,
//                 height: SizeConfig.instance.blockSizeHorizontal * 33,
//                 onTapLearnFunction: (skill) =>
//                     _onTapSkillFunction(context, state, skill),
//                 onTapTeachFunction: (skill) =>
//                     _onTapSkillFunction(context, state, skill),
//               ),
//             ),
//           ]),
//         ),
//       );
//     } else if (state is RecommendedEmpty) {
//       return RecommendedEmptyScreen();
//     } else if (state is RecommendedUnavailable) {
//       return RecommendedUnavailableScreen();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RecommendedBloc, RecommendedState>(
//       builder: (context, state) {
//         print('IN RECOMMENDED SCREEN');
//         if (state is RecommendedLoading) {
//           print('IN RECOMMENDED LOADING STATE');
//           return Center(child: CupertinoActivityIndicator());
//         } else {
//           return AnimatedSwitcher(
//             duration: Duration(milliseconds: animationDuration),
//             switchOutCurve: Threshold(0),
//             transitionBuilder: (Widget child, Animation<double> animation) {
//               return SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(offsetdX, 0),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: child,
//               );
//             },
//             child: _getRecommendedWidget(state),
//           );
//         }
//       },
//     );
//   }
// }
