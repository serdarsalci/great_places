import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:image_cropper/image_cropper.dart';

class ImageInput extends StatefulWidget {
  Function? onSelectImage;
  ImageInput(this.onSelectImage, {Key? key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage = File('');
  late AppState state;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 800);

    setState(() {
      if (imageFile != null) {
        _storedImage = File(imageFile.path);
        state = AppState.picked;
      }
      // _storedImage = File(imageFile!.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile!.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    // widget.onSelectImage!(savedImage);
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.camera);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
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
          child: TextButton(
            onPressed: () {
              if (state == AppState.free)
                _takePicture();
              else if (state == AppState.picked)
                _cropImage();
              else if (state == AppState.cropped) _clearImage();
            },

            //  _takePicture,
            child: _buildButtonIcon(),
          ),
        ),
      ],
    );
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: _storedImage.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ),
        maxHeight: 600,
        maxWidth: 600);
    if (croppedFile != null) {
      _storedImage = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
    widget.onSelectImage!(_storedImage);
  }

  void _clearImage() {
    _storedImage = File('');
    setState(() {
      state = AppState.free;
    });
  }
}
