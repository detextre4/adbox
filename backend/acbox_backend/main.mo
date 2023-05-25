import M "model";
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
import Random "mo:base/Random";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Error "mo:base/Error";

actor ACBox {
  // ID of the last user (rapper) who called sendMessage()
  var lastUser : Text = "";

  // create message collection (Battle Box)
  let acBox = Buffer.Buffer<M.DataMessage>(0); 

  // commenter's random comment collection
  let randomComments : [M.DataMessage] = [
    {
      id = null;
      user = "commentator";
      img = null;
      message = "jajajaja";
      reactions = [];
    },
    {
      id = null;
      user = "commentator";
      img = null;
      message = "uuuuuh eso dolio";
      reactions = [];
    },
    {
      id = null;
      user = "commentator";
      img = null;
      message = "ni la abuelita lo hubiera dicho mejor";
      reactions = [];
    },
  ];


  /// * Private function to get id of caller.
  func getUserID(msg : {caller : Principal}) : Text {
    Principal.toText(msg.caller);
  };

  /// * Generate a random message and store it in the message list
  func addRandomComment() : async Text {
    // generate random number
    let randomSeed = Random.Finite(await Random.blob());
    let randomNumber : Nat = switch (randomSeed.binomial(Nat8.fromNat(randomComments.size() - 1))) {
      case(?value) Nat8.toNat(value);
      case(null) 0;
    };
    // get commenter message randomly
    let data : M.DataMessage = randomComments.get(randomNumber);

    // add comment to collection
    acBox.add(data);
    "El comentador ha dicho:  " # data.message;
  };


  /// ? Enviar mensaje del rapero.
  public shared(msg) func sendMessage(nickname : ?Text, userMessage : M.UserMessage) : async Text {
    if (userMessage.img == null and userMessage.message == "") throw Error.reject("debe enviar como minimo una imagen o un mensaje");

    // declare user // ! just for showcase
    let user : Text = Option.get<Text>(nickname, getUserID(msg));

    // ids assignment
    let bufferOfIDs = Buffer.clone(acBox);
    bufferOfIDs.filterEntries(func(i, item) = item.id != null);

    // instantiate rapper message
    let data : M.DataMessage = {
      id = ?(bufferOfIDs.size() + 1);
      user = user;
      img = userMessage.img;
      message = userMessage.message;
      reactions = [];
    };

    /// Store the message in the battlebox
    acBox.add(data);


    // * automatic commentator
    // Check if the last rapper who called the function is the same one that is currently calling.
    if (lastUser != "" and lastUser != user) {
      lastUser := user;
      return getUserID(msg) # " ha dicho: " # userMessage.message # "\n y " # (await addRandomComment());
    };

    // update the last registered user (rapper)
    lastUser := user;
    getUserID(msg) # " ha dicho: " # userMessage.message;
  };


  /// ? Get all messages sent by the account.
  public shared(msg) func getUserMessages() : async [M.UserMessage] {
    // Filtrar los mensajes cuyo 'user' coincide con el ID de usuario del llamador
    let userMessages : [M.DataMessage] = Array.filter<M.DataMessage>(
      Buffer.toArray<M.DataMessage>(acBox), func(m) = m.user == getUserID(msg)
    );

    // Convertir los mensajes a instancia de UserMessage
    Array.map<M.DataMessage, M.UserMessage>(userMessages, func(m) =
      {
        img = m.img;
        message = m.message;
      }
    );
  };


  // ? Add public reaction to a rapper's message.
  public shared(msg) func addPublicReaction(id : Nat, emoji : Text) : async Text {
    if (emoji == "") throw Error.reject("Debe enviar un emoji");

    var indexOfDataMessage : ?Nat = null;
    var dataMessage : ?M.DataMessage = null;
    // Find the message that the public chose.
    Buffer.clone(acBox).filterEntries(func(i, item) {
      if (item.id != ?id) return false;
      indexOfDataMessage := ?i;
      dataMessage := ?item;
      return true;
    });

    switch(dataMessage) {
      case(null) throw Error.reject("No se pudo encontrar el id del mensaje");

      case(?message) {
        // create copy of message reaction list
        let buffer = Buffer.Buffer<M.PublicReaction>(0);
        for(item in message.reactions.vals()) {
          buffer.add(item);
        };

        // get reaction index
        var indexOfReaction : ?Nat = null;
        Buffer.clone(buffer).filterEntries(func(i, item) {
          if (item.user != getUserID(msg)) return false;
          indexOfReaction := ?i;
          return true;
        });
        let newReaction : M.PublicReaction = { user = getUserID(msg); emoji = emoji };

        switch(indexOfReaction) {
          case(null) {
            // add public reaction
            buffer.add(newReaction);
          };
          case(?index) { 
            // add / update public reaction
            buffer.put(index, newReaction);
          };
        };

        // replace battlebox message
        let newMessage : M.DataMessage = {
          id = message.id;
          user = message.user;
          img = message.img;
          message = message.message;
          reactions = Buffer.toArray<M.PublicReaction>(buffer);
        };
        acBox.put(Option.get<Nat>(indexOfDataMessage, 0), newMessage);

        getUserID(msg) # " ha reaccionado a " # newMessage.user
      };
    };
  };


  // ? Remover reaccion del publico al mensaje de un rapero.
  public shared(msg) func removePublicReaction(id: Nat) : async Text {
    var indexOfDataMessage : ?Nat = null;
    var dataMessage : ?M.DataMessage = null;
    // Find the message that the public chose.
    Buffer.clone(acBox).filterEntries(func(i, item) {
      if (item.id != ?id) return false;
      indexOfDataMessage := ?i;
      dataMessage := ?item;
      return true;
    });

    switch(dataMessage) {
      case(null) throw Error.reject("No se pudo encontrar el id del mensaje");

      case(?message) {
        // create copy of message reaction list
        let buffer = Buffer.Buffer<M.PublicReaction>(0);
        for(item in message.reactions.vals()) {
          buffer.add(item);
        };
        // get reaction index
        var indexOfReaction : ?Nat = null;
        Buffer.clone(buffer).filterEntries(func(i, item) {
          if (item.user != getUserID(msg)) return false;
          indexOfReaction := ?i;
          return true;
        });
        if (indexOfReaction == null) throw Error.reject("No se pudo encontrar ninguna reaccion para remover");

        // remove reaction from message
        let x = buffer.remove(Option.get<Nat>(indexOfReaction, 0));

        // replace battlebox message
        let newMessage : M.DataMessage = {
          id = message.id;
          user = message.user;
          img = message.img;
          message = message.message;
          reactions = Buffer.toArray<M.PublicReaction>(buffer);
        };
        acBox.put(Option.get<Nat>(indexOfDataMessage, 0), newMessage);

        getUserID(msg) # " ha retirado su reaccion a " # newMessage.user;
      };
    };
  };


  // ? Get values from the battle box.
  public query func getMessages() : async [M.DataMessage] {
    Buffer.toArray<M.DataMessage>(acBox);
  };


  // ? Clear the battle box.
  public func clearBattleBox() : async () {
    lastUser := "";
    acBox.clear();
  };
};
