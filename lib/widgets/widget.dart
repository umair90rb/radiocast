//=========================CACHE IMAGE ===================//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CacheImage extends StatelessWidget {
  final String image;
  final double size;
  CacheImage(this.image, this.size);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      width: size,
      height: size,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

//====================FOR HOME PAGE ===============================//
class MyFormField extends StatelessWidget {
  final double size;
  final Widget formfield;
  MyFormField(this.size, this.formfield);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: size,
        child: formfield,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.6),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

signForm(String name, Icon icon) {
  return InputDecoration(
    //  isDense: true,
    hintText: name,
    prefixIcon: icon,
    contentPadding: EdgeInsets.all(15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      //  borderSide: BorderSide(),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(18.0),
    ),
  );
}

//////////////////  DIALOG BOX  /////////////////////////
void validation(String title, String text, context) {
  String tit = title;
  String txt = text;
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              backgroundColor: Colors.white, //Color(0xff183132),
              contentPadding: EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 5.0),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              title: Text(
                tit,
                style: TextStyle(color: Color(0xff183132)),
              ),
              content: Text(
                txt,
                style: TextStyle(color: Color(0xff183132)),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Color(0xff183132), fontSize: 16),
                    )),
              ],
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}

//////////////////////// BUTTON ///////////////////////////////

class AccountButton extends StatelessWidget {
  final Function onPress;
  final String name;
  final Color clr;
  AccountButton(this.onPress, this.name, this.clr);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: clr,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      onPressed: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 15.0),
        child: Text(
          name,
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

////////////////
myToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}