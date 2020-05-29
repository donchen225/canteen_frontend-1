// import 'package:canteen_frontend/screens/posts/group_card.dart';
// import 'package:canteen_frontend/screens/posts/post_screen_bloc/bloc.dart';
// import 'package:canteen_frontend/utils/palette.dart';
// import 'package:canteen_frontend/utils/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class DiscoverGroupScreen extends StatelessWidget {
//   final Function onTapBack;
//   final List<Map<String, dynamic>> groups;

//   DiscoverGroupScreen({this.onTapBack, @required this.groups});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Discover'),
//         backgroundColor: Palette.appBarBackgroundColor,
//         elevation: 0,
//         leading: BackButton(
//           onPressed: () {
//             if (onTapBack != null) {
//               onTapBack();
//             }
//           },
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 top: SizeConfig.instance.scaffoldBodyHeight * 0.02,
//                 left: SizeConfig.instance.safeBlockHorizontal * 6,
//                 right: SizeConfig.instance.safeBlockHorizontal * 6,
//               ),
//               child: Text('Popular Groups',
//                   style: Theme.of(context).textTheme.headline5.apply(
//                         fontFamily: '.SF UI Text',
//                         fontWeightDelta: 2,
//                       )),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               height: SizeConfig.instance.scaffoldBodyHeight * 0.33,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 3,
//                 itemBuilder: (context, index) {
//                   final group = groups[index];

//                   return Padding(
//                     padding: EdgeInsets.only(
//                       left: SizeConfig.instance.safeBlockHorizontal * 6,
//                       bottom: SizeConfig.instance.scaffoldBodyHeight * 0.02,
//                       top: SizeConfig.instance.scaffoldBodyHeight * 0.02,
//                     ),
//                     child: GroupCard(
//                       group: group,
//                       width: 180,
//                       color: group['color'],
//                       onTap: () => BlocProvider.of<PostScreenBloc>(context)
//                           .add(PostsInspectGroup(group)),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
