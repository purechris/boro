import 'package:verleihapp/pages/signup/signup.dart';
import 'package:verleihapp/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/pages/home.dart';
import 'package:verleihapp/services/auth_service.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';

class PreLogin extends StatefulWidget {
  const PreLogin({super.key});

  @override
  State<PreLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
  final PageController _pageController = PageController();
  final AuthService _authService = AuthService();
  int _currentPage = 0;

  // Slideshow-Daten - jetzt mit Lokalisierung
  List<Map<String, dynamic>> _getSlideshowData(BuildContext context) {
    return [
      {
        'icon': Icons.diversity_1,
        'text': AppLocalizations.of(context)!.slide1Text,
        'color': Colors.blueAccent,
      },
      {
        'icon': Icons.construction,
        'text': AppLocalizations.of(context)!.slide2Text,
        'color': Colors.orange,
      },
      {
        'icon': Icons.local_florist,
        'text': AppLocalizations.of(context)!.slide3Text,
        'color': Colors.green,
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final slideshowData = _getSlideshowData(context);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 30),
                _buildCenteredImage(),
                const SizedBox(height: 40),
                _buildSlideshow(slideshowData),
                const SizedBox(height: 0),
                _buildPageIndicators(slideshowData.length),
                const SizedBox(height: 40),
                _buildRegisterButton(),
                const SizedBox(height: 16),
                _buildLoginButton(),
                const SizedBox(height: 16),
                _buildDemoButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenteredImage() {
    return Center(
      child: Image.asset(
        'assets/pictures/logo.png',
        height: 120,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildSlideshow(List<Map<String, dynamic>> slideshowData) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: slideshowData.length,
        itemBuilder: (context, index) {
          return _buildSlide(slideshowData[index]);
        },
      ),
    );
  }

  Widget _buildSlide(Map<String, dynamic> slideData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          child: Center(
            child: Icon(
              slideData['icon'],
              size: 100,
              color: slideData['color'],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          slideData['text'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators(int slideCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        slideCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Signup(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.register,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.signIn,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDemoButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () async {
          try {
            await _authService.signInAsDemo();
            if (!mounted) return;
            await NavigationUtils.navigateTo(context, const HomePage(), clearStack: true);
          } catch (e) {
            if (!mounted) return;
            SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.tryDemo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}