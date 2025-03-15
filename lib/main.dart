// MIT License
//
// Copyright (c) 2024 Simon Lightfoot
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(App());
}

/// ```dart
/// const splitter = LineSplitter();
/// const sampleText =
///     'Dart is: \r an object-oriented \n class-based \n garbage-collected '
///     '\r\n language with C-style syntax \r\n';
///
/// final sampleTextLines = splitter.convert(sampleText);
/// for (var i = 0; i < sampleTextLines.length; i++) {
///   print('$i: ${sampleTextLines[i]}');
/// }
/// // 0: Dart is:
/// // 1:  an object-oriented
/// // 2:  class-based
/// // 3:  garbage-collected
/// // 4:  language with C-style syntax
///
class MeetupsDatabase {
  MeetupsDatabase._();

  late List<MeetupsEntry> entries;

  static Future<MeetupsDatabase> create() async {
    final instance = MeetupsDatabase._();
    await instance.load();
    return instance;
  }

  Future<void> load() async {
    final data = await rootBundle.loadString('assets/meetups.jsonl');
    final lines = LineSplitter().convert(data);
    final entries = <MeetupsEntry>[];
    for (final line in lines) {
      final map = json.decode(line);
      entries.add(MeetupsEntry.fromJson(map));
    }
    this.entries = entries;
  }
}

class MeetupsEntry {
  const MeetupsEntry({
    required this.link,
    required this.name,
    required this.location,
  });

  final String link;
  final String name;
  final String location;

  static MeetupsEntry fromJson(Map<String, dynamic> json) {
    return MeetupsEntry(
      link: json['link'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<MeetupsDatabase> _dbFuture;

  MeetupsDatabase? database;
  void test() {
    const splitter = LineSplitter();
    const sampleText =
        'Dart is: \r an object-oriented \n class-based \n garbage-collected '
        '\r\n language with C-style syntax \r\n';

    final sampleTextLines = splitter.convert(sampleText);
    for (var i = 0; i < sampleTextLines.length; i++) {
      print('$i: ${sampleTextLines[i]}');
    }
  }

  @override
  void initState() {
    super.initState();
    _dbFuture = MeetupsDatabase.create().then((db) => database = db);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dbFuture,
      builder: (BuildContext context, AsyncSnapshot<MeetupsDatabase> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Home(database: snapshot.requireData),
        );
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key, required this.database});

  final MeetupsDatabase database;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: database.entries.length,
        itemBuilder: (BuildContext context, int index) {
          final entry = database.entries[index];
          return ListTile(
            onTap: () {
              print('Open ${entry.link}');
            },
            title: Text(entry.name),
            subtitle: Text(entry.location),
          );
        },
      ),
    );
  }
}
