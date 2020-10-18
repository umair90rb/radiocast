import 'package:flutter/material.dart';

Widget button (size, context, displayText, Function onPressedCallback, buttonColor){
  return SizedBox(
    width: MediaQuery.of(context).size.width * size,
    child: RaisedButton(
      color: buttonColor,
      child: Text(displayText, style: Theme.of(context).textTheme.button,),
      shape: RoundedRectangleBorder(  borderRadius: new BorderRadius.circular(18.0),),
      elevation:3.0,
      onPressed: onPressedCallback,
    ),
  );
}

Widget outlineButton (size, context, displayText, Function onPressedCallback, buttonColor){
  return SizedBox(
    width: MediaQuery.of(context).size.width * size,
    child: OutlineButton(
      highlightedBorderColor: Theme.of(context).buttonColor,
      borderSide: BorderSide(

        color: buttonColor, //Color of the border
        style: BorderStyle.solid, //Style of the border
      ),
      hoverColor: Theme.of(context).buttonColor, //Color of the border
      splashColor: Theme.of(context).buttonColor, //Color of the border
      child: Text(displayText, style: TextStyle(color: Colors.black, fontSize: 14),),
      shape: RoundedRectangleBorder(  borderRadius: new BorderRadius.circular(18.0),),
      onPressed: onPressedCallback,
    ),
  );
}

Widget link(link, onTap){
  return InkWell(
    onTap: onTap,
    child: Text(link, style: TextStyle(fontSize:12, color: Colors.blue),),
  );
}