import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class ChatOption {
  int id;
  String title;
  IconData iconData;
  bool isAvailable;

  ChatOption({
    required this.id,
    required this.title,
    required this.iconData,
    this.isAvailable = false,
  });

  static List<ChatOption> lists = [
    ChatOption(
      id: 1,
      title: "Camera",
      iconData: Ionicons.camera_outline,
      isAvailable: true,
    ),
    ChatOption(
      id: 2,
      title: "Photo",
      iconData: Ionicons.image_outline,
      isAvailable: true,
    ),
    ChatOption(
      id: 3,
      title: "Document",
      iconData: Ionicons.document_attach_outline,
    ),
  ];
}
