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

actor RapBattle {
  // ID del ultimo usuario (rapero) que llamo a sendMessage()
  var lastUser : Text = "";

  // crear coleccion de mensajes (Battle Box)
  let battleBox = Buffer.Buffer<M.DataMessage>(0); 

  // coleccion de comentarios random
  let randomComments : [M.DataMessage] = [
    {
      id = 0;
      user = "commentator";
      img = null;
      message = "jajajaja";
      reactions = [];
    },
    {
      id = 0;
      user = "commentator";
      img = null;
      message = "uuuuuh eso dolio";
      reactions = [];
    },
    {
      id = 0;
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

  /// * Generar un mensaje aleatorio y almacenarlo en la lista de mensajes
  func addRandomComment() : async Text {
    let randomSeed = Random.Finite(await Random.blob());
    let randomNumber : Nat = switch (randomSeed.binomial(Nat8.fromNat(randomComments.size() - 1))) {
      case(?value) Nat8.toNat(value);
      case(null) 0;
    };
    let data : M.DataMessage = randomComments.get(randomNumber);

    // agregar comentario a la coleccion
    battleBox.add(data);
    "El comentador ha dicho:  " # data.message;
  };


  /// ? Enviar mensaje del rapero.
  public shared(msg) func sendMessage(nickname : ?Text, userMessage : M.UserMessage) : async Text {
    // declarar usuario
    let user : Text = Option.get<Text>(nickname, getUserID(msg));

    // instanciar array con mensaje del rapero
    let data : M.DataMessage = {
      id = battleBox.size() + 1;
      user = user;
      img = userMessage.img;
      message = userMessage.message;
      reactions = [];
    };

    /// Almacenar el mensaje en la lista de mensajes
    battleBox.add(data);

    // validar si el ultimo rapero que llamo la funcion es el mismo que llama actualmente.
    if (lastUser != "" and lastUser != user) {
      lastUser := user;
      return getUserID(msg) # " ha dicho: " # userMessage.message # "\n y " # (await addRandomComment());
    };

    // actualizar el último usuario (rapero) registrado
    lastUser := user;
    getUserID(msg) # " ha dicho: " # userMessage.message;
  };


  /// ? Obtener todos los mensajes enviados por la cuenta.
  public shared(msg) func getUserMessages() : async [M.UserMessage] {
    // Filtrar los mensajes cuyo 'user' coincide con el ID de usuario del llamador
    let userMessages : [M.DataMessage] = Array.filter<M.DataMessage>(
      Buffer.toArray<M.DataMessage>(battleBox), func(m) = m.user == getUserID(msg)
    );

    // Convertir los mensajes a un array de UserMessage
    Array.map<M.DataMessage, M.UserMessage>(userMessages, func(m) =
      {
        img = m.img;
        message = m.message;
      }
    );
  };


  // ? Añadir reaccion del publico al mensaje de un rapero.
  public shared(msg) func addPublicReaction(id : Nat, emoji : Text) : async Text {
    var indexOfDataMessage : ?Nat = null;
    var dataMessage : ?M.DataMessage = null;
    // Encontrar el mensaje que el publico escogio.
    Buffer.clone(battleBox).filterEntries(func(i, item) {
      if (item.id != id) return false;
      indexOfDataMessage := ?i;
      dataMessage := ?item;
      return true;
    });

    switch(dataMessage) {
      case(null) "No se pudo encontrar el id del mensaje";

      case(?message) {
        // crear copia de la lista de reacciones del mensaje
        let buffer = Buffer.Buffer<M.PublicReaction>(0);
        for(item in message.reactions.vals()) {
          buffer.add(item);
        };
        // añadir la reaccion del publico
        buffer.add({
          user = getUserID(msg);
          emoji = emoji
        });

        // reemplazar mensaje de la battleBox
        let newMessage : M.DataMessage = {
          id = message.id;
          user = message.user;
          img = message.img;
          message = message.message;
          reactions = Buffer.toArray<M.PublicReaction>(buffer);
        };
        battleBox.put(Option.get<Nat>(indexOfDataMessage, 0), newMessage);

        getUserID(msg) # " ha reaccionado a " # newMessage.user
      };
    };
  };


  // ? Remover reaccion del publico al mensaje de un rapero.
  public shared(msg) func removePublicReaction(id: Nat) : async Text {
    var indexOfDataMessage : ?Nat = null;
    var dataMessage : ?M.DataMessage = null;
    // Encontrar el mensaje que el publico escogio.
    Buffer.clone(battleBox).filterEntries(func(i, item) {
      if (item.id != id) return false;
      indexOfDataMessage := ?i;
      dataMessage := ?item;
      return true;
    });

    switch(dataMessage) {
      case(null) "No se pudo encontrar el id del mensaje";

      case(?message) {
        // crear copia de la lista de reacciones del mensaje
        let buffer = Buffer.Buffer<M.PublicReaction>(0);
        for(item in message.reactions.vals()) {
          buffer.add(item);
        };
        // obtener indice de la reaccion
        var indexOfReaction : ?Nat = null;
        buffer.filterEntries(func(i, item) {
          if (item.user != getUserID(msg)) return false;
          indexOfReaction := ?i;
          return true;
        });
        // remove reaccion del mensaje
        let x = buffer.remove(Option.get<Nat>(indexOfReaction, 0));

        // reemplazar mensaje de la battleBox
        let newMessage : M.DataMessage = {
          id = message.id;
          user = message.user;
          img = message.img;
          message = message.message;
          reactions = Buffer.toArray<M.PublicReaction>(buffer);
        };
        battleBox.put(Option.get<Nat>(indexOfDataMessage, 0), newMessage);

        getUserID(msg) # " ha retirado su reaccion a " # newMessage.user;
      };
    };
  };


  // ? Obtener valores de la caja de batalla.
  public query func getMessages() : async [M.DataMessage] {
    Buffer.toArray<M.DataMessage>(battleBox);
  };


  // ? Limpiar la caja de batalla.
  public func clearBattleBox() : async () {
    lastUser := "";
    battleBox.clear();
  };
};
