import 'package:flutter/material.dart';

class AccountActivationMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height*0.05,),
          Padding(
            padding: const EdgeInsets.only(right:15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(icon:Icon(Icons.close), color: Colors.white, onPressed: (){Navigator.pushNamed(context, '/signIn');},),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.25,),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Icon(Icons.email, color: Colors.white, size: 45,),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text("You can Sign In know and also you to activate your account. To continue, click the activation link in the email we've sent you.", textAlign: TextAlign.justify, style: TextStyle(fontSize: 24, color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
