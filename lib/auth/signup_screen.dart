import 'dart:convert';

import 'package:flutter/material.dart';
import '../utility/read_write_file.dart';
import '../widgets/button.dart';
import '../widgets/input.dart';
import 'package:http/http.dart' as http;
import '../widgets/please_wait.dart';
import '../models/User.dart';
import '../global.dart' as global;

import '../api.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _companyName = TextEditingController();
  final _email = TextEditingController();
  final _mobileNumber = TextEditingController();
  final _password = TextEditingController();
  String mobileNumber;

  List errors;
  var userData;

  Future signUp(name, compname, email, mobile, password, regby, status) async {

    final response = await http.post(
      apiUri + '/auth/registration',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'compname': compname,
        'email': email,
        'mobile': mobile,
        'password': password,
        'regby': regby,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      await ReadWriteFile().writeData(response.body);
      global.user = User.fromJson(jsonDecode(response.body));
      return true;
    } else {
      print(json.decode(response.body));
      return (json.decode(response.body));
    }
  }

  Widget signUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          formInputField(
            "User Name",
            _name,
          ),
          formInputField(
            "Company Name",
            _companyName,
          ),
          formInputField(
            "Email",
            _email,
            pat: pattern,
          ), //          formInputField("Mobile Number", _mobileNumber, pat:'^[0-9]+\$'),
          formInputField("Password", _password, isPassword: true),
          Text(
            'Your data will be in US data Center',
            style: Theme.of(context).textTheme.caption,
          ),
          checkBox(),
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
    );
  }


  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool _termsChecked = true;
  Widget checkBox() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.025,
      ),
      child: CheckboxListTile(
        checkColor: Colors.white,
        activeColor: Theme.of(context).buttonColor,
        value: _termsChecked,
        onChanged: (value) {
          setState(() {
            _termsChecked = value;
          });
        },
        subtitle: !_termsChecked
            ? Text(
                'Required',
                style: TextStyle(color: Colors.red, fontSize: 12.0),
              )
            : null,
        title: new Text(
          'I agree to the',
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    onPressed: () => {Navigator.pop(context)})
              ],
            ),
            Image.asset(
              'assets/icons/login_register.png',
              scale: 3,
            ),
            Text(
              'Sign Up It\'s 60 days free',
              style: Theme.of(context).textTheme.title,
            ),
            signUpForm(),
            SizedBox(
              height: 10,
            ),
            button(0.8, context, "Sign Up", () async {
              if (_formKey.currentState.validate() && _termsChecked ) {
                showDialog(context: context, child: pleaseWait(context));
                setState(() async {
                  signUp(_name.text, _companyName.text, _email.text,
                          mobileNumber, _password.text, '17', 'Active')
                      .then((response) {
                    Navigator.pop(context);
                    if (response == true) {
                      Navigator.pushNamed(
                        context,
                        '/accountActivationMessage',
                        arguments: userData,
                      );
                    } else {
                      errors = response['error'].values.toList();
                      showDialog(
                          context: context,
                          child: showResponse(
                              context, "Something Wrong! Try Again", errors));
                      errors.clear();
                    }
                  });
                });
              }
            }, Theme.of(context).buttonColor),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Already have an account? '),
                link('Sign in now!', () {
                  Navigator.pushNamed(context, '/signIn');
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
