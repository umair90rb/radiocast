import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/User.dart';
import '../widgets/button.dart';
import '../widgets/input.dart';
import 'package:http/http.dart' as http;
import '../widgets/please_wait.dart';
import '../utility/read_write_file.dart';
import '../global.dart' as global;

import '../api.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  List errors = [];
  var userData;

  Future signUp(username, password) async {
    final response = await http.get(
      apiUri+'/customer/read_one.php?user=$username&pass=$password',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
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


  // Pattern pattern =
  //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';


  Widget signUpForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          formInputField("Username", _username,),
          formInputField("Password", _password, isPassword: true),


        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/m-4.jpg',),
              fit: BoxFit.fill
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height *0.040,),
              // Row(
              //   children: <Widget>[
              //     IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=>{Navigator.pop(context)})
              //   ],
              // ),
              SizedBox(height: MediaQuery.of(context).size.height *0.1,),
              Text('Sign In to your account', style: TextStyle(color: Colors.white),),

              signUpForm(),

              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Forget Password ',style: TextStyle(color: Colors.white),),
                  link('Reset your Password', (){
                    Navigator.pushNamed(context, '/passwordReset');
                  })
                ],
              ),
              SizedBox(height: 20,),
              button(0.8, context, "Sign In", () async {
                if (_formKey.currentState.validate())  {
                  showDialog(context: context, child: pleaseWait(context));
                  setState(() {
                    signUp(_username.text, _password.text,).then((response){
                      Navigator.pop(context);
                      if(response == true) {
                        Navigator.pushNamed(
                          context,
                          '/podcasts',
                        );
                      } else {
                        print(response['msg'].toString());
                        errors.add("${response['message'].toString()}");
                        showDialog(context: context, child: showResponse(context, "Something Wrong! Try Again", errors));
                        errors.clear();
                      }
                    });
                  });


                }
              }, Theme.of(context).buttonColor),

              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Don\'t have an account? ', style: TextStyle(color: Colors.white),),
                  link('Sign Up now!', (){
                    Navigator.pushNamed(context, '/signUp');
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
