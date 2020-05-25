import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:math';

int PAGE_SIZE = 1000;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chinese Reader',
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Reader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 1;
  int _maxPages = 5;

  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/hongloumeng.txt');
  }

  void _incrementPage(newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  void _pageUp() {
    _incrementPage(min(_currentPage + 1, _maxPages));
  }

  void _pageDown() {
    _incrementPage(max(_currentPage - 1, 0));
  }

  int getTotalPages(String text) {
    return (text.length / PAGE_SIZE).round();
  }

  String getCurrentPage(String text) {
    int maxPageIdx = text.length;
    int currentPageIdx = PAGE_SIZE * _currentPage;
    return text.substring(
        currentPageIdx, min(currentPageIdx + PAGE_SIZE, maxPageIdx));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new Dismissible(
        key: new ValueKey(_currentPage),
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            _pageUp();
          } else if (direction == DismissDirection.startToEnd) {
            _pageDown();
          }
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
                child: FutureBuilder<String>(
                  future: loadAsset(context),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Text(getCurrentPage(snapshot.data));
                    } else {
                      return Text('nothing to load');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
