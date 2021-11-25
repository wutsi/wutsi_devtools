import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sdui/sdui.dart';

class SDUIViewerPage extends StatefulWidget {
  const SDUIViewerPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SDUIViewerPage> createState() => _SDUIViewerPageState();
}

class _SDUIViewerPageState extends State<SDUIViewerPage> {
  String url = '';
  String body = '';
  String accessToken = '';

  void _view(BuildContext context) {
    SDUIAction action = SDUIAction();
    action.type = 'Route';
    action.url = url;

    Map<String, dynamic> data = body.isNotEmpty ? jsonDecode(body) : {};

    action.execute(context, data);
  }

  @override
  void initState() {
    super.initState();
    
    setState(() {
      url = 'http://localhost:8080';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text('Enter the URL of the page to view')),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                initialValue: url,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(label: Text('URL')),
                onChanged: (value) => url = value.trim(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                keyboardType: TextInputType.url,
                maxLines: 10,
                decoration: const InputDecoration(
                    label: Text('Request Body'),
                    hintText: 'JSON to submit',
                    border: OutlineInputBorder()),
                onChanged: (value) => body = value.trim(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () => _view(context),
                      child: const Text('View')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
