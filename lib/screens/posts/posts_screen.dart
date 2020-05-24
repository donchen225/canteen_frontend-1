import 'package:canteen_frontend/screens/posts/discover_group_screen.dart';
import 'package:canteen_frontend/screens/posts/post_home_screen.dart';
import 'package:canteen_frontend/screens/posts/post_screen_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/single_group_screen.dart';
import 'package:canteen_frontend/screens/posts/single_post_screen.dart';
import 'package:canteen_frontend/screens/search/view_user_profile_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Widget _loadPostScreen(BuildContext context, PostScreenState state) {
    if (state is PostScreenHome) {
      return PostHomeScreen(posts: state.posts, user: state.user);
    } else if (state is PostScreenShowPost) {
      return SinglePostScreen(
        post: state.post,
        user: state.user,
        onTapBack: () =>
            BlocProvider.of<PostScreenBloc>(context).add(PostsPreviousState()),
      );
    } else if (state is PostScreenShowProfile) {
      return ViewUserProfileScreen(
        user: state.user,
        onTapBack: () =>
            BlocProvider.of<PostScreenBloc>(context).add(PostsPreviousState()),
      );
    } else if (state is PostScreenShowGroup) {
      return SingleGroupScreen(
        user: state.user,
        group: state.group,
        onTapBack: () =>
            BlocProvider.of<PostScreenBloc>(context).add(PostsPreviousState()),
      );
    } else if (state is PostScreenDiscoverGroup) {
      final List<Map<String, dynamic>> groups = [
        {
          'name': 'Superconnectors',
          'description': 'This group is meant for superconnectors.',
          'type': 'Private',
          'members': '100',
          'color': Colors.purple,
        },
        {
          'name': 'Cognitive World',
          'description':
              'This group is meant for Cognitive World members and people in AI.',
          'type': 'Private',
          'members': '620',
          'color': Colors.lightBlue,
        },
        {
          'name': 'Modernist',
          'description': 'This group is meant for Modernist members.',
          'type': 'Private',
          'members': '80',
          'color': Colors.lightGreen,
        }
      ];
      return DiscoverGroupScreen(
        groups: groups,
        onTapBack: () =>
            BlocProvider.of<PostScreenBloc>(context).add(PostsPreviousState()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostScreenBloc, PostScreenState>(
      builder: (BuildContext context, PostScreenState state) {
        if (state is PostScreenLoading) {
          return Center(child: CupertinoActivityIndicator());
        }

        return AnimatedSwitcher(
          duration: Duration(milliseconds: animationDuration),
          switchOutCurve: Threshold(0),
          child: _loadPostScreen(context, state),
          transitionBuilder: (Widget child, Animation<double> animation) {
            print('STATE: $state');
            if (state is PostScreenShowProfile ||
                state is PostScreenShowPost ||
                state is PostScreenDiscoverGroup ||
                state is PostScreenShowGroup) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(offsetdXForward, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            }

            if (state is PostScreenHome) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(offsetdXReverse, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            }
          },
        );
      },
    );
  }
}
