import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:podcast/home/singlepodcast.dart';
import 'package:podcast/sec/friend_profile.dart';
import '../global.dart' as global;
import '../widgets/drawer.dart';

import '../api.dart';


class SecProfile extends StatefulWidget {
  @override
  _SecProfileState createState() => _SecProfileState();
}

class _SecProfileState extends State<SecProfile> {

  Future getPodcast;


  Future signUp() async {
    print(global.secuser['secusername']);
    final response = await http.get(
      apiUri+'/sec/friend.php?user=${global.secuser['secusername']}',
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
  Widget build(BuildContext context) {return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search_rounded),
          backgroundColor: Theme.of(context).buttonColor,
          onPressed: () {
            Navigator.pushNamed(context, '/searchFriend');
          }),
      drawer: drawer,
      appBar: AppBar(
        title: Text('Your Friend'),
      ),
      body: FutureBuilder(
          future: getPodcast,
          builder: (context, snapshot){
            if(snapshot.hasData){
              print(snapshot.data['records']);
              if(snapshot.data['records'] == null) return Center(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('You have no Friends.'),
              ),);
              return ListView(

                shrinkWrap: true,
                children: [
                  // Text('ab'),
                  for(var d in snapshot.data['records']) CurvedListItem(thumbnail: d['frndprofile'], title:d['frndusername'], user: d['username'], id: d['id'],)
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

    this.user,
    this.id,
  });

  final String title;
  final String thumbnail;

  final String user;
  final String id;

  @override
  _CurvedListItemState createState() => _CurvedListItemState();
}

class _CurvedListItemState extends State<CurvedListItem> {



  @override
  Widget build(BuildContext context) {

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
                    image: NetworkImage('https://4kradiopodcast.com/upload/${widget.thumbnail}')
                )
            ),
          ),
          title: Text(widget.title),
          subtitle: Text(widget.user),
          trailing: Icon(Icons.arrow_forward),
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendProfile(profile: widget.thumbnail, frnduser: widget.title, id: widget.id,)));

          }
      ),
    );
  }
}
