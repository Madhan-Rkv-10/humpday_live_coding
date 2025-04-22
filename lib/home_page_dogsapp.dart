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
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderAligningShiftedBox;
import 'package:url_launcher/url_launcher.dart';

const horizontalMargin4 = SizedBox(width: 4.0);
const horizontalMargin8 = SizedBox(width: 8.0);
const horizontalMargin12 = SizedBox(width: 12.0);

const verticalMargin4 = SizedBox(height: 4.0);
const verticalMargin8 = SizedBox(height: 8.0);
const verticalMargin12 = SizedBox(height: 12.0);
const verticalMargin24 = SizedBox(height: 24.0);

const allPadding4 = EdgeInsets.all(4.0);
const allPadding8 = EdgeInsets.all(8.0);
const allPadding16 = EdgeInsets.all(16.0);
const allPadding24 = EdgeInsets.all(24.0);

const horizontalPadding4 = EdgeInsets.symmetric(horizontal: 4.0);
const horizontalPadding8 = EdgeInsets.symmetric(horizontal: 8.0);
const horizontalPadding16 = EdgeInsets.symmetric(horizontal: 16.0);
const horizontalPadding24 = EdgeInsets.symmetric(horizontal: 24.0);

const verticalPadding4 = EdgeInsets.symmetric(vertical: 4.0);
const verticalPadding8 = EdgeInsets.symmetric(vertical: 8.0);
const verticalPadding16 = EdgeInsets.symmetric(vertical: 16.0);
const verticalPadding24 = EdgeInsets.symmetric(vertical: 24.0);

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

final class DogFoodAppTheme {
  static const backgroundColor = Color.fromRGBO(248, 249, 250, 1);
  static const themeBrownColor = Color.fromRGBO(179, 128, 86, 1);
  static const menuBrownColor = Color.fromRGBO(139, 94, 60, 1);
  static const primaryButtonTextColor = Color.fromRGBO(0, 77, 64, 1);
}

