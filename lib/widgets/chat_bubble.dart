import 'package:flutter/material.dart';

enum ChatBubbleType { Sender, Receiver }

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final ChatBubbleType chatBubbleType;

  const ChatBubble(
      {Key? key,
      required this.message,
      required this.chatBubbleType,
      required this.time})
      : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft: chatBubbleType == ChatBubbleType.Receiver
                  ? Radius.zero
                  : const Radius.circular(15),
              bottomRight: chatBubbleType == ChatBubbleType.Sender
                  ? Radius.zero
                  : const Radius.circular(15),
            ),
            color: chatBubbleType == ChatBubbleType.Sender
                ? Colors.blue[500]
                : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: chatBubbleType == ChatBubbleType.Sender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.85),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: chatBubbleType == ChatBubbleType.Sender
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          time,
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
      ],
    );
  }
}
