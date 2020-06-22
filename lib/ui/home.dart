import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _enterData = TextEditingController();

  //if you dont want to use future builder for multipage future usage, yopu can use this method below
  // create a function in the _HomeState class and assign async to it then call
  //it in the widget build(BuildContext Context)

  //below below is a future builder usage

//  void doSomething() async {
//    var data = await readData();
//    if (data != null) {
//      String message = await readData();
//      print(message);
//    }
//  }

  @override
  Widget build(BuildContext context) {
//    doSomething();
    return Scaffold(
      appBar: AppBar(
        title: Text("Read and Write"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: new Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.topCenter,
        child: ListTile(
            title: TextField(
              controller: _enterData,
              decoration: InputDecoration(labelText: "write data"),
            ),
            subtitle: FlatButton(
              onPressed: () {
                //save data
                writeData(_enterData.text);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text("Save data"),
                        Padding(padding: EdgeInsets.all(8.0)),
                        FutureBuilder(
                            future: readData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> data) {
                              if (data.hasData != null) {
                                return Text(data.data.toString(),
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ));
                              } else {
                                return Text("no data");
                              }
                            })
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

//create path to file
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path; //home/directory
}

// create local file
Future<File> get _localFile async {
  final path = await _localPath;
  return File("$path/data.txt");
}

// write to file
Future<File> writeData(String message) async {
  final file = await _localFile;
  // to write to file
  return file.writeAsString("$message");
}

//read to file
Future<String> readData() async {
  try {
    final file = await _localFile;
    String data = await file.readAsString();
    return data;
  } catch (e) {
    return "nothing";
  }
}
