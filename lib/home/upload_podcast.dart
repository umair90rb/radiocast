import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcast/widgets/button.dart';
import 'package:podcast/widgets/input.dart';
import '../global.dart' as global;
import 'package:file_picker/file_picker.dart';

class UplaodPodcast extends StatefulWidget {
  @override
  _UplaodPodcastState createState() => _UplaodPodcastState();
}

class _UplaodPodcastState extends State<UplaodPodcast> {

  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, );
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, );
        }
      } catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }
  String podcast;

  TextEditingController _title = TextEditingController();

  File photo;


  final picker = ImagePicker();
  Future chooseImage() async {
    final pickedFile = await picker.getImage(source:ImageSource.gallery);
    File cropped = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(
            ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarTitle: "Crop Image",
          statusBarColor: Colors.black,
          backgroundColor: Colors.white,
        )
    );

    this.setState((){
      photo = cropped;

    });

  }

  Widget image(){
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                child: photo == null
                    ? Icon(Icons.do_not_disturb_alt)
                    : Image.file(photo),
              ),
              OutlineButton(
                onPressed: chooseImage,
                child: Text('Choose Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your Podcast'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            formInputField("Podcast Title", _title, validation: true),
            Text("Podcast Thumbnail"),
            image(),
            Text("Podcast file"),
            new Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: new RaisedButton(
                onPressed: () async {
                    podcast = await FilePicker.getFilePath(
                    type: FileType.audio, );
                    print(basename(podcast));
                },
                child: new Text("Open file picker"),
              ),
            ),
            button(20, context, "Upload Podcast", () async {

              if(photo == null) return Fluttertoast.showToast(
                  msg: "Please select thumbnail.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,

                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

              if(_title.text.isEmpty) return Fluttertoast.showToast(
                  msg: "Please enter podcast title.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,

                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

              if(podcast == null) return Fluttertoast.showToast(
                  msg: "Please select podcast.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,

                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );



              Fluttertoast.showToast(
                  msg: "Uploading...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,

                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );



              await uploadPodcast(_title.text, photo, podcast);

              _title.text = '';


            }, Colors.blueAccent)
          ],
        ),
      ),
    );
  }



  var p = 0 ;
  String r;

  final uploader = FlutterUploader();
  Future uploadPodcast(title, photo, podcast) async {

    print(basename(photo.path.toString()));
    print(photo.parent.toString());
    print(photo.path);

    File temp = new File(podcast);


    final taskId = await uploader.enqueue(
        url: "https://4kradiopodcast.com/api/file/upload.php", //required: url to upload to
        files: [FileItem(filename: basename(podcast), savedDir: temp.parent.path, fieldname:"file"), FileItem(filename: basename(photo.path), savedDir: photo.parent.path, fieldname:"thumbnail")], // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)

        data: {"uid": "${global.user.id}", "username": "${global.user.username}", "title": title, "thumbnail": basename(photo.toString()), "upload": "yes",}, // any data you want to send in upload request
        showNotification: true, // send local notification (android only) for upload status
        tag: "upload 1"); // unique tag for upload task
    uploader.progress.listen((progress) {
      setState(() {
        p = progress.progress;
      });
    });

  }

}
