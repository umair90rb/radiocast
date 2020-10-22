import 'dart:io';
import '../utility/read_write_file.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var drawerRoutes = [
  '/podcasts',
  '/search',
  '/yourPodcasts',
  '/favourite',
  '/setting',
];



var drawerText = [

  "Podcasts",
  "Search Podcasts",
  "Your Podcasts",
  "Your Favourite",
  "Setting",

];

var drawerIcon = [

  Icons.music_note,
  Icons.search,
  Icons.library_music,
  Icons.favorite,
  Icons.settings

];
var cxt;
var drawer = Drawer(

  child: Column(
  children: <Widget>[
    SizedBox(height: 20,),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: Image.asset('assets/pngegg.png'),
            ),
            Text('Podcast App')
          ],
        ) 
        
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
              leading: Icon(drawerIcon[position]),
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
        Navigator.pushNamed(cxt, '/signIn');
      },
    )
  ],
),

);
