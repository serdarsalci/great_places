import 'package:flutter/material.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage = File('');

  @override
  Widget build(BuildContext context) {
    print('parent');
    print(_storedImage.parent);
    String directory =
        _storedImage.parent.toString().split(' ').last.toString();
    print(directory);
    return Row(
      children: [
        Container(
          width: 150,
          height: 120,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: directory != "'.'"
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.camera),
              label: Text('Take Picture')),
        ),
      ],
    );
  }
}
