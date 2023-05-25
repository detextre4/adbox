import 'package:flutter/material.dart';

class MessageData {}

class BubbleMessageWidget extends StatelessWidget {
  const BubbleMessageWidget(this.data, this.index, {super.key});
  final List data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(maxHeight: 50),
      decoration: BoxDecoration(
        color: index % 2 != 1 ? Colors.blueAccent : Colors.brown,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned.fill(
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "${data[index]["user"]}:   ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight)),
              TextSpan(
                  text: data[index]["message"],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ])),
          ),
          Positioned(
            right: 0,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.accessible_forward_sharp)),
          )
        ],
      ),
    );
  }
}
