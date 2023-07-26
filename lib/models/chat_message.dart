import 'package:image_picker/image_picker.dart';

enum MessageStatus { notSent, notView, viewed, sending }

class ChatMessage {
  final String date,id;
  final String? image,text;
  final MessageStatus messageStatus;
  final bool isSender;
  final XFile? previewImageFile;

  ChatMessage({
    this.text,
    required this.date,
    required this.id,
    required this.messageStatus,
    required this.isSender,
    this.previewImageFile,
    this.image,
  });
}
