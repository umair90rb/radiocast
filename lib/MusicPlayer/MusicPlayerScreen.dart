import 'dart:convert';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'AudioPlayer.dart';
import 'package:http/http.dart' as http;
import '../api.dart';
import '../global.dart' as global;

class BGAudioPlayerScreen extends StatefulWidget {
  String id;
  String title;
  int duration;
  String artUri;
  String podcast;
  String thumbnail;
  BGAudioPlayerScreen({this.id, this.title, this.duration, this.artUri, this.podcast, this.thumbnail});

   @override
  _BGAudioPlayerScreenState createState() => _BGAudioPlayerScreenState(id, title, duration, artUri);
}

class _BGAudioPlayerScreenState extends State<BGAudioPlayerScreen> {
  final BehaviorSubject<double> _dragPositionSubject =
  BehaviorSubject.seeded(null);
  var _queue;
  _BGAudioPlayerScreenState(id, title, duration, artUri){
    print(duration);
    _queue = <MediaItem>[
      MediaItem(
        id: id,
        album: "Podcast",
        title: title,
        artist: "Running Podcasts",
        duration: Duration(milliseconds: duration),
        artUri:
        artUri,
      ),

    ];

  }

  // final _queue = <MediaItem>[
  //   MediaItem(
  //     id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
  //     album: "Science Friday",
  //     title: "A Salute To Head-Scratching Science",
  //     artist: "Science Friday and WNYC Studios",
  //     duration: Duration(milliseconds: 5739820),
  //     artUri:
  //     "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
  //   ),
  //
  // ];

  bool _loading;
  bool isLiked = false ;
  bool favouriteDisabled = false ;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  onStart() async {
      List<dynamic> list = List();
    for (int i = 0; i < 1; i++) {

      var m = _queue[i].toJson();

      list.add(m);
    }
    var params = {"data": list};
    print(params);
  setState(() {
    _loading = true;
  });
  await AudioService.start(
    backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
    androidNotificationChannelName: 'Audio Player',
    androidNotificationColor: 0xFF2196f3,
    androidNotificationIcon: 'mipmap/ic_launcher',
    params: params,
  );
  setState(() {
    _loading = false;
  });
}


  @override
  void initState() {
    super.initState();
    _loading = false;
    onStart();
    checkFavourite(global.user.username, widget.title, widget.thumbnail, widget.podcast);
  }

    checkFavourite(username, title, thumbnail, podcast) async {

      print(username);
      print(title);
      print(thumbnail);
      print(podcast);
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

    addToFavourite(username, title, thumbnail, podcast) async {


    final response = await http.get(
      apiUri+'order/create.php?username=$username&title=$title&thumbnail=$thumbnail&podcast=$podcast',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response.statusCode;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Audio Player'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
        }),
      ),
      body: Container(
        padding: EdgeInsets.all(2.0),
        color: Colors.white,
        child: StreamBuilder<AudioState>(
          stream: _audioStateStream,
          builder: (context, snapshot) {
            final audioState = snapshot.data;
            final queue = audioState?.queue;
            final mediaItem = audioState?.mediaItem;
            final playbackState = audioState?.playbackState;
            final processingState =
                playbackState?.processingState ?? AudioProcessingState.none;
            final playing = playbackState?.playing ?? false;
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (processingState == AudioProcessingState.none) ...[
                    // _startAudioPlayerBtn(),
                  ] else ...[
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(mediaItem.artUri)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    positionIndicator(mediaItem, playbackState),
                    SizedBox(height: 20),
                    if (mediaItem?.title != null) Text(mediaItem.title),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
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
                    SizedBox(width:25),
                        !playing
                            ? FloatingActionButton(
                          child: Icon(Icons.play_arrow),

                          onPressed: AudioService.play,
                        )
                            : FloatingActionButton(
                          child: Icon(Icons.pause),

                          onPressed: AudioService.pause,
                        ),
                        SizedBox(width:25),
                        FloatingActionButton(onPressed: AudioService.stop, child:Icon(Icons.stop)),
                      ],
                    )
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _startAudioPlayerBtn() {
    List<dynamic> list = List();
    for (int i = 0; i < 1; i++) {

      var m = _queue[i].toJson();

      list.add(m);
    }
    var params = {"data": list};
    print(params);
    return MaterialButton(
      child: Text(_loading ? "Loading..." : 'Start Audio Player'),
      onPressed: () async {
        setState(() {
          _loading = true;
        });
        await AudioService.start(
          backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
          androidNotificationChannelName: 'Audio Player',
          androidNotificationColor: 0xFF2196f3,
          androidNotificationIcon: 'mipmap/ic_launcher',
          params: params,
        );
        setState(() {
          _loading = false;
        });
      },
    );
  }

  Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
    double seekPos;
    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          _dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
              (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position =
            snapshot.data ?? state.currentPosition.inMilliseconds.toDouble();
        double duration = mediaItem?.duration?.inMilliseconds?.toDouble();
        return Column(
          children: [
            if (duration != null)
              Slider(
                min: 0.0,
                max: duration,
                value: seekPos ?? max(0.0, min(position, duration)),
                onChanged: (value) {
                  _dragPositionSubject.add(value);
                },
                onChangeEnd: (value) {
                  AudioService.seekTo(Duration(milliseconds: value.toInt()));
                  // Due to a delay in platform channel communication, there is
                  // a brief moment after releasing the Slider thumb before the
                  // new position is broadcast from the platform side. This
                  // hack is to hold onto seekPos until the next state update
                  // comes through.
                  // TODO: Improve this code.
                  seekPos = value;
                  _dragPositionSubject.add(null);
                },
              ),
            Text(_printDuration(state.currentPosition)),
          ],
        );
      },
    );
  }
}
String _printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
Stream<AudioState> get _audioStateStream {
  return Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState,
      AudioState>(
    AudioService.queueStream,
    AudioService.currentMediaItemStream,
    AudioService.playbackStateStream,
        (queue, mediaItem, playbackState) => AudioState(
      queue,
      mediaItem,
      playbackState,
    ),
  );
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

