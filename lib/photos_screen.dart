import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  List<String> _imageUrls = [];
  bool _uploadInProgress = false;
  bool _getInProgress = false;

  @override
  void initState() {
    super.initState();
    _getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photos"),
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getPhotos();
        },
        child: Visibility(
          visible: _uploadInProgress == false && _getInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: GridView.builder(
              itemCount: _imageUrls.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0
              ),
              itemBuilder: (context, index) {
                return GridTile(
                    child: Card(
                      margin: const EdgeInsets.all(5.0),
                      child: Image.network(_imageUrls[index]),
                    )
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
        onPressed: () async {
          await _uploadPhoto();
          _getPhotos();
        },
        child: const Icon(Icons.photo),
      ),
    );
  }

  Future<void> _getPhotos() async {
    _getInProgress = true;
    setState(() {});
    Reference storageReference = FirebaseStorage.instance.refFromURL('gs://ostad-7c47a.appspot.com/images/');

    ListResult result = await storageReference.listAll();

    List<String>urls = [];
    for(Reference ref in result.items) {
      String url = await ref.getDownloadURL();
      urls.add(url);
      log(url);
    }
    _imageUrls = urls;
    _getInProgress = false;
    setState(() {});

  }

  Future<void> _uploadPhoto() async {
    _uploadInProgress = true;
    setState(() {});
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null) {
      File file = File(pickedFile.path);
      Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = storageReference.putFile(file);

      String downloadURL = await (await uploadTask).ref.getDownloadURL();

      log('File uploaded successfully: $downloadURL');
      _uploadInProgress = false;
      setState(() {});
    }
  }
}
