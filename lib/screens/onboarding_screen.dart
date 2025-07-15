import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<String> _animations = [
    'assets/animations/onboarding1.png',  // PNG image
    'assets/animations/onboarding2.json', // Lottie
    'assets/animations/onboarding3.json', // Lottie
  ];

  final List<String> _titles = [
    "Verified Local Vendors",
    "Scan Your Pantry/Fridge",
    "Fresh Produce Delivered",
  ];

  final List<String> _subtitles = [
    "We connect you with trusted mama mbogas and car boot sellers.",
    "Quick orders, fridge scan & healthy suggestions at your fingertips.",
    "Enjoy fast delivery and AI-powered produce suggestions.",
  ];

  void _nextPage() {
    if (_currentIndex < _animations.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacementNamed(context, '/phone_login');
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipOnboarding,
            child: const Text(
              "Skip",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _animations.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final animationPath = _animations[index];
                final isLottie = animationPath.endsWith('.json');

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                    child: Column(
                      children: [
                        isLottie
                            ? Lottie.asset(
                                animationPath,
                                height: 280,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                animationPath,
                                height: 280,
                                fit: BoxFit.contain,
                              ),
                        const SizedBox(height: 24),
                        Text(
                          _titles[index],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(221, 3, 200, 20),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _subtitles[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(137, 2, 188, 15),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _animations.length,
              (index) => AnimatedContainer(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                duration: const Duration(milliseconds: 300),
                height: 10,
                width: _currentIndex == index ? 24 : 10,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.green : const Color.fromARGB(255, 251, 250, 250),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _currentIndex == _animations.length - 1 ? "Get Started" : "Next",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
