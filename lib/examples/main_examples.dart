import 'package:adbox/examples/counter_example.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:flutter/material.dart';

// import Counter class with canister call

void main() {
  runApp(const MyAppExample());
}

class MyAppExample extends StatelessWidget {
  const MyAppExample({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePageExample(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePageExample extends StatefulWidget {
  const MyHomePageExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageExampleState createState() => _MyHomePageExampleState();
}

class _MyHomePageExampleState extends State<MyHomePageExample> {
  int _counter = 0;
  bool _loading = false;
  // setup state class variable;
  CounterExample? counter;

  @override
  void initState() {
    initCounter();
    super.initState();
  }

  Future<void> initCounter({Identity? identity}) async {
    // initialize counter, change canister id here
    counter = CounterExample(
        canisterId: 'sgymv-uiaaa-aaaaa-aaaia-cai',
        url: 'http://localhost:8000');
    // set agent when other paramater comes in like new Identity
    await counter?.setAgent(newIdentity: identity);
    await getValue();
  }

  // get value from canister
  Future<void> getValue() async {
    var counterValue = await counter?.getValue();
    setState(() {
      _counter = counterValue ?? _counter;
      _loading = false;
    });
  }

  // increment counter
  Future<void> _incrementCounter() async {
    setState(() {
      _loading = true;
    });
    await counter?.increment();
    await getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'The canister counter is now:',
            ),
            Text(
              _loading ? 'loading...' : '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
