import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:handy_library/components/custom_tabbar.dart';
import 'package:handy_library/modules/side_menu.dart';
import 'package:rive/rive.dart';
import 'dart:math' as math;
import 'package:handy_library/screens/search.dart';
import 'package:handy_library/screens/news.dart';
import 'package:handy_library/screens/profile.dart';
import 'package:handy_library/screens/library.dart';
import 'package:handy_library/screens/feedback.dart';
import 'package:handy_library/screens/help.dart';
import 'package:handy_library/screens/settings.dart';
import 'package:handy_library/home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sidebarAnim;
  SMIBool? _menuBtn; // Nullable to avoid errors
  int selectedIndex = 0; // Tracks the current tab

  final List<Widget> _screens = [
    const Home(
      username: '',
    ),
    const Search(),
    const News(),
    const Profile(),
    const LibraryScreen(),
    const HelpScreen(),
    const FeedbackScreen(),
    const SettingsScreen()
  ];

  final springDesc =
      const SpringDescription(mass: 0.1, stiffness: 40, damping: 5);

  void _onMenuIconInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    if (controller != null) {
      artboard.addController(controller);
      _menuBtn = controller.findInput<bool>("Boolean 1") as SMIBool?;
      _menuBtn?.value = true; // Safe null check
    }
  }

  void onMenuPress() {
    if (_menuBtn == null) return; // Ensure _menuBtn is initialized

    if (_animationController.isAnimating) return; // Prevent multiple animations

    if (_menuBtn!.value) {
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _animationController.animateWith(springAnim);
    } else {
      _animationController.reverse();
    }

    _menuBtn!.change(!_menuBtn!.value);
  }

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 31, 56),
      body: Stack(
        children: [
          Positioned(
              child: Container(color: const Color.fromARGB(255, 16, 31, 56))),

          // Sidebar Animation
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180)
                  ..translate((1 - _sidebarAnim.value) * -300),
                child: child,
              );
            },
            child: FadeTransition(
              opacity: _sidebarAnim,
              child: const SideMenu(),
            ),
          ),

          // Main Content
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 - _sidebarAnim.value * 0.1,
                child: Transform.translate(
                  offset: Offset(_sidebarAnim.value * 265, 0),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateY((_sidebarAnim.value * 30) * math.pi / 180),
                    child: IndexedStack(
                      index: selectedIndex,
                      children: _screens,
                    ),
                  ),
                ),
              );
            },
          ),

          // Menu Button
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return SafeArea(
                child: Transform.translate(
                  offset: Offset(_sidebarAnim.value * 216, 0),
                  child: Row(
                    children: [
                      child!,
                      SizedBox(width: _sidebarAnim.value * 216),
                    ],
                  ),
                ),
              );
            },
            child: GestureDetector(
              onTap: onMenuPress,
              child: Container(
                height: 44,
                width: 44,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(60),
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: RiveAnimation.asset(
                  'assets/animations/nav.riv',
                  stateMachines: const ["State Machine 1"],
                  animations: const ["Open", "Close"],
                  onInit: _onMenuIconInit,
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar with Animation (Fixed at Bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      0,
                      _sidebarAnim.value *
                          100), // Moves tab bar down when menu opens
                  child: Opacity(
                    opacity: 1 -
                        _sidebarAnim.value, // Fades out tab bar when menu opens
                    child: child,
                  ),
                );
              },
              child: CustomTabbar(
                selectedIndex: selectedIndex,
                onTabSelected: onTabSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
