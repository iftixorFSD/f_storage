import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _picker = ImagePicker();
  XFile? _file;
  String _imageUrl = '';
  void _getImage() async{
    final file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = file;
    });
    void _uploadToStorage() async {
      final path = 'files/${_file?.name ?? "No File"}';
      final file = File(_file?.path ?? "");

      final ref = FirebaseStorage.instance.ref().child(path);
      final response = ref.putFile(file);
      final snapshot = await response.whenComplete((){
        print('Yuklandi');

      });
      _imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Storage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _file == null ? Icon(Icons.image) : Image.file(
              File (_file?.path ?? ""),
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height:30,),
            Image.network(_imageUrl, width: double.infinity,height: 150, fit: BoxFit.cover,),
            const SizedBox(height: 30,),
            Image.network(_imageUrl),
            const SizedBox(height:30,),
            ElevatedButton.icon(onPressed: (){
              _getImage();
            }, icon: Icon(Icons.download),label: Text("Get Image")),
            const SizedBox(height: 10,),
            ElevatedButton.icon(onPressed: (){

            }, icon: Icon(Icons.upload),label: Text("Upload to firebase")),
          ],
        ),
      ),
    );
  }
}
