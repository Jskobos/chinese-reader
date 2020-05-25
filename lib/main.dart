import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:math';

const PAGE_SIZE = 900;

// Future<Reading> fetchReading() async {
// @todo replace local file with http request
// final response =
//     await http.get('https://jsonplaceholder.typicode.com/albums/1');

// if (response.statusCode == 200) {
//   // If the server did return a 200 OK response,
//   // then parse the JSON.
//   return Album.fromJson(json.decode(response.body));
// } else {
//   // If the server did not return a 200 OK response,
//   // then throw an exception.
//   throw Exception('Failed to load album');
// }

// }

Future<Reading> loadAsset(BuildContext context) {
  return DefaultAssetBundle.of(context)
      .loadString('assets/hongloumeng.txt')
      .then((response) {
    return Reading(
        text: response,
        title: 'Hong Lou Meng',
        pages: (response.length / PAGE_SIZE).round());
  });
}

class Reading {
  final int pages;
  final String title;
  final String text;

  Reading({this.text, this.pages, this.title});
}

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
      home: ReaderApp(title: 'Reader'),
    );
  }
}

class ReaderApp extends StatefulWidget {
  ReaderApp({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ReaderAppState createState() => _ReaderAppState();
}

class _ReaderAppState extends State<ReaderApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: FutureBuilder<Reading>(
            future: loadAsset(context),
            builder: (BuildContext context, AsyncSnapshot<Reading> snapshot) {
              if (snapshot.hasData) {
                return SingleReadingView(reading: snapshot.data);
              } else {
                return Text('Loading...');
              }
            }));
  }
}

class SingleReadingView extends StatefulWidget {
  SingleReadingView({Key key, this.reading}) : super(key: key);

  final Reading reading;

  @override
  _SingleReadingViewState createState() => _SingleReadingViewState();
}

class _SingleReadingViewState extends State<SingleReadingView> {
  int _currentPage = 0;
  int _pages = 1;

  void _incrementPage(newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  void _pageUp() {
    _incrementPage(min(_currentPage + 1, _pages));
  }

  void _pageDown() {
    _incrementPage(max(_currentPage - 1, 0));
  }

  int getTotalPages(String text) {
    return (text.length / PAGE_SIZE).round();
  }

  String getPage(int page) {
    int maxPageIdx = widget.reading.text.length;
    int pageIdx = PAGE_SIZE * page;
    return widget.reading.text
        .substring(pageIdx, min(pageIdx + PAGE_SIZE, maxPageIdx));
  }

  @override
  void initState() {
    super.initState();
    _pages = getTotalPages(widget.reading.text);
  }

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      key: new ValueKey(_currentPage),
      background: Text(getPage(_currentPage)),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          _pageUp();
        } else if (direction == DismissDirection.startToEnd &&
            _currentPage >= 0) {
          _pageDown();
        } else {
          return null;
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
              child: Text(getPage(_currentPage)),
            ),
          ],
        ),
      ),
    );
  }
}
