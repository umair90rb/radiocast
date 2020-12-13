
import 'dart:convert';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../api.dart';
import '../global.dart' as global;


class SignlePodcast extends StatefulWidget {

  var title;
  var thumbnail;
  var podcast;
  var user;
  var id;

  SignlePodcast(this.title, this.thumbnail, this.podcast, this.user, this.id);


  @override
  _SignlePodcastState createState() => _SignlePodcastState();
}

class _SignlePodcastState extends State<SignlePodcast> with TickerProviderStateMixin {


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void _showNotification(id, title, body, thumbnail, podcast ) async {
    await _demoNotification(id, title, body, thumbnail, podcast);
  }

  Future<void> _demoNotification(id, title, body, thumbnail, podcast) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,

        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(int.parse(id), "Running Podcast.",
        "$title by $body", platformChannelSpecifics,
        payload: "{ id:$id, title:$title, body:$body, thumbnail:$thumbnail, podcast:$podcast}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings();
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    controller = AnimationController(
        duration: const Duration(
            seconds: 4
        ),
        vsync: this
    );
    checkFavourite(global.user.username, widget.title, widget.thumbnail, widget.podcast);
    getMaxDuration();
    super.initState();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    print(payload);
  }

  AnimationController controller;



  @override
  dispose() {
    controller.dispose(); // you need this
    super.dispose();
  }

  double value = 0;

  AudioPlayer audioPlayer = AudioPlayer();

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  String displayDuration = "00:00";
  String displayMaxDuration = "0";
  String formatedDuration = "00:00:00";

  bool seekBarVisibility = false;
  getMaxDuration() async {

    final response = await http.get(
      apiUri+'file/duration.php?file=${widget.podcast}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
        var r = jsonDecode(response.body);
        print(r['duration']);
        print(r['formated']);
        setState(() {

          displayMaxDuration = r['duration'].toString();
          seekBarVisibility = true;
          formatedDuration = r['formated'];

        });
    }

  }
  getDuration(){
    audioPlayer.onAudioPositionChanged.listen((Duration  p) {
      print('Current position:${p.inSeconds}');
      setState(() {
        displayDuration = _printDuration(p);
        value = double.parse("${p.inSeconds}");
        if(double.parse(displayMaxDuration) == value) {
          controller.stop();
        }
      });

    });
  }

  addToFavourite(username, title, thumbnail, podcast) async {


    final response = await http.get(
      apiUri+'order/create.php?username=$username&title=$title&thumbnail=$thumbnail&podcast=$podcast',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response.statusCode;

  }

  checkFavourite(username, title, thumbnail, podcast) async {


    final response = await http.get(
      apiUri+'order/read.php?username=$username&title=$title&thumbnail=$thumbnail&podcast=$podcast',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      print('alerady in favourite.');
      setState(() {
        isLiked = true;
        favouriteDisabled = true;
      });
    } else {
      print('not in favourite');
      setState(() {
        favouriteDisabled = true;
      });
    }


  }

  var duration;
  bool isAudioPlaying = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLiked = false ;
  bool favouriteDisabled = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1, style: BorderStyle.solid),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              AnimatedBuilder(
                animation: controller,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.6,
                  height: MediaQuery.of(context).size.width*0.5,

                  decoration: ShapeDecoration(
                    color: Colors.grey,
                      shape: CircleBorder(),
                      image: DecorationImage(
                          image: NetworkImage('https://4kradiopodcast.com/upload1/${widget.thumbnail}',)
                      )
                  ),
                ),
                builder: (context, child){
                  return Transform.rotate(angle: controller.value * 2 * math.pi , child: child,);
                },
              ),
              SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${widget.title} ", style: TextStyle(fontSize: 20,fontFamily: 'DancingScript', color: Colors.deepOrange ),),
                  Text("by", style: TextStyle(fontSize: 14,fontFamily: 'DancingScript',),),
                  Text(" ${widget.user}", style: TextStyle(fontSize: 18,fontFamily: 'DancingScript', color: Colors.orange),),
                ],
              ),

              SizedBox(height: 30,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center
              //   ,
              //   children: [
              //     Text(displayDuration, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),),
              //   ],
              // ),
              Visibility(
                visible: seekBarVisibility,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(displayDuration, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Slider(
                        value: value,
                        onChanged: (newValue){
                          setState(() {
                            value = newValue;
                          });
                          print(value);
                        },

                        min: 0,
                        max: double.parse(displayMaxDuration),

                      ),
                    ),
                    Text(formatedDuration, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                        heroTag: 'btn3',
                        child: Icon(Icons.stop),
                        backgroundColor: Colors.red,
                        onPressed: () async {
                          controller.stop();
                          var result = await audioPlayer.stop();
                          if(result == 1) setState(() {
                            isAudioPlaying = false;
                          });
                          // await audioPlayer.release();
                        }),
                  ),
                  FloatingActionButton(
                    heroTag: 'btn1',
                    child: isAudioPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                    backgroundColor: Colors.green,
                    onPressed: ()async{
                      print(widget.podcast);
                      if(isAudioPlaying){
                        var result = await audioPlayer.pause();
                        print(result);
                        if(result == 1) {

                          controller.stop();
                          isAudioPlaying = false;
                          setState(() {});
                        }
                      } else {
                        controller.repeat();

                        var result = await audioPlayer.play('https://4kradiopodcast.com/api/file/read.php?file=${widget.podcast}');
                        if(result == 1){
                          await _showNotification(widget.id, widget.title, widget.user, widget.thumbnail, widget.podcast);
                          getDuration();
                          isAudioPlaying = true;
                          setState(() {});
                        }
                      }
                    },
                   ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Visibility(
                      visible: favouriteDisabled,
                      child: FloatingActionButton(
                        heroTag: 'btn2',
                          child: isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                          backgroundColor: Colors.orangeAccent,

                          onPressed: () async {
                            if(isLiked){
                              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Already in Favourite.")));
                              return;
                            }
                            var result = await addToFavourite(global.user.username, widget.title, widget.thumbnail, widget.podcast);
                            print(result);
                            if(result == 200) {
                              setState(() {
                                isLiked = true;
                              });
                              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Podcast added to Favourite.")));
                            }


                          }),
                    ),
                  ),
                ],
              )




            ],
          ),
        )
      ),
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

  var duration;
  bool isAudioPlaying = false;

  getDuration()async{
    await audioPlayer.onAudioPositionChanged.listen((Duration  p) {
      print('Current position: $p');

    });
  }

  @override
  void initState() {
    // getDuration();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
  // getDuration();
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
          child: Column(
            children: [
              Row(
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
                              icon: isAudioPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                              onPressed: ()async{
                                print(widget.podcast);
                                if(isAudioPlaying){
                                  audioPlayer.pause();
                                  isAudioPlaying = false;
                                  setState(() {});
                                } else {
                                  audioPlayer.play('https://4kradiopodcast.com/api/file/read.php?file=${widget.podcast}');
                                  isAudioPlaying = true;
                                  setState(() {});
                                }
                                await
                                getDuration();
                              },
                            ),

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
              ),
              Row(
                children: [
                  Text(duration.toString())
                ],
              )
            ],
          )
      ),
    );
  }
}