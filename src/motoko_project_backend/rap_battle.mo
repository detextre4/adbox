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

actor RapBattle {
  // craer tipos especificos
  type Rapero = Principal;

  type DataMessage = {
    user: Text;
    img : ?Text;
    message : Text;
  };

  type UserMessage = {
    img : ?Text;
    message : Text;
  };

  // crear contador de mensajes random
  var sendMessageCount : Nat = 0;

  // crear coleccion de mensajes (Battle Box)
  let battleBox = Buffer.Buffer<DataMessage>(0); 

  // coleccion de comentarios random
  let randomComments : [DataMessage] = [
    {
      user = "Presenter";
      img = null;
      message = "jajajaja";
    },
    {
      user = "Presenter";
      img = null;
      message = "uuuuuh eso dolio";
    },
    {
      user = "Presenter";
      img = null;
      message = "jaja gafo";
    },
  ];


  /// Private function to get id of caller.
  func getUserID(msg : {caller : Principal}) : Text {
    return Principal.toText(msg.caller);
  };

  var randomNumber : Nat = 0;
  /// Generar un mensaje aleatorio y almacenarlo en la lista de mensajes
  func addRandomComment() : Text {
    let data : DataMessage = randomComments.get(randomNumber);

    // incrementar "numero random" hasta que alcance longitud de comentarios
    if (randomNumber == randomComments.size()) randomNumber := 0
    else randomNumber += 1;

    // agregar comentario a la coleccion
    battleBox.add(data);
    return "El publico ha dicho:  " # data.message;
  };

  /// Enviar mensaje del rapero.
  public shared(msg) func sendMessage(nickname : ?Text, userMessage : UserMessage) : async Text {
    sendMessageCount += 1;

    // instanciar array con mensaje del rapero
    let data : DataMessage = {
      user = switch(nickname) {
        case(?value) value;
        case(null) getUserID(msg);
      };
      img = userMessage.img;
      message = userMessage.message;
    };

    /// Almacenar el mensaje en la lista de mensajes
    battleBox.add(data);

    // validar cada 2 ejecuciones para mensaje del presentador.
    if (sendMessageCount % 2 == 0) {
      return getUserID(msg) # " ha dicho: " # userMessage.message # "\n y " # addRandomComment();
    };

    return getUserID(msg) # " ha dicho: " # userMessage.message;
  };

  /// Obtener todos los mensajes enviados por la cuenta.
  public shared(msg) func getUserMessages() : async [UserMessage] {
    // Filtrar los mensajes cuyo 'user' coincide con el ID de usuario del llamador
    let userMessages = Array.filter<DataMessage>(
      Buffer.toArray<DataMessage>(battleBox), func m = m.user == getUserID(msg)
    );

    // Convertir los mensajes a un array de UserMessage
    let result : [UserMessage] = Array.map<DataMessage, UserMessage>(
      userMessages, func m = { img = m.img; message = m.message }
    );
    return result;
  };


  // Obtener valores de la caja de batalla.
  public query func getMessages() : async [UserMessage] {
    return Iter.toArray(battleBox.vals());
  };

  // Limpiar la caja de batalla.
  public func clearBattleBox() : async () {
    battleBox.clear();
  };
};
