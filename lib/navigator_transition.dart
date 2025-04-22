

import 'package:flutter/material.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsAppV3(
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen(),
        '/login': (_) => LoginScreen(),
        '/item': (_) => ItemScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarV3(
        title: Text('Home'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => NavigatorV3.of(context).push('/login'),
              child: Text('Login'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () => NavigatorV3.of(context).push('/item'),
              child: Text('Item'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          AppBarV3(
            title: Text('Login Screen'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Username'),
                  TextField(),
                  const SizedBox(height: 16.0),
                  Text('Password'),
                  TextField(obscureText: true),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () => NavigatorV3.of(context).pop(),
                    child: Text('Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          AppBarV3(
            title: Text('Details Screen'),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Item Details'),
                const SizedBox(height: 32.0),
                // NOTE: this won't work because it requires Navigator 1
                // ElevatedButton(
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (_) {
                //         return Dialog(
                //           child: Text('content'),
                //         );
                //       },
                //     );
                //   },
                //   child: Text('Get More'),
                // ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () => NavigatorV3.of(context).pop(),
                  child: Text('< Back'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class WidgetsAppV3 extends StatelessWidget {
  const WidgetsAppV3({
    super.key,
    required this.initialRoute,
    this.routes,
    this.onGenerateRoute,
  });

  final String initialRoute;
  final Map<String, WidgetBuilder>? routes;
  final RouteBuilderV3? onGenerateRoute;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(useMaterial3: false),
      child: Localizations(
        locale: View.of(context).platformDispatcher.locale,
        delegates: [
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: NavigatorV3(
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute != null
                ? onGenerateRoute!
                : (RouteSettingsV3 settings) {
                    final builder = routes![settings.name];
                    if (builder != null) {
                      return RouteV3(
                        settings: settings,
                        builder: builder,
                      );
                    }
                    return null;
                  },
          ),
        ),
      ),
    );
  }
}

class RouteSettingsV3 {
  RouteSettingsV3({
    required this.name,
  });

  final String name;
}

class RouteV3 {
  RouteV3({
    required this.settings,
    required this.builder,
    this.transitionDuration = const Duration(milliseconds: 600),
  });

  final RouteSettingsV3 settings;
  final WidgetBuilder builder;
  final Duration transitionDuration;

  AnimationController? _controller;

  void onAdded(TickerProvider vsync, bool isInitialRoute) {
    _controller = AnimationController(
      vsync: vsync,
      duration: transitionDuration,
      value: isInitialRoute ? 1.0 : 0.0,
    );
  }

  void dispose() {
    _controller!.dispose();
  }

  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );
  }

  Future<void> onShow() async {
    return await _controller!.forward();
  }

  Future<void> onHide() async {
    return await _controller!.reverse();
  }

  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: createAnimation(),
      child: builder(context),
    );
  }
}

typedef RouteBuilderV3 = RouteV3? Function(RouteSettingsV3 settings);

class NavigatorV3 extends StatefulWidget {
  const NavigatorV3({
    super.key,
    required this.initialRoute,
    required this.onGenerateRoute,
    this.onUnknownRoute = defaultUnknownRoute,
  });

  final String initialRoute;
  final RouteBuilderV3 onGenerateRoute;
  final Widget Function() onUnknownRoute;

  static Widget defaultUnknownRoute() {
    return Center(
      child: Text('Not Found'),
    );
  }

  static NavigatorV3State of(BuildContext context) {
    return context.findAncestorStateOfType<NavigatorV3State>()!;
  }

  @override
  State<NavigatorV3> createState() => NavigatorV3State();
}

class NavigatorV3State extends State<NavigatorV3>
    with TickerProviderStateMixin {
  final _stack = <RouteV3>[];

  @override
  void initState() {
    super.initState();
    push(widget.initialRoute);
  }

  RouteV3 current() => _stack.last;

  bool canPop() => _stack.length > 1;

  void push(String name) {
    final settings = RouteSettingsV3(name: name);
    var route = widget.onGenerateRoute(settings);
    route ??= RouteV3(
      settings: settings,
      builder: (_) => widget.onUnknownRoute(),
    );
    route.onAdded(this, _stack.isEmpty);
    setState(() => _stack.add(route!));
    route.onShow();
  }

  void pop() {
    final route = _stack.last;
    route.onHide().then((_) {
      if (mounted) {
        setState(() => _stack.remove(route));
      }
      route.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (final route in _stack) //
          route.build(context),
      ],
    );
  }
}

class AppBarV3 extends StatelessWidget implements PreferredSizeWidget {
  const AppBarV3({
    super.key,
    required this.title,
  });

  final Widget title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.viewPaddingOf(context).top,
          right: 16.0,
        ),
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              if (NavigatorV3.of(context).canPop()) //
                IconButton(
                  onPressed: () => NavigatorV3.of(context).pop(),
                  icon: Icon(Icons.arrow_back),
                )
              else
                SizedBox(width: 16.0),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.titleLarge,
                  child: title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
