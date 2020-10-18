import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global.dart' as global;
import '../api.dart';

class CategoryWidget extends StatefulWidget {
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  Future futureCategory;

  initState(){

    futureCategory = fetchCategory();
    super.initState();
  }

  String selectedCategory = "";
  final List<DropdownMenuItem> list = [];

  Future fetchCategory() async {
    final response = await http.get(
        apiUri+'Category/category',
        headers: {
          'Authorization': global.user.message
        }
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData.runtimeType);
      jsonData['data'].forEach((k, v){
        print(k);
        print(v);
      });
      jsonData['data'].foreach((k, v){
        var key;
        var value;
        if(k == 'categoryID') {
          key = k ;
        }
        if (v == "categoryName") {
          value = v;
        }
        list.add(
          DropdownMenuItem(value: value, child: Text(key)),
        );
      });
      print(list);
      return true;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCategory,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return DropdownButton(
            value: selectedCategory,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                color: Colors.deepPurple
            ),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
//            onChanged: () {
////              setState(() {
////                selectedCategory = newValue;
////              });
//            },
            items: list,
          );
        } else if(snapshot.hasError){
          return Text('Some error occured whiled feting category ${snapshot.error}');
        }
        return LinearProgressIndicator();
      }
    );
  }
}
