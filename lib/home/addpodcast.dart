import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:podcast/widgets/button.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:permission_handler/permission_handler.dart';
import '../global.dart' as global;
import '../widgets/input.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String statusText = "";
  bool isComplete = false;
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
      ;
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
          title: const Text('Record Podcast'),
         actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text(p.toString())
            ],)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      height: 48.0,
                      decoration: BoxDecoration(color: Colors.red.shade300),
                      child: Center(
                        child: Text(
                          'start',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () async {
                      startRecord();
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      height: 48.0,
                      decoration: BoxDecoration(color: Colors.blue.shade300),
                      child: Center(
                        child: Text(
                          RecordMp3.instance.status == RecordStatus.PAUSE
                              ? 'resume'
                              : 'pause',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      pauseRecord();
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      height: 48.0,
                      decoration: BoxDecoration(color: Colors.green.shade300),
                      child: Center(
                        child: Text(
                          'stop',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      stopRecord();
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                statusText,
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                play();
              },
              child: Container(
                margin: EdgeInsets.only(top: 30),
                alignment: AlignmentDirectional.center,
                // width: 100,
                // height: 300,
                child: isComplete && recordFilePath != null
                    ? Column(
                  children: [
                    formInputField("Podcast Title", _title, validation: true),
                    Text("Podcast Thumbnail"),
                    image(),
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



                      Fluttertoast.showToast(
                          msg: "Uploading...",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,

                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );



                      await uploadPodcast(_title.text, photo);

                      _title.text = '';











                    }, Colors.blueAccent)

                  ],
                )
                // Row(
                //         children: [
                //           IconButton(icon: Icon(Icons.play_arrow), onPressed: () => play()),
                //           IconButton(icon: Icon(Icons.cloud_upload), onPressed: () => uploadPodcast()),
                //         ],
                //       )

                    : Container(),
              ),
            ),
          ]),
        ),

    );
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

  void stopRecord() async {
    bool s = RecordMp3.instance.stop();

    if (s) {
      statusText = "Record complete, wait a while to export";
      isComplete = true;

      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }

  String recordFilePath;

  void play() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(recordFilePath, isLocal: true);
    }
  }


  String filename;

  Future<String> getFilePath() async {
    filename = "${global.user.username}${DateTime.now().millisecond}";
    print(filename);
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/${filename}.mp3";
  }



  final uploader = FlutterUploader();
  var p = 0 ;
  String r;


  Future uploadPodcast(title, photo) async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    print(basename(photo.path.toString()));
    print(photo.parent.toString());
    print(photo.path);

    print(filename);

    final taskId = await uploader.enqueue(
        url: "https://4kradiopodcast.com/api/file/upload.php", //required: url to upload to
        files: [FileItem(filename: "${filename}.mp3", savedDir: sdPath, fieldname:"file"), FileItem(filename: basename(photo.path), savedDir: photo.parent.path, fieldname:"thumbnail")], // required: list of files that you want to upload
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