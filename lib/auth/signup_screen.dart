import 'dart:convert';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:podcast/models/User.dart';
import '../utility/read_write_file.dart';
import '../widgets/button.dart';
import '../widgets/input.dart';
import 'package:http/http.dart' as http;
import '../widgets/please_wait.dart';
import '../global.dart' as global;

import '../api.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _mobileNumber = TextEditingController();

  List errors;
  var userData;

  Future signUp(username, email, password) async {

    final response = await http.get(
      apiUri + '/customer/create.php/username=$username&email=$email&password=$password',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );

    if (response.statusCode == 200) {
      var data = json.encode("{'username':'$username', 'email':'$email', 'password':'$password'}");
      await ReadWriteFile().writeData(data);
      // global.user = User.fromJson(jsonDecode(data));
      return true;
    } else {
      print(json.decode(response.body));
      return (json.decode(response.body));
    }
  }

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


  final uploader = FlutterUploader();
  var p = 0 ;
  String r;


  Future uploadPodcast(username, email, phone, photo, password, context) async {

    print(basename(photo.path.toString()));
    print(photo.parent.toString());
    print(photo.path);



    final taskId = await uploader.enqueue(
        url: "https://4kradiopodcast.com/api/customer/create.php", //required: url to upload to
        files: [FileItem(filename: basename(photo.path), savedDir: photo.parent.path, fieldname:"fileToUpload")], // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)

        data: {"username": username, "email": email, "phone": phone,  "password": password,}, // any data you want to send in upload request
        showNotification: true, // send local notification (android only) for upload status
        tag: "upload 1"); // unique tag for upload task

        final subscription = uploader.result.listen((result) async {
          Navigator.pop(context);
          print(result.response);
          await ReadWriteFile().writeData(result.response);
          global.user = User.fromJson(jsonDecode(result.response));
          Navigator.pushNamed(
            context,
            '/podcasts',
            arguments: userData,);
          }, onError: (ex, stacktrace) {
              showDialog(
                  context: context,
                  child: showResponse(
                      context, "Something Wrong! Try Again", ['Something Wrong']));
        });
        


  }





  Widget signUpForm() {
    return Container(
      margin: EdgeInsets.only(bottom: 100.0),
padding: EdgeInsets.all(8.0),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.25),
borderRadius: BorderRadius.circular(4.0),
),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            formInputField(
              "User Name",
              _name,
            ),

            formInputField(
              "Email",
              _email,
              pat: pattern,
            ), 
            formInputField("Mobile Number", _mobileNumber, pat:'^[0-9]+\$'),
            formInputField("Password", _password, isPassword: true),
            Text("Profile Image", style: TextStyle(color:Colors.white),),
            image(),
            
            // Text(
            //   'Your data will be in US data Center',
            //   style: Theme.of(context).textTheme.caption,
            // ),
            // checkBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                link("Terms and Service", () {}),
                Text(' and '),
                link("Privacy Policy", () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // bool _termsChecked = true;
  // Widget checkBox() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: MediaQuery.of(context).size.width * 0.025,
  //     ),
  //     child: CheckboxListTile(
  //       checkColor: Colors.white,
  //       activeColor: Theme.of(context).buttonColor,
  //       value: _termsChecked,
  //       onChanged: (value) {
  //         setState(() {
  //           _termsChecked = value;
  //         });
  //       },
  //       subtitle: !_termsChecked
  //           ? Text(
  //               'Required',
  //               style: TextStyle(color: Colors.red, fontSize: 12.0),
  //             )
  //           : null,
  //       title: new Text(
  //         'I agree to the',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       controlAffinity: ListTileControlAffinity.leading,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/m-4.png',),
                fit: BoxFit.fill
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.090,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () => {Navigator.pop(context)})
                ],
              ),

              Text(
                'Sign Up ',
                style: TextStyle(color: Colors.white),
              ),
              signUpForm(),
              SizedBox(
                height: 10,
              ),
              button(0.8, context, "Sign Up", () async {
                if (_formKey.currentState.validate() && photo != null) {
                  showDialog(context: context, child: pleaseWait(context));

                    // signUp(_name.text, _email.text, _password.text,)
                    var response = await uploadPodcast(_name.text, _email.text, _mobileNumber.text, photo, _password.text, context);
                        // .then((response) async {
                      
                    // });

                }
              }, Theme.of(context).buttonColor),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Already have an account? ', style: TextStyle(color: Colors.white),),
                  link('Sign in now!', () {
                    Navigator.pushNamed(context, '/signIn');
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
