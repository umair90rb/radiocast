import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            var res = await search(_search.text);
            result = [];
            res['records'].forEach((r){

              result.add(ListTile(
                leading: Icon(Icons.music_note),
                title: Text(r['title']),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignlePodcast(r['title'], r['thumbnail'], r['podcast']))
                  );
                },
              ));
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
