import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:learning_rx/models/blog_post.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class USensor {
  String name;
  int value;
  int id;
  USensor({this.name, this.id, this.value});

  factory USensor.fromJson(dynamic json) {
    return USensor(
        name: json['name'] as String,
        id: json['id'] as int,
        value: json['value'] as int);
  }
  @override
  String toString() => '${this.name}, ${this.value}';
}

class BlogPostViewModel {
  var webSocket;
  var webSocket1;
  var webSocket2;
  var webSocket3;
  var webSocket4;
  var webSocket5;
  var webSocket6;
  var webSocket7;
  int counter = 0;

  StreamController<List<BlogPost>> _blogPostListController =
      StreamController.broadcast();
  Stream<List<BlogPost>> get outBlogPostList => _blogPostListController.stream;
  Sink<List<BlogPost>> get _inBlogPostList => _blogPostListController.sink;

  List<BlogPost> _blogPosts;

  BlogPostViewModel() {
    // Запрашиваем датчики
    String askSensors = '';
    for (var i = 1001; i < 1401; i++) {
      askSensors += '$i,';
    }
    // Подписываемся на сообщения от датчиков
    webSocket = IOWebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8081/wsgate/?Sensor1${askSensors}_S'));
    webSocket1 = IOWebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8081/wsgate/?Sensor1${askSensors}_S'));
    webSocket2 = IOWebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8081/wsgate/?Sensor1${askSensors}_S'));
    webSocket3 = IOWebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8081/wsgate/?Sensor1${askSensors}_S'));
    webSocket4 = IOWebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8081/wsgate/?Sensor1${askSensors}_S'));
    webSocket5 = IOWebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8081/wsgate/?Sensor1${askSensors}_S'));
    webSocket6 = IOWebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8081/wsgate/?Sensor1${askSensors}_S'));
    webSocket7 = IOWebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8081/wsgate/?Sensor1${askSensors}_S'));

    for (var i = 1; i < 10; i++) {
      String sensors = '';
      for (var n = 1; n < 100; n++) {
        sensors += '${i * 100 + n + 10001},';
      }
      webSocket.sink.add('ask:$sensors');
      // print('ask:$sensors');
    }

    Function listenMethod = (dynamic message) {
      // Debug
      print(message.toString());

      Map uniMessage = jsonDecode(message.toString());

      var sensorsJson = jsonDecode(message.toString())['data'] as List;
      List<USensor> uSensorsList =
          sensorsJson.map((senJson) => USensor.fromJson(senJson)).toList();

      // Debug
      print('Amount of sensors ${uSensorsList.length}');

      for (var s in uSensorsList) {
        counter++;
        addBlogPost(BlogPost(
            id: counter,
            author: s.name,
            content: s.value.toString(),
            publishDate: DateTime.now(),
            title: counter.toString()));
      }
    };

    webSocket.stream.listen(
      listenMethod,
      onError: (error) {
        print('Websocket error: $error');
      },
      onDone: () {
        print('Connection close');
      },
      cancelOnError: true,
    );

    webSocket1.stream.listen(listenMethod);
    webSocket2.stream.listen(listenMethod);
    webSocket3.stream.listen(listenMethod);
    webSocket4.stream.listen(listenMethod);
    webSocket5.stream.listen(listenMethod);
    webSocket6.stream.listen(listenMethod);
    webSocket7.stream.listen(listenMethod);

    outBlogPostList.listen((data) {
      _blogPosts = data;
    });

    _inBlogPostList.add([
      BlogPost(
          id: 1,
          author: 'Author',
          content: 'dsfsdfasd',
          publishDate: DateTime.now(),
          title: 'Blog Post 1'),
    ]);
  }

  void addBlogPost(BlogPost blogPost) {
    _blogPosts.add(blogPost);
    _inBlogPostList.add(_blogPosts);
  }

  void updateBlogPost(BlogPost blogPost) {
    final index = _blogPosts.indexOf(
        _blogPosts.where((element) => element.id == blogPost.id).first);
    _blogPosts[index] = blogPost;
    _inBlogPostList.add(_blogPosts);
  }

  void deleteBlogPost(int id) {
    _blogPosts.removeWhere((element) => element.id == id);
    _inBlogPostList.add(_blogPosts);
  }
}
