import 'package:adbox/adbox_canister.dart';
import 'package:adbox/bubble_message_widget.dart';
import 'package:adbox/chat_bar_widget.dart';
import 'package:adbox/public_bar_widget.dart';
import 'package:adbox/utils/responsive_layout.dart';
import 'package:agent_dart/agent/agent.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADBox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ADBox Project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final adBoxCanister = ADBoxCanister();
  final adBox = [];
  String userID = "";
  String userIDCopy = "";
  bool changedUserID = false;

  @override
  void initState() {
    initAgent(isMainnet: true);
    super.initState();
  }

  Future<void> initAgent({bool isMainnet = false, Identity? identity}) async {
    // set agent when other paramater comes in like new Identity
    await adBoxCanister.setAgent(newIdentity: identity, isMainnet: isMainnet);
    final value = await adBoxCanister.getUserID();
    userID = value;
    userIDCopy = value;
    await _getMessage();
  }

  Future<void> _getMessage() async {
    adBox.clear();
    adBox.addAll(await adBoxCanister.getMessages());
    setState(() {});
  }

  Future<void> _sendMessage({
    String nickname = "",
    required String message,
    String img = "",
  }) async {
    await adBoxCanister.sendMessage(
      nickname: nickname,
      message: message,
      img: img,
    );
    await _getMessage();
  }

  Future<void> _addReaction({required int id, required String emoji}) async {
    await adBoxCanister.addPublicReaction(id: id, emoji: emoji);
    await _getMessage();
  }

  Future<void> _removeReaction({required int id}) async {
    await adBoxCanister.removePublicReaction(id: id);
    await _getMessage();
  }

  Future<void> _clearMessages() async {
    await adBoxCanister.clearBattleBox();
    await _getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ResponsiveLayout(
        //* mobile
        tablet: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Message in box are:'),
                const Divider(height: 30),
                Expanded(
                    child: ListView.separated(
                  itemCount: adBox.length,
                  itemBuilder: (context, index) => BubbleMessageWidget(
                    userID: userID,
                    data: adBox,
                    index: index,
                    addReaction: _addReaction,
                    removeReaction: _removeReaction,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                )),
                const SizedBox(height: 20),
                ChatBarWidget(
                  userID: userID,
                  sendMessage: _sendMessage,
                ),
              ]),
        ),
        //* web
        desktop: Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 40),
          child: Row(children: [
            const PublicBarWidget(),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Message in box are:'),
                    const Divider(height: 30),
                    Expanded(
                        child: ListView.separated(
                      itemCount: adBox.length,
                      itemBuilder: (context, index) => BubbleMessageWidget(
                        userID: userID,
                        data: adBox,
                        index: index,
                        addReaction: _addReaction,
                        removeReaction: _removeReaction,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                    )),
                    const SizedBox(height: 20),
                    ChatBarWidget(
                      userID: userID,
                      sendMessage: _sendMessage,
                    ),
                  ]),
            ),
          ]),
        ),
      ),
      floatingActionButtonLocation: ScreenSizes.isTablet(context)
          ? FloatingActionButtonLocation.startTop
          : FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: _clearMessages,
            tooltip: 'clear message',
            child: const Icon(Icons.cleaning_services),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              userID = changedUserID ? userIDCopy : "pedrito";
              changedUserID = !changedUserID;
              setState(() {});
            },
            tooltip: 'change user',
            child: const Icon(Icons.person_2),
          ),
        ],
      ),
    );
  }
}
