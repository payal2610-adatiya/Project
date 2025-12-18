import 'package:flutter/material.dart';
import 'package:artist_hub/auth/login_screen.dart';
import 'package:artist_hub/shared/constants/app_colors.dart';
import 'package:artist_hub/shared/preferences/shared_preferences.dart';

import '../dashboards/artist_dashboard/artist_dashboard.dart';
import '../dashboards/customer_dashboard/customer_dashboard.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  double _iconScale = 1.0;
  bool _isAnimating = false;

  final List<IntroPage> _introPages = [
    IntroPage(
      title: 'Welcome to Artist Hub',
      description: 'Connect with amazing artists from around the world and discover unique talents for your projects',
      image: '🎨',
      color: AppColors.purplePinkGradient,
      iconColor: Colors.purple,
      secondaryIcon: '🤝',
    ),
    IntroPage(
      title: 'Book Artists Instantly',
      description: 'Easily browse, select and book artists for your events, projects, and creative needs',
      image: '👨‍🎨',
      color: AppColors.blueGradient,
      iconColor: Colors.blue,
      secondaryIcon: '📅',
    ),
    IntroPage(
      title: 'Showcase Your Talent',
      description: 'Artists can build stunning portfolios, get discovered, and grow their creative careers',
      image: '🌟',
      color: AppColors.appBarGradient,
      iconColor: Colors.amber,
      secondaryIcon: '💼',
    ),
  ];

  @override
  void initState() {
    super.initState();
    SharedPreferencesHelper.init();

    // Animate the icon on first load
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _iconScale = 1.2;
        });
      }
    });
  }

  void _animateIcon() {
    if (_isAnimating) return;

    _isAnimating = true;
    setState(() {
      _iconScale = 1.3;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _iconScale = 1.0;
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          _isAnimating = false;
        });
      }
    });
  }

  void _navigateToNextScreen() async {
    final isLoggedIn = SharedPreferencesHelper.isUserLoggedIn;
    final userType = SharedPreferencesHelper.userType;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => userType == 'artist'
              ? const ArtistDashboard()
              : const CustomerDashboard(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _skipIntro() async {
    await SharedPreferencesHelper.setFirstTime(false);
    _navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isVerySmallScreen = screenHeight < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.loginBackgroundGradient.colors[0].withOpacity(0.95),
              AppColors.loginBackgroundGradient.colors[1].withOpacity(0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Animated background dots
            if (!isVerySmallScreen)
              Positioned(
                top: screenHeight * 0.05,
                right: screenWidth * 0.05,
                child: _buildAnimatedDot(
                  Colors.white.withOpacity(0.1),
                  isSmallScreen ? 60 : 80,
                ),
              ),
            if (!isVerySmallScreen)
              Positioned(
                bottom: screenHeight * 0.15,
                left: screenWidth * 0.05,
                child: _buildAnimatedDot(
                  Colors.white.withOpacity(0.08),
                  isSmallScreen ? 40 : 60,
                ),
              ),

            SafeArea(
              child: Column(
                children: [
                  // Skip button in top right (always visible)
                  if (!isVerySmallScreen)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: isSmallScreen ? 20.0 : 40.0,
                          right: 16.0,
                        ),
                        child: TextButton(
                          onPressed: _skipIntro,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 16 : 20,
                              vertical: isSmallScreen ? 8 : 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 3 : 5),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: isSmallScreen ? 16 : 18,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _introPages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                          _animateIcon();
                        });
                      },
                      itemBuilder: (context, index) {
                        return IntroPageWidget(
                          page: _introPages[index],
                          iconScale: _iconScale,
                          currentPage: _currentPage,
                          pageIndex: index,
                          isSmallScreen: isSmallScreen,
                          isVerySmallScreen: isVerySmallScreen,
                        );
                      },
                    ),
                  ),

                  // Bottom section with indicators and button
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
                    child: Column(
                      children: [
                        // Custom animated indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _introPages.length,
                                (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 3 : 4,
                              ),
                              width: _currentPage == index
                                  ? (isSmallScreen ? 20 : 24)
                                  : (isSmallScreen ? 6 : 8),
                              height: isSmallScreen ? 6 : 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                                boxShadow: _currentPage == index
                                    ? [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                                    : [],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 30),

                        // Animated Get Started/Next button
                        SizedBox(
                          width: double.infinity,
                          height: isSmallScreen ? 50 : 55,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.95),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                                BoxShadow(
                                  color: _introPages[_currentPage]
                                      .color
                                      .colors[0]
                                      .withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if (_currentPage == _introPages.length - 1) {
                                    await SharedPreferencesHelper.setFirstTime(false);
                                    _navigateToNextScreen();
                                  } else {
                                    _pageController.nextPage(
                                      duration:
                                      const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      key: ValueKey(_currentPage),
                                      children: [
                                        Text(
                                          _currentPage == _introPages.length - 1
                                              ? 'Get Started'
                                              : 'Next',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 16 : 18,
                                            fontWeight: FontWeight.w700,
                                            color: _introPages[_currentPage]
                                                .iconColor,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: isSmallScreen ? 6 : 8),
                                        Icon(
                                          _currentPage ==
                                              _introPages.length - 1
                                              ? Icons.rocket_launch_rounded
                                              : Icons.arrow_forward_ios_rounded,
                                          size: isSmallScreen ? 16 : 18,
                                          color: _introPages[_currentPage]
                                              .iconColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Optional: Quick skip text on last page
                        if (_currentPage == _introPages.length - 1 &&
                            !isVerySmallScreen)
                          SizedBox(height: isSmallScreen ? 10 : 15),
                        if (_currentPage == _introPages.length - 1 &&
                            !isVerySmallScreen)
                          GestureDetector(
                            onTap: _skipIntro,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: isSmallScreen ? 6 : 8,
                              ),
                              child: Text(
                                'Just explore the app →',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: isSmallScreen ? 13 : 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDot(Color color, double size) {
    return AnimatedContainer(
      duration: const Duration(seconds: 4),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class IntroPage {
  final String title;
  final String description;
  final String image;
  final LinearGradient color;
  final Color iconColor;
  final String secondaryIcon;

  IntroPage({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
    required this.iconColor,
    this.secondaryIcon = '✨',
  });
}

class IntroPageWidget extends StatelessWidget {
  final IntroPage page;
  final double iconScale;
  final int currentPage;
  final int pageIndex;
  final bool isSmallScreen;
  final bool isVerySmallScreen;

  const IntroPageWidget({
    super.key,
    required this.page,
    required this.iconScale,
    required this.currentPage,
    required this.pageIndex,
    required this.isSmallScreen,
    required this.isVerySmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isActive = currentPage == pageIndex;

    // Calculate responsive sizes
    final iconContainerSize = isVerySmallScreen
        ? screenWidth * 0.5
        : isSmallScreen
        ? screenWidth * 0.6
        : screenWidth * 0.7;
    final iconSize = iconContainerSize * 0.4;
    final secondaryIconPosition = iconContainerSize * 0.15;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive ? 1.0 : 0.5,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container with floating effect
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect
                  if (!isVerySmallScreen)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: iconContainerSize * 1.1,
                      height: iconContainerSize * 1.1,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            page.color.colors[0].withOpacity(0.3),
                            page.color.colors[1].withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.1, 0.5, 1.0],
                        ),
                      ),
                    ),

                  // Main icon container
                  AnimatedScale(
                    scale: isActive ? iconScale : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                    child: Container(
                      width: iconContainerSize,
                      height: iconContainerSize,
                      decoration: BoxDecoration(
                        gradient: page.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: page.color.colors[0].withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: page.color.colors[1].withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 3,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          page.image,
                          style: TextStyle(
                            fontSize: iconSize,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Floating secondary icon
                  if (!isVerySmallScreen)
                    Positioned(
                      bottom: secondaryIconPosition,
                      right: secondaryIconPosition,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          page.secondaryIcon,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(
                height: isVerySmallScreen
                    ? screenHeight * 0.03
                    : isSmallScreen
                    ? screenHeight * 0.04
                    : screenHeight * 0.06,
              ),

              // Title with fade-in effect
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isActive ? 1.0 : 0.3,
                child: Text(
                  page.title,
                  style: TextStyle(
                    fontSize: isVerySmallScreen
                        ? 24
                        : isSmallScreen
                        ? 28
                        : 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(
                height: isVerySmallScreen ? 12 : isSmallScreen ? 16 : 20,
              ),

              // Description with smooth animation
              AnimatedPadding(
                duration: const Duration(milliseconds: 400),
                padding: EdgeInsets.symmetric(
                  horizontal: isActive
                      ? (isVerySmallScreen ? 20 : isSmallScreen ? 30 : 40)
                      : (isVerySmallScreen ? 30 : isSmallScreen ? 40 : 60),
                ),
                child: Text(
                  page.description,
                  style: TextStyle(
                    fontSize: isVerySmallScreen
                        ? 14
                        : isSmallScreen
                        ? 16
                        : 18,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Progress indicator at bottom of content
              if (isActive && !isVerySmallScreen)
                Padding(
                  padding: EdgeInsets.only(
                    top: isSmallScreen ? 20 : 40,
                  ),
                  child: Text(
                    '${pageIndex + 1}/3',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
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