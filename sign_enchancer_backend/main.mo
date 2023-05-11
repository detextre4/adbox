import Map "mo:base/HashMap";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import AList "mo:base/AssocList";
import List "mo:base/List";
import Nat "mo:base/Nat";
import AssocList "mo:base/AssocList";
import Stack "mo:base/Stack";
import Trie "mo:base/TrieMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Char "mo:base/Char";

actor SignEnhancer {
  type Nickname = Text;

  // Dictionary of signs
  let replacementWords = Map.HashMap<Text, Char>(0, Text.equal, Text.hash);

  // Adding values to collection
  replacementWords.put("❗", '!');
  replacementWords.put("❕", '¡');
  replacementWords.put("❓", '?');
  replacementWords.put("❔", '¿');
  replacementWords.put("♾️", '0');
  replacementWords.put("➕", '+');
  replacementWords.put("➖", '-');
  replacementWords.put("➗", '/');
  replacementWords.put("❌", 'x');
  replacementWords.put("〰️", '~');
  replacementWords.put("❄️", '*');
  replacementWords.put("✨", '°');
  replacementWords.put("✏️", '|');
  replacementWords.put("💲", '$');
  replacementWords.put("©️", 'c');
  replacementWords.put("🇻🇪", 'v');
  replacementWords.put("🇲🇽", 'm');
  replacementWords.put("🇦🇷", 'a');
  replacementWords.put("🇸🇻", 's');

  /// Private function to get id of caller.
  func getID(msg : {caller : Principal}) : Text {
    return Principal.toText(msg.caller);
  };

  /// Function to return an enchanced text.
  public shared(msg) func generateEnchancedText(nickname : ?Nickname, text: Text) : async Text {
    // user declaration
    let user : Text = switch nickname {
      case(null) getID(msg);
      case(?value) value;
    };

    // result declaration
    let result : Text = do {
      if (text == "") "nothing 😥"
      else {
        // initialize variable
        var enchanced : Text = text;
        // loop to directionary collection.
        for ((replacement, char) in replacementWords.entries()) {
          // replace all register signs.
          enchanced := Text.replace(enchanced, #char char, replacement);
        };
        enchanced;
      }
    };

    // return enchanced message.
    "signs generated to " # user # ":  " # result;
  };


  /// Function to get symbol's collection.
  public query func getSymbols() : async [Text] {
    Iter.toArray(replacementWords.keys());
  };


  /// Function to get length of symbol's collection.
  public query func getNumberOfSymbols() : async Nat {
    replacementWords.size();
  };


  // public func updateSymbol(replacement: Text, char: Char) : async Text {
  //   replacementWords.put(replacement, char);
  //   return "Symbol updated successfully!";
  // };


  // public func addNewSymbol(replacement: Text, char: Char) : async Text {
  //   for ((replacement, value) in replacementWords.entries()) {
  //     if (value == char) return "Value " # Text.fromChar(char) # " already exists!";
  //   };

  //   replacementWords.put(replacement, char);
  //   return "Symbol added successfully!";
  // };


  // public func removeReplacementWord(char: Char) : async Text {
  //   for ((replacement, value) in replacementWords.entries()) {
  //     if (value == char) {
  //       replacementWords.remove(replacement);
  //       return "Value " # Text.fromChar(char) # " removed successfully!";
  //     }
  //   };
  //   return "Value " # Text.fromChar(char) # " not found!";
  // }
};
