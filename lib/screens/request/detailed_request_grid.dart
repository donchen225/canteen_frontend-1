import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class DetailedRequestGrid extends StatelessWidget {
  final List<DetailedRequest> items;
  final key;

  final Function onTap;

  DetailedRequestGrid({@required this.items, this.key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('PROFILE GRID BUILD');
    return Container(
      color: Palette.backgroundColor,
      child: GridView.builder(
        padding: EdgeInsets.only(top: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final user = items[index].sender;

          return GestureDetector(
            onTap: onTap != null ? () => onTap(items[index]) : () {},
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                    width: 150, // TODO: change this to be dynamic
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: (user.photoUrl != null &&
                                user.photoUrl.isNotEmpty)
                            ? CachedNetworkImageProvider(user.photoUrl)
                            : AssetImage('assets/blank-profile-picture.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: Text(user.displayName ?? ''),
                  ),
                  ListView.builder(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: user.teachSkill.length,
                      itemBuilder: (context, index) {
                        final skill = user.teachSkill[index];
                        return Text((skill.name ?? '') +
                            ' - ' +
                            ('\$${skill.price.toString()}' ?? ''));
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
