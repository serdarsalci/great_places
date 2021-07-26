import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  Function? onSelectImage;
  ImageInput(this.onSelectImage, {Key? key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage = File('');

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 800);

    setState(() {
      if (imageFile != null) {
        _storedImage = File(imageFile.path);
      }
      // _storedImage = File(imageFile!.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile!.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    widget.onSelectImage!(savedImage);
  }

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
              onPressed: _takePicture,
              icon: Icon(Icons.camera),
              label: Text('Take Picture')),
        ),
      ],
    );
  }
}
