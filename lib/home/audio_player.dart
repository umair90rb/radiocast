import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../widgets/url.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../widgets/widget.dart';
import 'package:audio_service/audio_service.dart';
import 'dart:math';
import '../widgets/video.dart';
import 'package:rxdart/rxdart.dart';

typedef void OnError(Exception exception);

var dio = Dio();

class SingleAudio extends StatefulWidget {
  final String id, title, artist, artworkPath, path, sduration;
  SingleAudio(this.id, this.title, this.artist, this.artworkPath, this.path,
      this.sduration);
  @override
  _SingleAudioState createState() =>
      _SingleAudioState(id, title, artist, artworkPath, path, sduration);
}

class _SingleAudioState extends State<SingleAudio> {
  final String id, title, artist, artworkPath, path, sduration;
  _SingleAudioState(this.id, this.title, this.artist, this.artworkPath,
      this.path, this.sduration);

  final BehaviorSubject<double> _dragPositionSubject = BehaviorSubject.seeded(null);
  bool _loading;
  static String sId, sTitle, sArtWork, sArtist, sPath, sDurat;
  @override
  void initState() {
    super.initState();
    _loading = false;
    myPrefs();
  }

  var _queue;
  var duration2;
  // static String songTitle, songId, songArtist, songPath, songArtWork;

  String songDuration;
  int timing;

  myPrefs() {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // songId = prefs.getString('songId');
    // songTitle = prefs.getString('songTitle');
    // songArtist = prefs.getString('songArtist');
    // songPath = prefs.getString('songPath');
    // songArtWork = prefs.getString('songArtworkPath');
    // setState(() {
    //   songId = songId;
    //   songTitle = songTitle;
    //   songArtist = songArtist;
    //   songPath = songPath;
    //   songArtWork = songArtWork;
    //   print("song $songPath");
    // });

    songDuration = sduration.toString().substring(2, 8).replaceRange(0, 1, "");
    print(songDuration);
    int s = int.parse(songDuration.substring(0, 2));
    int m = int.parse(songDuration.substring(3));
    int ss = s * 60;
    int sss = ss + m;
    print(sss);
// print(s);
    setState(() {
      sId = id;
      sTitle = title;
      sArtist = artist;
      sArtWork = artworkPath;
      sPath = path;
      sDurat = songDuration;
      timing = sss;
    });
    print(" song id is $value/$sPath");
    _queue = <MediaItem>[
      MediaItem(
        id: "$value/$sPath",
        album: sArtist,
        title: sTitle,
        duration: Duration(seconds: sss),
        artUri: "$value/$sArtWork",
      ),
    ];
  }

// download song code
//   void getPermission() async {
//     print("getPermission");
//     Map<PermissionGroup, PermissionStatus> permissions =
//         await PermissionHandler().requestPermissions([PermissionGroup.storage]);
//   }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      myToast((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  bool favourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: kGradientColor,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: 350,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('$value/$artworkPath'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.topLeft,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      CacheImage("$value/$artworkPath", 220),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          title,
                          textScaleFactor: 2.5,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          artist,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // height: 200,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: StreamBuilder<AudioState>(
                        stream: _audioStateStream,
                        builder: (context, snapshot) {
                          final audioState = snapshot.data;
                          final queue = audioState?.queue;
                          final mediaItem = audioState?.mediaItem;
                          final playbackState = audioState?.playbackState;
                          final processingState =
                              playbackState?.processingState ??
                                  AudioProcessingState.none;
                          final playing = playbackState?.playing ?? false;
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (processingState ==
                                    AudioProcessingState.none) ...[
                                  _startAudioPlayerBtn(),
                                ] else ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      !playing
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                              iconSize: 60.0,
                                              onPressed: AudioService.play,
                                            )
                                          : IconButton(
                                              icon: Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                              ),
                                              iconSize: 60.0,
                                              onPressed: AudioService.pause,
                                            ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.stop,
                                          color: Colors.white,
                                        ),
                                        iconSize: 60.0,
                                        onPressed: AudioService.stop,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          String path2 = await ExtStorage
                                              .getExternalStoragePublicDirectory(
                                                  ExtStorage
                                                      .DIRECTORY_DOWNLOADS);
                                          String fullPath = "$path2/$title.mp3";
                                          print('full path $fullPath');
                                          download2(
                                              dio, "$value/$path", fullPath);
                                          myToast("Downloading...");
                                        },
                                        child: Icon(
                                          Icons.file_download,
                                          color: Colors.white,
                                          size: 45,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            favourite = true;
                                          });
                                          _wishlist();
                                        },
                                        child: Icon(
                                          favourite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.white,
                                          size: 45,
                                        ),
                                      ),
                                    ],
                                  ),

                                  positionIndicator2(mediaItem, playbackState),
                                  SizedBox(height: 20),
                                  // if (mediaItem?.title != null) Text(mediaItem.title),
                                  // SizedBox(height: 10),
                                ]
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    return MaterialButton(
      child: Icon(
        _loading ? Icons.bubble_chart : Icons.play_arrow,
        size: 60,
        color: Colors.white,
      ),
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
  Widget positionIndicator2(MediaItem mediaItem, PlaybackState state) {
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
                 activeColor: Colors.teal[200],
                inactiveColor: Colors.teal[50],
                min: 0.0,
                max: duration,
                value: seekPos ?? max(0.0, min(position, duration)),
                onChanged: (value) {
                  _dragPositionSubject.add(value);
                },
                onChangeEnd: (value) {
                  AudioService.seekTo(Duration(milliseconds: value.toInt()));
                  seekPos = value;
                  _dragPositionSubject.add(null);
                },
              ),
            Text(
                  "${state.currentPosition.toString().substring(2,7)} / $sDurat",
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
          ],
        );
      },
    );
  }
  // Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
  //   double seekPos;
  //   return StreamBuilder(
  //     stream: Rx.combineLatest2<double, double, double>(
  //         _dragPositionSubject.stream,
  //         Stream.periodic(Duration(milliseconds: 200)),
  //         (dragPosition, _) => dragPosition),
  //     builder: (context, snapshot) {
  //       double position =
  //           snapshot.data ?? state.currentPosition.inSeconds.toDouble();
  //       double duration = mediaItem?.duration?.inSeconds?.toDouble();
  //       double remaining = duration - position;
  //       return Column(
  //         children: [
  //           if (duration != null)
  //             Slider(
  //               activeColor: Colors.teal[200],
  //               inactiveColor: Colors.teal[50],
  //               min: 0.0,
  //               max: duration,
  //               value: seekPos ?? max(0.0, min(position, duration)),
  //               onChanged: (value) {
  //                 setState(() {
  //                   _dragPositionSubject.add(value);
  //                 });
  //               },
  //               onChangeEnd: (value) {
  //                 setState(() {
  //                   AudioService.seekTo(Duration(seconds: value.toInt()));
  //                   seekPos = value;
  //                 });

  //                 print(value);
  //               },
  //             ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               Text(
  //                 "${state.currentPosition} / $sDurat",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ],
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  _wishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var userID = prefs.getString('userID');
    if (username == null && userID == null) {
      return myToast("Please Sign In..");
    } else {
      final response = await http.post(addtoPlaylistURL, body: {
        "username": username,
        "songId": id,
      });
      print(response.body);
      var data = json.decode(response.body);
      if (data.length == 0) {
        myToast("Failed to add..");
      } else {
        myToast("Song added to PlayList...");
      }
    }
  }
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
