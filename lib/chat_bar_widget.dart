import 'package:flutter/material.dart';

class ChatBarWidget extends StatelessWidget {
  ChatBarWidget({
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
              onPressed: () =>
                  sendMessage(nickname: userID, message: controller.text),
              icon: const Icon(Icons.send,
                  color: Color.fromARGB(255, 209, 204, 204)),
            ),
          )),
      onSubmitted: (value) => sendMessage(nickname: userID, message: value),
    );
  }
}
