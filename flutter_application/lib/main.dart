import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/bloc_provider.dart';
import 'package:flutter_application/second.dart';
import 'package:flutter_application/size_utils.dart';
import 'package:flutter_application/test_size_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        title: Text("error"),
      ),
      body: Center(
        child: Text("${details.exceptionAsString()}"),
      ),
    );
  };
  runZonedGuarded(() {
    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    print("error:${error.toString()}");
    print("stack:${stack.toString()}");
  },
      zoneSpecification:
          ZoneSpecification(print: (self, parent, zone, line) {}));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeUtils.init(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = CounterBloc(1);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<CounterBloc, int>(
        bloc: counterBloc,
        builder: (context, count) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextButton(
                    child: Text("go size test"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SizeTestPage()));
                    },
                  ),
                ),
                Text(
                  "$count",
                  style: TextStyle(fontSize: 24.0),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SecondPage()));
                    },
                    child: Text("go second"))
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: FloatingActionButton(
                onPressed: () {
                  counterBloc.add(CounterEvent.increment);
                },
                child: Icon(Icons.add),
              )),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: FloatingActionButton(
                onPressed: () {
                  counterBloc.add(CounterEvent.decrement);
                },
                child: Icon(Icons.remove),
              ))
        ],
      ),
    );
  }
}
