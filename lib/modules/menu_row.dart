import 'package:flutter/material.dart';
import 'package:handy_library/modules/menu_item.dart';
import 'package:rive/rive.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.menu,
    this.selectedMenu = "Home",
    this.onMenuPress,
  });

  final MenuItemModel menu;
  final String selectedMenu;
  final Function? onMenuPress;

  void onMenuPressed() {
    if (selectedMenu != menu.title) {
      onMenuPress?.call(); // Safe call
      menu.riveIcon.status?.change(true);
      Future.delayed(const Duration(seconds: 1), () {
        menu.riveIcon.status?.change(false);
      });
    }
  }

  void _onMenuIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, menu.riveIcon.stateMachine);

    if (controller != null) {
      artboard.addController(controller);
      menu.riveIcon.status = controller.findInput<bool>("active") as SMIBool?;
    } else {
      debugPrint(
          "⚠️ StateMachineController is null for ${menu.riveIcon.stateMachine}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: selectedMenu == menu.title ? 288 - 16 : 0,
          curve: const Cubic(0.2, 0.8, 0.2, 1),
          height: 56,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
        ),
        ElevatedButton(
          onPressed: onMenuPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 32,
                width: 32,
                child: Opacity(
                  opacity: 0.6,
                  child: RiveAnimation.asset(
                    'assets/animations/animated_icon_set.riv',
                    stateMachines: [menu.riveIcon.stateMachine],
                    artboard: menu.riveIcon.artboard,
                    onInit: _onMenuIconInit,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                menu.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
