import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/vectors/noInternet.jpg'),
            SizedBox(height: 20,),
            Text('Oops!', style: Theme.of(context).textTheme.headline,),
            SizedBox(height: 10,),
            Text("It seems there is something wrong with you internet connection. Please connect to internet and start app again.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.body1,),
          ],
        ),
      ),
    );
  }
}

