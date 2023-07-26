import 'dart:io';

import 'package:duma_health/models/chat_message.dart';
import 'package:flutter/material.dart';

class ChatCardMessage extends StatelessWidget {
  const ChatCardMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            ClipOval(
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
                width: 30,
                height: 30,
              ),
            ),
            const SizedBox(width: 5),
          ],
          messageContent(
            context,
            message: message,
          ),
          if (message.isSender) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }

  Widget messageContent(
    BuildContext context, {
    required ChatMessage message,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(message.isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          message.previewImageFile != null
              ? Padding(
                padding: const EdgeInsets.only(bottom: 10.0,),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(
                        message.previewImageFile!.path,
                      ),
                      fit: BoxFit.fill,
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
              )
              : const SizedBox(),
          message.text != null ? Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "${message.text}",
              softWrap: true,
              style: TextStyle(
                color: message.isSender ? Colors.white : Colors.black,
              ),
            ),
          ):const SizedBox(),
          const SizedBox(
            height: 2,
          ),
          Text(
            message.date,
            style: TextStyle(
              color: message.isSender
                  ? Colors.white.withOpacity(0.5)
                  : Colors.black.withOpacity(0.5),
              fontSize: 12.0,
            ),
          )
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus? status) {
      switch (status) {
        case MessageStatus.notSent:
          return Colors.red;
        case MessageStatus.notView:
          return Colors.black54;
        case MessageStatus.viewed:
          return Theme.of(context).colorScheme.secondary;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 5),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.notSent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
