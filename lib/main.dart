import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';
import 'package:wutsi_devtools/http.dart';
import 'package:wutsi_devtools/viewer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initHttp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wutsi DevTool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      navigatorObservers: [sduiRouteObserver],
      routes: {
        '/': (context) => const SDUIViewerPage(title: 'SDUI Viewer'),
        '/401': (context) => const Error401(),
      },
    );
  }
}

class Error401 extends StatelessWidget {
  const Error401({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const Center(child: Text('401'));
}
