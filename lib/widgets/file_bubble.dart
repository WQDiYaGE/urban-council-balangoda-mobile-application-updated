import 'package:flutter/material.dart';

import 'chat_bubble.dart';

class FileBubble extends StatelessWidget {
  final String message;
  final String time;
  final ChatBubbleType chatBubbleType;

  const FileBubble(
      {super.key,
      required this.message,
      required this.chatBubbleType,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: chatBubbleType == ChatBubbleType.Sender
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: chatBubbleType == ChatBubbleType.Receiver
                    ? Radius.zero
                    : const Radius.circular(15),
                bottomRight: chatBubbleType == ChatBubbleType.Sender
                    ? Radius.zero
                    : const Radius.circular(15)),
            color: chatBubbleType == ChatBubbleType.Sender
                ? Colors.blue[500]
                : Colors.white,
          ),
          child: IntrinsicWidth(
            child: Row(
              children: [
                Icon(Icons.file_copy,
                    color: chatBubbleType == ChatBubbleType.Sender
                        ? Colors.white
                        : Colors.black),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                        fontSize: 14,
                        color: chatBubbleType == ChatBubbleType.Sender
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(time,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ))
      ],
    );
  }
}
