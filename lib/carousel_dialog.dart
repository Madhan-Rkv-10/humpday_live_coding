import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CarouselScreen.show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () {
                CarouselScreen.show(context);
              },
              child: const Text('Show Carousel'),
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: const Offset(0.0, 0.0),
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastEaseInToSlowEaseOut,
              ),
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.4),
              ),
              child: child,
            ),
          );
        },
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return const CarouselScreen();
        },
      ),
    );
  }

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        CarouselPage(controller: _controller, child: const Text('Page 1')),
        CarouselPage(controller: _controller, child: const Text('Page 2')),
        CarouselPage(controller: _controller, child: const Text('Page 3')),
      ],
    );
  }
}

class CarouselPage extends StatelessWidget {
  const CarouselPage({
    super.key,
    required this.controller,
    required this.child,
  });

  final PageController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: 300.0,
          height: 300.0,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  children: [Expanded(child: Text('Title')), CloseButton()],
                ),
              ),
              Expanded(child: child),
              const Divider(height: 1.0),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListenableBuilder(
                        listenable: controller,
                        builder: (BuildContext context, Widget? child) {
                          final position = controller.position;
                          return TextButton(
                            style: TextButton.styleFrom(
                              shape: const ContinuousRectangleBorder(),
                            ),
                            onPressed:
                                !position.hasContentDimensions ||
                                        (controller.page ?? 0.0).floor() == 0
                                    ? null
                                    : () {
                                      controller.previousPage(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                            child: const Text('Prev'),
                          );
                        },
                      ),
                    ),
                    const VerticalDivider(width: 1.0),
                    Expanded(
                      child: ListenableBuilder(
                        listenable: controller,
                        builder: (BuildContext context, Widget? child) {
                          final position = controller.position;
                          int pageCount = 0;
                          if (position.hasContentDimensions &&
                              position.hasViewportDimension) {
                            pageCount =
                                (position.maxScrollExtent -
                                    position.minScrollExtent) ~/
                                position.viewportDimension;
                          }
                          return TextButton(
                            style: TextButton.styleFrom(
                              shape: const ContinuousRectangleBorder(),
                            ),
                            onPressed:
                                !position.hasContentDimensions ||
                                        (controller.page ?? 0.0).round() >=
                                            pageCount
                                    ? null
                                    : () {
                                      controller.nextPage(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                            child: const Text('Next'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
