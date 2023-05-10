// import Map "mo:base/HashMap";
// import Text "mo:base/Text";
// import Principal "mo:base/Principal";
// import Array "mo:base/Array";
// import Debug "mo:base/Debug";
// import AList "mo:base/AssocList";
// import List "mo:base/List";
// import Nat "mo:base/Nat";
// import AssocList "mo:base/AssocList";
// import Stack "mo:base/Stack";
// import Trie "mo:base/TrieMap";
// import Hash "mo:base/Hash";
// import Iter "mo:base/Iter";

// actor RapBattle {
//   // Creamos tipos especificos
//   type Rapero = Principal;
//   type Publico = Principal;

//   type List<T> = ?(T, List<T>);
//   type AssocList<K, V> = AList.AssocList<K, V>;

//   type DataMessage = {
//     user: Rapero;
//     img : ?Text;
//     message : Text;
//   };

//   type UserMessage = {
//     img : ?Text;
//     message : Text;
//   };


//   //creamos el hashmap para almacenar los memes
//   let battleBox = Trie.TrieMap<Text, UserMessage>(Text.equal, Text.hash);
//   let battleBox2 = Map.HashMap<Principal, UserMessage>(0, Principal.equal, Principal.hash);
//   var battleBox3 : [DataMessage] = [];


//   public shared(msg) func sendMessage(userMessage : UserMessage) : async UserMessage {
//     // definir cuenta del rapero
//     let rapero : Rapero = msg.caller;

//     // almacenar el mensaje en la lista de mensajes
//     battleBox.put(Principal.toText(rapero), userMessage);

//     Debug.print(Nat.toText(battleBox.size()));
//     return userMessage;
//   };

//   public shared(msg) func sendMessages(listUserMessage : [UserMessage]) : async [DataMessage] {
//     // definir cuenta del rapero
//     let rapero : Rapero = msg.caller;

//     // almacenar el mensaje en la lista de mensajes
//     for(item in listUserMessage.vals()) {
//       item.img;
//       // battleBox.put(Principal.toText(rapero) # Nat.toText(count), item);
//       Debug.print(Nat.toText(battleBox3.size()));
//     };
//     battleBox3 := [];
//     // Iter.toArray(battleBox.vals());

//     return listUserMessage;
//   };


//   public shared(msg) func getUserMessages() : async {} {
//     // msg.caller, battleBox.get(msg.caller)
//     let value = battleBox.get(Principal.toText(msg.caller));
//     return {
//       nombre = msg.caller;
//       value
//     };
//   };


//   // public shared(msg) func addRandomComment() : async Unit {
//   //   // generar un mensaje aleatorio y almacenarlo en la lista de mensajes
//   // };

//   public query func getMessages() : async [UserMessage] {
//     return Iter.toArray(battleBox.vals());
//   };

//   public func clearBattleBox() : async () {
//     for (key in battleBox.keys()) {
//       Debug.print(key);
//     };
//   };
// };