class ChildBuilder extends StatelessWidget {
  const ChildBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  final TransitionBuilder builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) => builder(context, child);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void onMenuItemSelected(String value) {
    print('Item $value');
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: [
        PageTopBar(
          onMenuItemSelected: onMenuItemSelected,
        ),
        HomeBannerWidget(),
        SellingPointWidget(
          items: const [
            (icon: Icons.verified, text: 'Satisfaction guaranteed'),
            (icon: Icons.grain, text: 'Grain free'),
            (icon: Icons.local_shipping, text: 'Free delivery'),
          ],
        ),
        BestSellerWidget(),
        Stack(
          fit: StackFit.passthrough,
          children: [
            Column(
              children: [
                HomeBannerWidget(),
                HomeBannerWidget(),
                HomeBannerWidget(),
              ],
            ),
            Positioned.fill(
              child: Placeholder(),
            ),
          ],
        ),
      ],
    );
  }
}

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return PageOverflow(
      width: 450.0,
      child: Material(
        color: DogFoodAppTheme.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

class PageTopBar extends StatelessWidget {
  const PageTopBar({
    super.key,
    required this.onMenuItemSelected,
  });

  final ValueChanged<String> onMenuItemSelected;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: ColoredBox(
        color: DogFoodAppTheme.themeBrownColor,
        child: Row(
          children: [
            Padding(
              padding: allPadding8,
              child: GestureDetector(
                onTap: () {},
                child: SizedBox.square(
                  dimension: 48.0,
                  child: Placeholder(),
                ),
              ),
            ),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.end,
                children: [
                  DropDownTab(
                    onSelected: onMenuItemSelected,
                    title: 'Dog Food',
                    items: const [
                      (value: 'dry', text: 'Dry Food'),
                      (value: 'wet', text: 'Wet Food'),
                      (value: 'snacks', text: 'Snacks'),
                    ],
                  ),
                  DropDownTab(
                    onSelected: onMenuItemSelected,
                    title: 'Our Story',
                    items: const [
                      (value: 'about', text: 'About Us'),
                      (value: 'values', text: 'Our Values'),
                      (value: 'team', text: 'Team'),
                    ],
                  ),
                  DropDownTab(
                    onSelected: onMenuItemSelected,
                    title: 'Contact Us',
                    items: const [
                      (value: 'email', text: 'Email'),
                      (value: 'phone', text: 'Phone'),
                      (value: 'location', text: 'Location'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropDownTab extends StatelessWidget {
  const DropDownTab({
    super.key,
    required this.onSelected,
    required this.title,
    required this.items,
  });

  final ValueChanged<String> onSelected;
  final String title;
  final List<({String text, String value})> items;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: PopupMenuButton(
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return [
            for (final item in items) //
              PopupMenuItem(
                value: item.value,
                child: Text(
                  item.text,
                  style: TextStyle(color: DogFoodAppTheme.menuBrownColor),
                ),
              ),
          ];
        },
        child: Padding(
          padding: verticalPadding4 + horizontalPadding8,
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBannerWidget extends StatelessWidget {
  const HomeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChildBuilder(
      builder: (context, child) {
        final size = MediaQuery.sizeOf(context);
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height * 0.35,
          ),
          child: child,
        );
      },
      child: DecoratedBox(
        decoration: const BoxDecoration(),
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/assets/images/banner5.png'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Padding(
          padding: verticalPadding24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text
              Padding(
                padding: horizontalPadding16,
                child: AutoSizeText.rich(
                  TextSpan(
                    text: 'HEALTHY, HAPPY PETS\n',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: DogFoodAppTheme.themeBrownColor,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    children: const [
                      TextSpan(
                        text: 'STARTS HERE!\n\n',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'High-protein kibble\n',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: DogFoodAppTheme.themeBrownColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Delivered fresh to your door\n',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: DogFoodAppTheme.themeBrownColor,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 5, // Adjust to fit within space
                  minFontSize: 12, // Minimum font size for responsiveness
                ),
              ),
              // Add spacing between text and button
              verticalMargin24,
              // Sign Up Button
              ElevatedButton(
                onPressed: () async {
                  const url = 'https://wa.me/message/UTDJXATS2FQXM1';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    // Handle error if the URL cannot be launched
                    print('Could not launch $url');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: horizontalPadding24 + verticalPadding8,
                  backgroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Shop Now',
                  style: TextStyle(
                    fontSize: 18,
                    color: DogFoodAppTheme.primaryButtonTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellingPointWidget extends StatelessWidget {
  const SellingPointWidget({
    super.key,
    required this.items,
  });

  final List<({IconData icon, String text})> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      color: DogFoodAppTheme.themeBrownColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final item in items) //
            _SellingPointItem(
              icon: item.icon,
              text: item.text,
            ),
        ],
      ),
    );
  }
}

class _SellingPointItem extends StatelessWidget {
  const _SellingPointItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Minimize horizontal space usage
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20, // Adjust icon size if needed
        ),
        horizontalMargin4, // Spacing between icon and text
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class BestSellerWidget extends StatelessWidget {
  const BestSellerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PageOverflow extends SingleChildRenderObjectWidget {
  const PageOverflow({
    super.key,
    this.width,
    this.height,
    this.alignment = Alignment.topLeft,
    required super.child,
  });

  final double? width;
  final double? height;
  final AlignmentGeometry alignment;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPageOverflow(
      width: width,
      height: height,
      alignment: alignment,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderPageOverflow renderObject) {
    renderObject
      ..width = width
      ..height = height
      ..alignment = alignment
      ..textDirection = Directionality.of(context);
  }
}

class RenderPageOverflow extends RenderAligningShiftedBox {
  RenderPageOverflow({
    double? width,
    double? height,
    required super.alignment,
    required TextDirection super.textDirection,
    super.child,
  })  : _width = width,
        _height = height;

  double? _width;

  double? get width => _width;

  set width(double? value) {
    if (value != _width) {
      _width = value;
      markNeedsLayout();
    }
  }

  double? _height;

  double? get height => _height;

  set height(double? value) {
    if (value != _height) {
      _height = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final width = _width ?? constraints.maxWidth;
    final height = _height ?? constraints.maxHeight;
    final childConstraints = constraints //
        .copyWith(minWidth: width, minHeight: height)
        .normalize();
    child!.layout(childConstraints, parentUsesSize: true);
    size = Size(
      constraints.maxWidth,
      math.max(height, child!.size.height),
    );
    alignChild();
  }
}
