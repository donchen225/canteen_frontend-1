// import 'package:canteen_frontend/models/user/user.dart';
// import 'package:canteen_frontend/screens/posts/post_list_screen.dart';
// import 'package:canteen_frontend/screens/search/search_bar.dart';
// import 'package:canteen_frontend/utils/constants.dart';
// import 'package:canteen_frontend/utils/palette.dart';
// import 'package:canteen_frontend/utils/size_config.dart';
// import 'package:flutter/material.dart';

// class SingleGroupScreen extends StatefulWidget {
//   final User user;
//   final Map<String, dynamic> group;
//   final Function onTapBack;

//   SingleGroupScreen({this.user, this.group, this.onTapBack});

//   @override
//   _SingleGroupScreenState createState() => _SingleGroupScreenState();
// }

// class _SingleGroupScreenState extends State<SingleGroupScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final color = widget.group['color'];
//     final height = SizeConfig.instance.safeBlockVertical * 9;

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: color,
//         brightness: Brightness.dark,
//         elevation: 0,
//         leading: BackButton(
//           color: Colors.white,
//           onPressed: () {
//             if (widget.onTapBack != null) {
//               widget.onTapBack();
//             }
//           },
//         ),
//         title: SearchBar(
//           height: kToolbarHeight - 15,
//           color: Colors.grey[700].withOpacity(0.5),
//           child: Text(
//             widget.group['name'],
//             style: Theme.of(context).textTheme.subtitle1.apply(
//                   color: Colors.white,
//                 ),
//           ),
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverToBoxAdapter(
//             child: Container(
//               color: Palette.containerColor,
//               height:
//                   kToolbarHeight + SizeConfig.instance.safeBlockVertical * 16,
//               child: Stack(
//                 children: <Widget>[
//                   Container(
//                     color: color,
//                     height: kToolbarHeight +
//                         SizeConfig.instance.safeBlockVertical * 13,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                       top: kToolbarHeight +
//                           SizeConfig.instance.safeBlockVertical * 7,
//                       left: SizeConfig.instance.safeBlockHorizontal * 4,
//                       right: SizeConfig.instance.safeBlockHorizontal * 4,
//                     ),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: <Widget>[
//                         Container(
//                           height: height,
//                           width: height,
//                           decoration: BoxDecoration(
//                             color: color,
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               width: 3,
//                               color: Colors.grey[300],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: height * 0.7,
//                           width: height * 0.7,
//                           decoration: BoxDecoration(
//                             color: color,
//                             shape: BoxShape.circle,
//                           ),
//                           // constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
//                           child: Image.asset(
//                             'assets/loading-icon.png',
//                             color: Colors.white,
//                             // fit: BoxFit.fitHeight,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               color: Palette.containerColor,
//               padding: EdgeInsets.only(
//                 left: SizeConfig.instance.safeBlockHorizontal * 4,
//                 right: SizeConfig.instance.safeBlockHorizontal * 4,
//                 bottom: SizeConfig.instance.safeBlockVertical * 2,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     widget.group['name'],
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   Text(
//                     widget.group['type'],
//                     style: Theme.of(context).textTheme.subtitle2.apply(
//                           color: Palette.textSecondaryBaseColor,
//                         ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: SizeConfig.instance.safeBlockVertical,
//                     ),
//                     child: Text(
//                       widget.group['description'],
//                       style: Theme.of(context).textTheme.subtitle1,
//                     ),
//                   ),
//                   Text(
//                     '${widget.group['members']} members',
//                     style: Theme.of(context)
//                         .textTheme
//                         .subtitle2
//                         .apply(color: Palette.textSecondaryBaseColor),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//                 padding: EdgeInsets.only(
//                   top: SizeConfig.instance.safeBlockVertical * 4,
//                 ),
//                 height: 1000,
//                 child: PostListScreen(user: widget.user)),
//           ),
//         ],
//       ),
//     );
//   }
// }
