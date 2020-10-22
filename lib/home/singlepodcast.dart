import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SignlePodcast extends StatefulWidget {

  var title;
  var thumbnail;
  var podcast;

  SignlePodcast(this.title, this.thumbnail, this.podcast,);


  @override
  _SignlePodcastState createState() => _SignlePodcastState();
}

class _SignlePodcastState extends State<SignlePodcast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listen to Podcast'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: CurvedListItem(thumbnail: widget.thumbnail, podcast: widget.podcast, title:widget.title, nextColor: Colors.white, color: Colors.blueAccent,),
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