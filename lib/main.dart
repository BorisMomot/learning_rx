import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:learning_rx/viewmodels/blog_post_vm.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'demo.dart';
import 'package:learning_rx/pages/blog_post_list.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => BlogPostViewModel());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rx Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  BehaviorSubject<List<String>> streamController =
      BehaviorSubject<List<String>>();

  StreamTransformer<List<String>, List<String>> get streamTransformet =>
      StreamTransformer<List<String>, List<String>>.fromHandlers(
        handleData: (data, sink) {
          if (_textEditingController.text.length > 0) {
            sink.add(data
                .where(
                    (element) => element.contains(_textEditingController.text))
                .toList());
          } else {
            sink.add(data);
          }
        },
        handleError: (error, stackTrace, sink) {},
      );

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  void fetchData() async {
    final stopwatch = Stopwatch()..start();
    Rx.combineLatest2(fetchHelloString().asStream(),
        fetchWelcomeString().asStream(), (a, b) => a + b).listen((event) {
      streamController.sink.add(event);
    });
    print('executed in ${stopwatch.elapsedMilliseconds}');
    stopwatch.stop();
  }

  // Counter part
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlogPostList();
  }
}

// class OldMainScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Learn'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//             SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: _textEditingController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Enter something',
//                       ),
//                     ),
//                     Container(
//                       height: 400,
//                       child: StreamBuilder(
//                         stream: streamController.transform(streamTransformet),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             List<String> data = snapshot.data ?? "";
//                             return ListView(
//                               children: data
//                                   .map((s) => ListTile(title: Text(s)))
//                                   .toList(),
//                             );
//                           }
//                           return Text(snapshot.error.toString());
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
