import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import '../global.dart' as global;
import '../widgets/drawer.dart';

import '../api.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AudioPlayer audioPlayer = AudioPlayer();

  Future getPodcast;


  Future signUp() async {
    print(global.user.username);
    final response = await http.get(
      apiUri+'/product/read.php?id='+global.user.username,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      return (json.decode(response.body));
    }
  }

  @override
  void initState() {
    super.initState();
    getPodcast = signUp();
    
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).buttonColor,
            onPressed: () {
              Navigator.pushNamed(context, '/addPodcast');
            }),
      drawer: drawer,
      appBar: AppBar(
        title: Text('Your Podcasts'),
      ),
      body: FutureBuilder(
          future: getPodcast,
          builder: (context, snapshot){
          if(snapshot.hasData){
            print(snapshot.data['records']);
            if(snapshot.data['records'] == null) return Center(child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('You have no podcast.'),
            ),);
            return ListView(

              shrinkWrap: true,
              children: [
                // Text('ab'),
                for(var d in snapshot.data['records']) CurvedListItem(thumbnail: d['thumbnail'], podcast: d['podcast'], title:d['title'], nextColor: Colors.white, color: Colors.blueAccent,)
              ],
            );

          } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
          }

              // By default, show a loading spinner.
              return Container(
              width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).buttonColor),
            ),),);
      })
    );
  }
}

class CurvedListItem extends StatefulWidget {
  
  
  
  CurvedListItem({
    this.title,
    this.thumbnail,
    this.podcast,
    this.color,
    this.nextColor,
  });

  final String title;
  final String thumbnail;
  final String podcast;
  final Color color;
  final Color nextColor;

  @override
  _CurvedListItemState createState() => _CurvedListItemState();
}

class _CurvedListItemState extends State<CurvedListItem> {
  AudioPlayer audioPlayer = AudioPlayer();


  @override
  Widget build(BuildContext context) {
    print(widget.podcast);
    return Container(
      color: widget.nextColor,
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 50.0,
          bottom: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: (){
                          print(widget.podcast);
                          audioPlayer.play('https://4kradiopodcast.com/api/file/read.php?file=${widget.podcast}');
                        },
                      ),
                      IconButton(icon: Icon(Icons.pause), onPressed: () => audioPlayer.pause()),
                      IconButton(icon: Icon(Icons.stop), onPressed: () => audioPlayer.stop())
                    ],
                  )
                ]),
                Column(
                  children: [
                    ClipOval( child: Image.network('https://4kradiopodcast.com/upload1/${widget.thumbnail}', width: 75, height: 75,))
                  ],
                )
          ],
        )
      ),
    );
  }
}
