import 'package:evalution_note/ui/auth/auth_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TraineeAuthScreen())); // Replace with your home route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellow.shade300,
              Colors.orange.shade500,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage(
                    image: 'assets/images/1.png', // Replace with actual asset
                    title: 'اهلا بك',
                    description: 'تتبع تقدمك في صالة الألعاب الرياضية، واحفظ ملاحظات التمرين، وراجع أدائك بمرور الوقت.',
                  ),
                  _buildPage(
                    image: 'assets/images/2.png', // Replace with actual asset
                    title: 'احفظ تقدمك',
                    description:
                        'يمكنك بسهولة حفظ ملاحظات التمرين الخاصة بك ومراجعة الجلسات السابقة وتحقيق أهدافك بشكل أسرع.',
                  ),
                ],
              ),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String image, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250), // Placeholder for an actual image
          SizedBox(height: 32),
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _completeOnboarding,
            child: Text(
              'تخطــي',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
            ),
            onPressed: () {
              if (_currentPage == 1) {
                _completeOnboarding();
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(_currentPage == 1 ? 'إنهــاء' : 'التالــي'),
          ),
        ],
      ),
    );
  }
}
