/// Reference (https://github.com/FilledStacks/markdown_fade_bounty/pull/6)
/// This widget, `FadeRevealMarkdownDifference`, is designed to display a series of markdown versions,
/// highlighting the differences between them. The issue being encountered is that the `previousText` is
/// currently showing a pulse animation, which is not required or expected behavior. The pulse effect
/// should only apply to the newly added portion of the text (`newText`). The goal is to have `previousText`
/// remain static while only the new changes (`newText`) fade in or animate.
///
/// The expected behavior is for `previousText` to remain static and unanimated, and only `newText`
/// should be subject to the fade-in effect.
///
/// Request: Can you help to rectify this issue, ensuring that only the new text (`newText`) shows
/// the fade effect, while the `previousText` remains static?
///
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: FadeRevealDifference()));
}

class FadeRevealDifference extends StatefulWidget {
  const FadeRevealDifference({super.key});

  @override
  State<FadeRevealDifference> createState() => _FadeRevealDifferenceState();
}

class _FadeRevealDifferenceState extends State<FadeRevealDifference>
    with SingleTickerProviderStateMixin {
  final markdownVersions = <String>[
    '## Problem\nThis is the main issue with what',
    "## Problem\nThis is the main issue with what we're trying to solve.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system. The new system should be designed with scalability and reliability in mind.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system. The new system should be designed with scalability and reliability in mind. Additionally, it should be user-friendly and easy to maintain.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system. The new system should be designed with scalability and reliability in mind. Additionally, it should be user-friendly and easy to maintain. The development team should also consider implementing automated testing to ensure the system's stability.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system. The new system should be designed with scalability and reliability in mind. Additionally, it should be user-friendly and easy to maintain. The development team should also consider implementing automated testing to ensure the system's stability. Regular user feedback should be collected to continuously improve the system.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system. The new system should be designed with scalability and reliability in mind. Additionally, it should be user-friendly and easy to maintain. The development team should also consider implementing automated testing to ensure the system's stability. Regular user feedback should be collected to continuously improve the system. The project should be managed using agile methodologies to ensure flexibility and adaptability.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system. The new system should be designed with scalability and reliability in mind. Additionally, it should be user-friendly and easy to maintain. The development team should also consider implementing automated testing to ensure the system's stability. Regular user feedback should be collected to continuously improve the system. The project should be managed using agile methodologies to ensure flexibility and adaptability. The team should also focus on documentation and knowledge sharing to ensure smooth onboarding of new team members.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system. The new system should be designed with scalability and reliability in mind. Additionally, it should be user-friendly and easy to maintain. The development team should also consider implementing automated testing to ensure the system's stability. Regular user feedback should be collected to continuously improve the system. The project should be managed using agile methodologies to ensure flexibility and adaptability. The team should also focus on documentation and knowledge sharing to ensure smooth onboarding of new team members. The system should be regularly audited for security vulnerabilities to ensure data protection.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system. The new system should be designed with scalability and reliability in mind. Additionally, it should be user-friendly and easy to maintain. The development team should also consider implementing automated testing to ensure the system's stability. Regular user feedback should be collected to continuously improve the system. The project should be managed using agile methodologies to ensure flexibility and adaptability. The team should also focus on documentation and knowledge sharing to ensure smooth onboarding of new team members. The system should be regularly audited for security vulnerabilities to ensure data protection. The system should also be designed to comply with relevant regulations and standards.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly. We need a more robust solution that can handle these edge cases effectively. This will require a complete overhaul of the system. The new system should be designed with scalability and reliability in mind. Additionally, it should be user-friendly and easy to maintain. The development team should also consider implementing automated testing to ensure the system's stability. Regular user feedback should be collected to continuously improve the system. The project should be managed using agile methodologies to ensure flexibility and adaptability. The team should also focus on documentation and knowledge sharing to ensure smooth onboarding of new team members. The system should be regularly audited for security vulnerabilities to ensure data protection. The system should also be designed to comply with relevant regulations and standards. The system should be regularly updated to incorporate the latest technologies and best practices.",
  ];

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  String previousText = '';
  String currentText = '';
  String newText = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duration of the fade effect
      vsync: this,
    );

    // Initialize text and animation for the first version
    _updateText(0);
  }

  void _updateText(int versionIndex) {
    if (versionIndex < 0 || versionIndex >= markdownVersions.length) return;

    setState(() {
      previousText = versionIndex > 0 ? markdownVersions[versionIndex - 1] : '';
      currentText = markdownVersions[versionIndex];
      newText = _findNewText(previousText, currentText);

      // Reinitialize animation for the fade effect
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

      // Reset and start the animation
      _controller.reset();
      _controller.forward();
    });
  }

  // Compare previous and current text to return the newly added portion
  String _findNewText(String oldText, String newText) {
    if (oldText == newText) return '';
    return newText.substring(oldText.length); // Get new text after old text
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fade Reveal (new) Difference Effect')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (BuildContext context, Widget? child) {
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: previousText),
                  TextSpan(
                    text: newText,
                    style: TextStyle(
                      color: Color.lerp(
                        Colors.transparent,
                        Colors.black,
                        _fadeAnimation.value,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Move to the next version and restart the animation
          int nextIndex =
              (markdownVersions.indexOf(currentText) + 1) %
              markdownVersions.length;
          _updateText(nextIndex);
        },
      ),
    );
  }
}
