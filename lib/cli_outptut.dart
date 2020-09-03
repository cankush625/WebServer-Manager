import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';

class CliOutput extends StatefulWidget {
  @override
  _CliOutputState createState() => _CliOutputState();
}
// ignore: non_constant_identifier_names
class _CliOutputState extends State<CliOutput> {
  var fsconnect = FirebaseFirestore.instance;

  String msgLine = " ";
  String commandName = " ";
  String output = " ";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          title: Text(
            'Web Manager',
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                'Execute commands on server',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter the command",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (x) {
                    commandName = x;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text(
                    'Execute'
                ),
                onPressed: () async {
                  var url = "http://13.234.217.159/cgi-bin/$commandName.py";
                  var result = await http.get(url);
                  var data = result.body;
                  setState(() {
                    msgLine = "Output of the $commandName comamnd is: ";
                    output = data;
                  });
                  fsconnect.collection("cli_output").add({
                    'commandName': '$commandName',
                    'commandOutput': '$output',
                  });
                  print(data);
                },
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      '$msgLine',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$output',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}