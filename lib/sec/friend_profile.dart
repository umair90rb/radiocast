import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../sec/friend_podcast.dart';
import '../api.dart';
import '../global.dart' as global;
class FriendProfile extends StatefulWidget {
  String profile;
  String frnduser;
  String id;

  FriendProfile({
    this.profile,
    this.frnduser,
    this.id
  });

  @override
  _FriendProfileState createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {

  bool isFriend = false;
  Future checkFriend;



  addFriend(uid, username, frndusername, frndprofile) async {
    final response = await http.get(
      apiUri+'/sec/create.php??uid=$uid&username=$username&frndusername=$frndusername&frndprofile=$frndprofile',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  checkFriendFun() async {

    print(global.secuser['secusername']);
    final response = await http.get(
      apiUri+'/sec/check_friend.php?frnd=${widget.frnduser}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('already friend');
      setState(() {
        isFriend = false;
      });
    } else {
      print('not friend');
        setState(() {
          isFriend = true;
        });
    }
  }

  @override
  void initState() {
    checkFriend = checkFriendFun();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Friend Profile'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
        Container(
          width: 300,
          height: 300,

          decoration: ShapeDecoration(
              color: Colors.grey,
              shape: CircleBorder(),
              image: DecorationImage(
                  image: NetworkImage('https://4kradiopodcast.com/upload/${widget.profile}',)
              )
          ),
        ),
          SizedBox(height: 20,),
          Text("${widget.frnduser} ", style: TextStyle(fontSize: 20,fontFamily: 'DancingScript', color: Colors.deepOrange ),),
          SizedBox(height: 20,),
          Visibility(
            visible: isFriend,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                trailing: Icon(Icons.add),
                title:Text("Add Friend", style: TextStyle(fontSize: 20,fontFamily: 'DancingScript', color: Colors.deepOrange )),
                onTap: () async {
                  var r = await addFriend(global.user.id, global.user.username, widget.frnduser, widget.profile);
                  if(r == true){
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Friend Added.")));
                    setState(() {
                      isFriend = false;
                    });
                  } else {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Something wrong!")));

                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              trailing: Icon(Icons.arrow_forward),
              title:Text("${widget.frnduser} Podcasts", style: TextStyle(fontSize: 20,fontFamily: 'DancingScript', color: Colors.deepOrange )),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendPodcast(username: widget.frnduser,)));

              },
            ),
          )

        ],
      ),
    );
  }
}
