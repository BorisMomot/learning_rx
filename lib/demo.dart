import 'package:flutter/material.dart';

List<String> helloStrings = [
  'Hello string 1',
  'Hello string 2',
  'Hello string 3',
  'Hello string 4',
  'Hello string 5',
];

List<String> welcomeStrings = [
  'Welcome string 1 ',
  'Welcome string 2 ',
  'Welcome string 3 ',
  'Welcome string 4 ',
  'Welcome string 5 ',
];

Future<List<String>> fetchHelloString() async {
  await Future.delayed(Duration(seconds: 2));
  return helloStrings;
}

Future<List<String>> fetchWelcomeString() async {
  await Future.delayed(Duration(seconds: 1));
  return welcomeStrings;
}

// test
Stream<int> getNumbers() async* {
  for (int i = 0; i < 10; i++) {
    yield i;
    await Future.delayed(Duration(seconds: 2));
  }
}

void mayFunc() {
  getNumbers().listen((event) {
    print(event);
  });
}
