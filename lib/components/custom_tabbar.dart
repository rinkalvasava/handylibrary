import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:handy_library/modules/tab_item.dart';

class CustomTabbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabSelected; // ✅ Callback from MainScreen

  const CustomTabbar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  State<CustomTabbar> createState() => _CustomTabbarState();
}

class _CustomTabbarState extends State<CustomTabbar> {
  final List<TabItem> _icons = TabItem.tabItemsList;

  void _onIconInit(Artboard artboard, int index) {
    final controller = StateMachineController.fromArtboard(
      artboard, 
      _icons[index].stateMachine
    );

    if (controller != null) {
      artboard.addController(controller);
      _icons[index].status = controller.findInput<bool>("active") as SMIBool?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        padding: const EdgeInsets.all(1),
        constraints: const BoxConstraints(maxWidth: 768),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0),
          ]),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 34, 58, 96).withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              TabItem icon = _icons[index];

              return GestureDetector(
                onTap: () {
                  widget.onTabSelected(index); // ✅ Update selectedIndex in MainScreen

                  if (_icons[index].status != null) {
                    _icons[index].status!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      _icons[index].status!.change(false);
                    });
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: RiveAnimation.asset(
                    'assets/animations/animated_icon_set.riv',
                    stateMachines: [icon.stateMachine], 
                    artboard: icon.artboard,
                    onInit: (artboard) {
                      _onIconInit(artboard, index);
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
