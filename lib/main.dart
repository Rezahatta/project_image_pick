import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePickerApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImagePickerApp extends StatefulWidget {
  const ImagePickerApp({super.key});

  @override
  State<ImagePickerApp> createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  File? _Image;

  Future getImage(ImageSource source) async {
    try {
       final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    // final imageTemporary = File(image.path);
    final imagePermanent = await saveFilePermanently(image.path);

    setState(() {
      this._Image = imagePermanent;
    });  
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick An Image'),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          _Image != null
              ? Image.file(
                  _Image!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Image.network('https://picsum.photos/200/300'),
          SizedBox(
            height: 40,
          ),
          CustomButton(
            title: 'Pick An Gallery',
            icon: Icons.image_outlined,
            onClick: () => getImage(ImageSource.gallery) ,
          ),
          CustomButton(
            title: 'Pick An Camera',
            icon: Icons.camera,
            onClick: () => getImage(ImageSource.camera),
          ),
        ],
      )),
    );
  }
}

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}
){
  return Container(
    width: 280,
    child: ElevatedButton(
        onPressed: onClick,
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 20,
            ),
            Text(title)
          ],
        )),
  );
}