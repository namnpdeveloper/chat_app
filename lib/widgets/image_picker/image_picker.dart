import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.onPickImage);

  final Function(File pickedImage) onPickImage;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  final _picker = ImagePicker();

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      if((pickedFile?.path ?? '').isNotEmpty) {
        final pickedImageFile = File(pickedFile?.path ?? '');
        _pickedImage = pickedImageFile;
        widget.onPickImage(pickedImageFile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
          _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        ElevatedButton(onPressed: _pickImage, child: const Icon(Icons.image)),
      ],
    );
  }
}
