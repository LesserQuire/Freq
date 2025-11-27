import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../pages/signup.dart';
import '../pages/home.dart';
import '../services/auth_service.dart';

class SplashPage extends StatefulWidget {
  final AuthService authService;
  const SplashPage({super.key, required this.authService});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _imagesController;
  late AnimationController _revealController;
  late Animation<double> _revealRadius;

  late final Widget _nextPage;

  final List<String> frames = List.generate(
    9,
    (i) => 'assets/images/splash${i + 1}.png',
  );

  @override
  void initState() {
    super.initState();

    final user = widget.authService.currentUser;
    _nextPage = (user != null) 
        ? HomePage(isPremium: false)
        : const SignupPage();

    _imagesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _revealRadius = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeInOutCubic),
    );

    _imagesController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _revealController.forward();
      }
    });

    _revealController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final nextRoute = (user != null) ? '/home?premium=false' : '/signup';
        context.go(nextRoute);
      }
    });
  }

  @override
  void dispose() {
    _imagesController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  Animation<double> _scaleForIndex(int index) {
    final frame = 1 / frames.length;
    final start = (index * frame) / 2;
    final end = start + frame;

    return Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _imagesController,
        curve: Interval(start.clamp(0, 1), end.clamp(0, 1), curve: Curves.easeOutBack),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diagonal = sqrt(size.width * size.width + size.height * size.height);

    return Stack(
      children: [
        _nextPage,

        AnimatedBuilder(
          animation: Listenable.merge([_imagesController, _revealController]),
          builder: (_, __) {
            final radius = _revealRadius.value * diagonal;

            return Center(
              child: ClipPath(
                clipper: CoverClipper(
                  center: Offset(size.width * 0.87, size.height * 0.43), 
                  radius: radius
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                    ),
                    for (int i = 0; i < frames.length; i++)
                      Transform.scale(
                        scale: _scaleForIndex(i).value,
                        child: Image.asset(frames[i]),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CoverClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  CoverClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    final full = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final circle = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    return Path.combine(PathOperation.difference, full, circle);
  }

  @override
  bool shouldReclip(CoverClipper oldClipper) =>
      oldClipper.radius != radius || oldClipper.center != center;
}
