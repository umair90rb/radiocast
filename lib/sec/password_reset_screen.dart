import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/button.dart';
import '../widgets/input.dart';
import 'package:http/http.dart' as http;
import '../widgets/please_wait.dart';

import '../api.dart';


class SecPasswordResetScreen extends StatefulWidget {
  @override
  _SecPasswordResetScreenState createState() => _SecPasswordResetScreenState();
}

class _SecPasswordResetScreenState extends State<SecPasswordResetScreen> {

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  List errors = [];

  Future passwordReset(email) async {
    final response = await http.post(
      apiUri+'/auth/password_reset',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);

    } else {
      print(json.decode(response.body));
      return (json.decode(response.body));
    }
  }



  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';


  Widget signUpForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          formInputField("Email", _email, pat:pattern,),


        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height *0.040,),
            Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=>{Navigator.pop(context)})
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height *0.1,),
            Image.asset('assets/icons/login_register.png', scale: 3,),
            Text('Password Reset Request', style: Theme.of(context).textTheme.title,),
            SizedBox(height: 10,),
            Padding(padding: EdgeInsets.symmetric(vertical:20, horizontal: 40) ,child: Text('Enter your email address we will mail you the password reset instructions.', textAlign: TextAlign.justify, style: Theme.of(context).textTheme.body1,)),
            signUpForm(),
            SizedBox(height: 10,),
            button(0.8, context, "Send Reset Instructions", () async {
              if (_formKey.currentState.validate()) {
                  showDialog(context: context, child: pleaseWait(context));
                  var response = await passwordReset(_email.text,);
                  Navigator.pop(context);
                  if(response['status'] == 200) {
                    showDialog(context: context, child: showResponse(context, "One step ahead!", [response['message']]));
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('One more step.'),
                        content: Text(response['message']+' We send you password reset instructions.'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/');
                            },
                          ),
                        ],
                      ),
                    );

                } else {
                  print(response['error'].toString());
                  errors.add("${response['error'].toString()}");
                  showDialog(context: context, child: showResponse(context, "Something Wrong! Try Again", errors));
                  errors.clear();
                }

              }
            }, Theme.of(context).buttonColor),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Unless you change your password '),
                link('Login Now!', (){
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
