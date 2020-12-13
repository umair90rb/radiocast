import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:podcast/MusicPlayer/MusicPlayerScreen.dart';
import 'package:podcast/home/singlepodcast.dart';
import '../api.dart';
import 'package:http/http.dart' as http;

import '../widgets/input.dart';


class SearchPod extends StatefulWidget {
  @override
  _SearchPodState createState() => _SearchPodState();
}

class _SearchPodState extends State<SearchPod> {

  TextEditingController _search = TextEditingController();
  List result = List();

  Future search(query) async {



      final response = await http.get(
        apiUri+'/product/search.php?query=${query}',
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          backgroundColor: Theme.of(context).buttonColor,
          onPressed: () async {
            if(_search.text.isEmpty) return Fluttertoast.showToast(
                  msg: "Please enter a query first.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,

                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            var res = await search(_search.text);
            result = [];
            res['records'].forEach((d){

              result.add(
                  CurvedListItem(thumbnail: d['thumbnail'], podcast: d['podcast'], title:d['title'], user: d['username'], id: d['id'],)
              );
              setState(() {              });
            });
            print(res);
          }),
      appBar: AppBar(
        title: Text('Search Podcast'),
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          formInputField('Search Podcast', _search, helperText: "Type query and press button.", icon: Icon(Icons.search), onChanged: (text){
            print(text);
          }),
          SizedBox(height: 15,),

          for(var e in result) e

        ],
      ),
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



  @override
  Widget build(BuildContext context) {
    print(widget.podcast);
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
          onTap: () async {
            var duration = await getMaxDuration(widget.podcast);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    AudioServiceWidget(child: BGAudioPlayerScreen(
                      id:"https://4kradiopodcast.com/api/file/read.php?file=${widget.podcast}",
                      title: "${widget.title}",
                      duration: int.parse(duration)*1000,
                      artUri: "https://4kradiopodcast.com/upload1/${widget.thumbnail}",
                    )
                      // SignlePodcast(widget.title, widget.thumbnail, widget.podcast, widget.user, widget.id)
                    )));

          }
      ),
    );
  }
}

getMaxDuration(file) async {

  final response = await http.get(
    apiUri+'file/duration.php?file=$file',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if(response.statusCode == 200){
    return response.body;
  }

}
