import 'package:flutter/material.dart';

Widget pleaseWait(context){
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: ListTile(
          leading: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).buttonColor),
          ),
          title: Text('Please wait!'),
          subtitle: Text('Your request is processing.'),
          dense: true,
        ),
      ),
    ),
  );
}

Widget showResponse(context, message, List subMessage){
    return Center(
      child: AlertDialog(
        title: Text('Something Wrong!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              for(var v in subMessage) Text(v, style: Theme.of(context).textTheme.body2,),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      )
    );

}