import 'dart:io';
import '../utility/read_write_file.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var drawerRoutes = [
  '/products',
  '/purchases',
  '/sales',
  '/vouchers',
  '/returns',
  '/quotations',
  '/users',
  '/setting',
  '/reports',
  '/home',
];



var drawerText = [
  "Product",
  "Purchase",
  "Sales",
  "Voucher",
  "Return",
  "Quotation",
  "User",
  "Settings",
  "Report",
  "Help & feedback"
];
var cxt;
var drawer = Drawer(

  child: Column(
  children: <Widget>[
    SizedBox(height: 20,),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 100,
        child: Card(
          child:  Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Image.asset("assets/icons/icon.png"),
              ),
              title: Text('Sunshine', style: TextStyle(fontSize: 30),),
            ),
          ),
        ),
      ),
    ),


    Expanded(
      flex: 2,
      child: ListView.builder(
          padding: EdgeInsets.only(top:0.0),
          itemCount: drawerText.length,
          itemBuilder: (context, position) {
            cxt = context;
            return ListTile(
              title: Text(drawerText[position],
                  style: TextStyle(fontSize: 15.0)),
              onTap: () {
                Navigator.pushNamed(context, drawerRoutes[position]);
              },
            );
          }),
    ),

    Divider(),

    ListTile(
      leading: Icon(Icons.arrow_back),
      title: Text("Logout",
          style: TextStyle(fontSize: 15.0)),
      onTap: () async {
        final path = await ReadWriteFile().getPath();
        print(path);
        final dir = Directory(path);
        dir.deleteSync(recursive: true);
        Navigator.pushNamed(cxt, '/firstScreen');
      },
    )
  ],
),

);
