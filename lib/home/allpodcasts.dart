import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:podcast/home/singlepodcast.dart';
import '../global.dart' as global;
import '../widgets/drawer.dart';

import '../api.dart';

class AllPodcasts extends StatefulWidget {
  @override
  _AllPodcastsState createState() => _AllPodcastsState();
}

class _AllPodcastsState extends State<AllPodcasts> {

AudioPlayer audioPlayer = AudioPlayer();

Future getPodcast;


Future signUp() async {
  print(global.user.username);
  final response = await http.get(
    apiUri+'/product/read_one.php',
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
        title: Text('All Podcast'),
      ),
      body: FutureBuilder(
          future: getPodcast,
          builder: (context, snapshot){
            if(snapshot.hasData){
              print(snapshot.data['records']);
              return ListView(

                shrinkWrap: true,
                children: [
                  // Text('ab'),
                  for(var d in snapshot.data['records']) CurvedListItem(thumbnail: d['thumbnail'], podcast: d['podcast'], title:d['title'], user: d['username'], id: d['id'],)
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
    this.user,
    this.id
  });

  final String title;
  final String thumbnail;
  final String podcast;
  final String user;
  final String id;

  @override
  _CurvedListItemState createState() => _CurvedListItemState();
}

class _CurvedListItemState extends State<CurvedListItem> {
  AudioPlayer audioPlayer = AudioPlayer();


  @override
  Widget build(BuildContext context) {
    print(widget.podcast);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading:  Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: NetworkImage('https://4kradiopodcast.com/upload1/${widget.thumbnail}')
              )
          ),
        ),
        title: Text(widget.title),
        subtitle: Text(widget.user),
        trailing: Icon(Icons.music_note),
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignlePodcast(widget.title, widget.thumbnail, widget.podcast, widget.user, widget.id)));

        }
      ),
    );
  }
}
