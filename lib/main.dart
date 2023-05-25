import 'package:adbox/adbox_canister.dart';
import 'package:adbox/bubble_message_widget.dart';
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

  Future<void> initCanister({Identity? identity}) async {
    // set agent when other paramater comes in like new Identity
    await adBoxCanister.setAgent(newIdentity: identity);
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

  Future<void> _clearMessages() async {
    await adBoxCanister.clearBattleBox();
    await _getMessage();
  }

  @override
  void initState() {
    initCanister();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Message in box are:'),
            const Divider(height: 30),
            Expanded(
                child: ListView.separated(
              itemCount: adBox.length,
              itemBuilder: (context, index) =>
                  BubbleMessageWidget(adBox, index),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
            )),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _sendMessage(message: "holasd"),
            tooltip: 'send message',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: _clearMessages,
            tooltip: 'clear message',
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
