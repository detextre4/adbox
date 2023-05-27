import 'package:agent_dart/agent_dart.dart';
import 'package:flutter/foundation.dart';

/// motoko/rust function of the ADBoxCanister canister
/// see ./dfx/local/adbox_backend/adbox_backend.did
abstract class ADBoxMethod {
  /// use staic const as method name
  static const getUserID = "getUserID";
  static const addPublicReaction = "addPublicReaction";
  static const clearBattleBox = "clearBattleBox";
  static const getMessages = "getMessages";
  static const removePublicReaction = "removePublicReaction";
  static const sendMessage = "sendMessage";

  /// you can copy/paste from .dfx/local/canisters/adbox_backend/adbox_backend.did.js
  static final ServiceClass idl = IDL.Service({
    ADBoxMethod.getUserID: IDL.Func([], [IDL.Text], []),
    ADBoxMethod.addPublicReaction: IDL.Func([IDL.Nat, IDL.Text], [], []),
    ADBoxMethod.clearBattleBox: IDL.Func([], [], []),
    ADBoxMethod.getMessages: IDL.Func([], [
      IDL.Vec(IDL.Record({
        'id': IDL.Opt(IDL.Nat),
        'img': IDL.Opt(IDL.Text),
        'user': IDL.Text,
        'message': IDL.Text,
        'reactions': IDL.Vec(IDL.Record({'user': IDL.Text, 'emoji': IDL.Text})),
      }))
    ], [
      'query'
    ]),
    ADBoxMethod.removePublicReaction: IDL.Func([IDL.Nat], [], []),
    ADBoxMethod.sendMessage: IDL.Func([IDL.Text, IDL.Text, IDL.Text], [], []),
  });
}

//* URLs:
//* local: http://127.0.0.1:4943/?canisterId=bw4dl-smaaa-aaaaa-qaacq-cai&id=br5f7-7uaaa-aaaaa-qaaca-cai
//* ic: https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.icp0.io/?id=ffy5o-bqaaa-aaaag-abphq-cai

/// ADBoxCanister class, with AgentFactory within
class ADBoxCanister {
  /// AgentFactory is a factory method that creates Actor automatically.
  /// Save your strength, just use this template
  AgentFactory? _agentFactory;

  /// CanisterActor is the actor that make all the request to Smartcontract.
  CanisterActor? get actor => _agentFactory?.actor;

  // A future method because we need debug mode works for local developement
  Future<void> setAgent({
    String? newCanisterId,
    ServiceClass? newIdl,
    String? newUrl,
    Identity? newIdentity,
    bool isMainnet = false,
  }) async {
    _agentFactory ??= await AgentFactory.createAgent(
      canisterId: newCanisterId ??
          (isMainnet
              ? "ffy5o-bqaaa-aaaag-abphq-cai"
              : "br5f7-7uaaa-aaaaa-qaaca-cai"),
      url: newUrl ??
          (isMainnet
              ? "https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.icp0.io"
              : "http://127.0.0.1:4943"),
      idl: newIdl ?? ADBoxMethod.idl,
      identity: newIdentity,
      debug: !isMainnet,
    );
  }

  /// Call canister methods like this signature
  /// ```dart
  ///  CanisterActor.getFunc(String)?.call(List<dynamic>) -> Future<dynamic>
  /// ```

  Future<String> getUserID() async {
    try {
      return await actor?.getFunc(ADBoxMethod.getUserID)?.call([]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPublicReaction({
    required int id,
    required String emoji,
  }) async {
    try {
      await actor?.getFunc(ADBoxMethod.addPublicReaction)?.call([id, emoji]);
      debugPrint("reaction added ⭐");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removePublicReaction({required int id}) async {
    try {
      await actor?.getFunc(ADBoxMethod.removePublicReaction)?.call([id]);
      debugPrint("reaction removed ⭐");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage({
    String nickname = "",
    required String message,
    String img = "",
  }) async {
    try {
      await actor
          ?.getFunc(ADBoxMethod.sendMessage)
          ?.call([nickname, message, img]);
      debugPrint("message sended ⭐");
    } catch (e) {
      rethrow;
    }
  }

  Future<List> getMessages() async {
    try {
      final res = await actor?.getFunc(ADBoxMethod.getMessages)!([]);
      debugPrint("data messages: $res ⭐");

      if (res != null) return res;

      throw "Cannot get count but $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearBattleBox() async {
    try {
      await actor?.getFunc(ADBoxMethod.clearBattleBox)?.call([]);
      debugPrint("messages cleared ⭐");
    } catch (e) {
      rethrow;
    }
  }
}
