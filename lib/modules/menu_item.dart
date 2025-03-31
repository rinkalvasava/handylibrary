import 'package:flutter/material.dart';
import 'package:handy_library/modules/tab_item.dart';

class MenuItemModel {
  MenuItemModel({this.id, this.title = "", required this.riveIcon});

  UniqueKey? id = UniqueKey();
  String title;
  TabItem riveIcon;

  static List<MenuItemModel> menuItems = [
    MenuItemModel(
      title: "Home",
      riveIcon: TabItem(stateMachine: "HOME_Interactivity", artboard: "HOME"),
    ),
    MenuItemModel(
      title: "Library",
      riveIcon: TabItem(stateMachine: "USER_Interactivity", artboard: "USER"),
    ),
    MenuItemModel(
      title: "Settings",
      riveIcon:
          TabItem(stateMachine: "SETTINGS_Interactivity", artboard: "SETTINGS"),
    ),
    MenuItemModel(
      title: "Help",
      riveIcon: TabItem(stateMachine: "CHAT_Interactivity", artboard: "CHAT"),
    ),
    MenuItemModel(
      title: "Feedback",
      riveIcon: TabItem(stateMachine: "BELL_Interactivity", artboard: "BELL"),
    )
  ];
}
