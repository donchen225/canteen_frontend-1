import 'dart:io';

import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUploadSheet extends StatelessWidget {
  final Function onUpload;

  ProfileUploadSheet({this.onUpload});

  Future<File> _pickImage(ImageSource source) async {
    return await ImagePicker.pickImage(
        source: source,
        maxHeight: maxPhotoHeight,
        maxWidth: maxPhotoWidth,
        imageQuality: photoQuality);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        'Upload Profile Picture',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      actions: <Widget>[
        // TODO: implement this
        // CupertinoActionSheetAction(
        //   onPressed: () {},
        //   child: Text(
        //     'Remove Current Photo',
        //     style: TextStyle(color: Colors.red),
        //   ),
        // ),
        CupertinoActionSheetAction(
          onPressed: () =>
              _pickImage(ImageSource.camera).then((imageFile) async {
            if (onUpload != null) {
              onUpload(imageFile);
            }
          }),
          child: Text(
            'Take Photo',
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () =>
              _pickImage(ImageSource.gallery).then((imageFile) async {
            if (onUpload != null) {
              onUpload(imageFile);
            }
          }),
          child: Text(
            'Choose from Library',
          ),
        )
      ],
    );
  }
}
