import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Secondary Profile'),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.pushNamed(context, '/secSignin');
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud_upload),
              title: Text('Upload Podcast'),
              onTap: (){
                Navigator.pushNamed(context, '/uploadPodcast');
              },
            ),
          ],
        )
      ),
    );
  }
}
