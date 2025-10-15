// MIT License
//
// Copyright (c) 2025 Simon Lightfoot
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
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test_app2/photos.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _gridKey = GlobalKey(debugLabel: 'Grid');
  final _itemKeys = <GlobalKey>[];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < imageThumbUrls.length; i++) {
      _itemKeys.add(GlobalKey(debugLabel: 'Item $i'));
    }
  }

  void _shareItemImage(int index) async {
    final imagePngData = await fetchImageBytesFromImageProvider(
      NetworkImage(imageThumbUrls[index]),
    );
    SharePlus.instance.share(
      ShareParams(
        text: 'I want to share my picture with you!',
        files: [
          XFile.fromData(
            imagePngData,
            mimeType: 'image/png',
            name: 'image.png',
            length: imagePngData.lengthInBytes,
          ),
        ],
      ),
    );
  }

  Future<Uint8List> fetchImageBytesFromImageProvider(
    ImageProvider imageProvider, {
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    final completer = Completer<Uint8List>();
    final imageStream = imageProvider.resolve(
      createLocalImageConfiguration(context),
    );
    final listener = ImageStreamListener(
      (ImageInfo image, bool sync) async {
        final data = await image.image.toByteData(format: format);
        completer.complete(data!.buffer.asUint8List());
      },
      onError: (Object error, StackTrace? stackTrace) {
        completer.completeError(error, stackTrace);
      },
    );
    imageStream.addListener(listener);
    try {
      final data = await completer.future;
      return data;
    } finally {
      imageStream.removeListener(listener);
    }
  }

  void _shareFromKey(GlobalKey key) async {
    final imagePngData = await fetchImageForWidget(key);
    SharePlus.instance.share(
      ShareParams(
        text: 'I want to share my picture with you!',
        files: [
          XFile.fromData(
            imagePngData,
            mimeType: 'image/png',
            name: 'image.png',
            length: imagePngData.lengthInBytes,
          ),
        ],
      ),
    );
  }

  Future<Uint8List> fetchImageForWidget(
    GlobalKey key, {
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    final completer = Completer<Uint8List>();
    final renderBoundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final image = await renderBoundary.toImage();
        final data = await image.toByteData(format: format);
        completer.complete(data!.buffer.asUint8List());
      } catch (error, stack) {
        completer.completeError(error, stack);
      }
    });
    return await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return Scaffold(
      body: InkWell(
        // onTap: () => _shareFromKey(_gridKey),
        child: RepaintBoundary(
          key: _gridKey,
          child: GridView.builder(
            padding: const EdgeInsets.all(4.0) + viewPadding,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: imageThumbUrls.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: RepaintBoundary(
                  key: _itemKeys[index],
                  child: Material(
                    borderRadius: BorderRadius.circular(12.0),
                    clipBehavior: Clip.antiAlias,
                    child: Ink.image(
                      image: NetworkImage(imageThumbUrls[index]),
                      fit: BoxFit.cover,
                      child: InkWell(
                        //onTap: () => _shareItemImage(index),
                        onTap: () => _shareFromKey(_itemKeys[index]),
                        child: Center(
                          child: Text(
                            'Item $index',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
