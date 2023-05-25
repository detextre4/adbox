import 'package:agent_dart/agent_dart.dart';

/// motoko/rust function of the CounterExample canister
/// see ./dfx/local/counter.did
abstract class CounterExampleMethod {
  /// use staic const as method name
  static const increment = "increment";
  static const getValue = "getValue";

  /// you can copy/paste from .dfx/local/canisters/counter/counter.did.js
  static final ServiceClass idl = IDL.Service({
    CounterExampleMethod.getValue: IDL.Func([], [IDL.Nat], ['query']),
    CounterExampleMethod.increment: IDL.Func([], [], []),
  });
}

///
/// CounterExample class, with AgentFactory within
class CounterExample {
  /// AgentFactory is a factory method that creates Actor automatically.
  /// Save your strength, just use this template
  AgentFactory? _agentFactory;

  /// CanisterCator is the actor that make all the request to Smartcontract.
  CanisterActor? get actor => _agentFactory?.actor;
  final String canisterId;
  final String url;

  CounterExample({required this.canisterId, required this.url});

  // A future method because we need debug mode works for local developement
  Future<void> setAgent(
      {String? newCanisterId,
      ServiceClass? newIdl,
      String? newUrl,
      Identity? newIdentity,
      bool? debug}) async {
    _agentFactory ??= await AgentFactory.createAgent(
        canisterId: newCanisterId ?? canisterId,
        url: newUrl ?? url,
        idl: newIdl ?? CounterExampleMethod.idl,
        identity: newIdentity,
        debug: debug ?? true);
  }

  /// Call canister methods like this signature
  /// ```dart
  ///  CanisterActor.getFunc(String)?.call(List<dynamic>) -> Future<dynamic>
  /// ```

  Future<void> increment() async {
    try {
      await actor?.getFunc(CounterExampleMethod.increment)?.call([]);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getValue() async {
    try {
      var res = await actor?.getFunc(CounterExampleMethod.getValue)!([]);
      if (res != null) {
        return (res as BigInt).toInt();
      }
      throw "Cannot get count but $res";
    } catch (e) {
      rethrow;
    }
  }
}