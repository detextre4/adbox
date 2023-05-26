import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MessageData {}

enum TypeReaction {
  like,
  clap,
  smile;
}

class BubbleMessageWidget extends StatelessWidget {
  const BubbleMessageWidget({
    super.key,
    required this.userID,
    required this.data,
    required this.index,
    required this.addReaction,
    required this.removeReaction,
  });
  final String userID;
  final List data;
  final int index;
  final Future<void> Function({
    required int id,
    required String emoji,
  }) addReaction;
  final Future<void> Function({required int id}) removeReaction;

  @override
  Widget build(BuildContext context) {
    final List currentElement = data[index]?["id"];
    final int? id = (currentElement.elementAtOrNull(0) as BigInt?)?.toInt();
    final List reactions = data[index]["reactions"];
    final userReaction =
        reactions.singleWhereOrNull((element) => element["user"] == userID);
    final bool haveReactions = userReaction != null;

    final currentReaction = TypeReaction.values
        .singleWhereOrNull((element) => element.name == userReaction?["emoji"]);

    final dataReactionIcons = <Map<String, dynamic>>[
      {
        "type": TypeReaction.like,
        "icon": const Icon(Icons.thumb_up_outlined),
        "activeIcon": const Icon(Icons.thumb_up),
      },
      {
        "type": TypeReaction.smile,
        "icon": const Icon(Icons.sentiment_very_satisfied_outlined),
        "activeIcon": const Icon(Icons.tag_faces_rounded),
      },
      {
        "type": TypeReaction.clap,
        "icon": const Icon(Icons.soap_outlined),
        "activeIcon": const Icon(Icons.soap_rounded),
      },
    ];

    return Column(
      children: [
        Row(
          children: [
            if (data[index]["user"] == userID || id == null)
              const Expanded(child: SizedBox.shrink()),
            Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: 50,
                decoration: BoxDecoration(
                  color: id == null
                      ? Colors.amber[900]
                      : data[index]["user"] == userID
                          ? Colors.blueAccent
                          : Colors.brown,
                  borderRadius: BorderRadius.circular(20),
                ),
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
                ]))),
            if (data[index]["user"] != userID || id == null)
              const Expanded(child: SizedBox.shrink()),
          ],
        ),
        if (id != null)
          Transform.translate(
            offset: const Offset(0, -7),
            child: Row(children: [
              if (data[index]["user"] == userID)
                const Expanded(child: SizedBox.shrink()),
              ...dataReactionIcons.map((element) {
                final currentReactions = reactions.where((e) =>
                    e["emoji"] == (element["type"] as TypeReaction).name);

                return Badge(
                  label: currentReactions.isEmpty
                      ? null
                      : Text(currentReactions.length.toString()),
                  backgroundColor:
                      currentReactions.isEmpty ? Colors.transparent : null,
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(left: 8),
                    child: FloatingActionButton(
                        backgroundColor: currentReaction == element["type"]
                            ? null
                            : Colors.white,
                        foregroundColor: const Color.fromARGB(197, 0, 19, 26),
                        onPressed: () async => haveReactions &&
                                currentReaction == element["type"]
                            ? await removeReaction(id: id)
                            : await addReaction(
                                id: id,
                                emoji: (element["type"] as TypeReaction).name,
                              ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: currentReaction == element["type"]
                                ? element["activeIcon"]
                                : element["icon"],
                          ),
                        )),
                  ),
                );
              }),
              if (data[index]["user"] != userID)
                const Expanded(child: SizedBox.shrink()),
            ]),
          )
      ],
    );
  }
}

//! unused
Future<String?> showPopup(
  BuildContext context,
  Map<String, IconData> items,
) async {
  //*get the render box from the context
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //*get the global position, from the widget local position
  final offset = renderBox.localToGlobal(Offset.zero);

  //*calculate the start point in this case, below the button
  final left = offset.dx;
  final top = offset.dy + renderBox.size.height;
  //*The right does not indicates the width
  final right = left + renderBox.size.width;

  return await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, 0.0),
      items: items.entries.map<PopupMenuEntry<String>>((entry) {
        return PopupMenuItem(
          value: entry.key,
          child: SizedBox(
            // width: 200, //*width of popup
            child: Row(
              children: [
                Icon(entry.value, color: Colors.redAccent),
                const SizedBox(width: 10.0),
                Text(entry.key)
              ],
            ),
          ),
        );
      }).toList());
}
