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

// // Definición del actor de la aplicación de mensajería
// actor Mensajeria {

//   // Definición del registro de mensajes
//   type Mensaje = {
//     remitente : Principal;
//     destinatario : Principal;
//     contenido : Text;
//   };

//   // Registro para el almacenamiento de claves
//   type Claves = {
//     clavePublica : [Nat8];
//     clavePrivada : [Nat8];
//   };

//   // Mapa para almacenar las claves de los usuarios
//   var clavesUsuarios = Map.HashMap<Principal, Claves>(0, Principal.equal, Principal.hash);

//   // Lista para almacenar los mensajes enviados y recibidos
//   var mensajes : [Mensaje] = [];

//   // Función para generar un nuevo par de claves
//   public func generarParDeClaves() : async Claves {
//     let parDeClaves = Sodium.crypto_box_keypair();
//     return {
//       clavePublica = parDeClaves.publicKey;
//       clavePrivada = parDeClaves.secretKey;
//     };
//   };

//   // Función para almacenar las claves de un usuario
//   public func almacenarClaves(claves : Claves) : async Bool {
//     let usuario = msg.caller;
//     clavesUsuarios := clavesUsuarios.put(usuario, claves);
//     return true;
//   };

//   // Función para enviar un mensaje cifrado
//   public func enviarMensaje(destinatario : Principal, contenido : Text) : async Bool {
//     let remitente = msg.caller;
//     if (clavesUsuarios.contains(remitente) | clavesUsuarios.contains(destinatario)) {
//     let clavePublicaDestinatario = clavesUsuarios.getOpt(destinatario).get().clavePublica;
//     let clavePrivadaRemitente = clavesUsuarios.getOpt(remitente).get().clavePrivada;
//     let mensajeCifrado = Sodium.crypto_box(content == encodeUtf8(contenido),
//                                            let nonce = Sodium.randombytes(Sodium.crypto_box_NONCEBYTES),
//                                            let publicKey = clavePublicaDestinatario,
//                                            let secretKey = clavePrivadaRemitente);
//     mensajes := mensajes[{remitente = remitente;
//                            destinatario = destinatario;
//                            contenido = base64_encode(mensajeCifrado)}];
//     return true;
//     };

//     return false;
//   };

//   // Función para recibir mensajes
//   public func recibirMensajes() : async [Mensaje] {
//     let destinatario = msg.caller;
//     let mensajesRecibidos : [Mensaje] = [];
//     for (mensaje in mensajes) {
//       if (mensaje.destinatario == destinatario) {
//         let clavePrivadaDestinatario = clavesUsuarios.getOpt(destinatario).get().clavePrivada;
//         let mensajeDescifrado = Sodium.crypto_box_open(nonce == Sodium.crypto_box_NONCEBYTES,
//                                                         let content = base64_decode(mensaje.contenido),
//                                                         let publicKey = mensaje.remitente,
//                                                         let secretKey = clavePrivadaDestinatario);
//         mensajesRecibidos := mensajesRecibidos[{remitente = mensaje.remitente;
//                                                   destinatario = destinatario;
//                                                   contenido = decodeUtf8(mensajeDescifrado)}];
//       }
//     };
//     return mensajesRecibidos;
//   }
// }
