import 'package:flutter/material.dart';

class ChatBarWidget extends StatefulWidget {
  const ChatBarWidget({
    super.key,
    required this.userID,
    required this.sendMessage,
  });
  final String userID;
  final Future Function({
    String nickname,
    required String message,
    String img,
  }) sendMessage;

  @override
  State<ChatBarWidget> createState() => _ChatBarWidgetState();
}

class _ChatBarWidgetState extends State<ChatBarWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: Colors.blueGrey,
          contentPadding: const EdgeInsets.all(25),
          suffixIcon: Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => widget.sendMessage(
                  nickname: widget.userID, message: controller.text),
              icon: const Icon(Icons.send,
                  color: Color.fromARGB(255, 209, 204, 204)),
            ),
          )),
      onSubmitted: (value) =>
          widget.sendMessage(nickname: widget.userID, message: value),
    );
  }
}
