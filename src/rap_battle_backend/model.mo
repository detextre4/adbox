import Option "mo:base/Option";

// craer tipos especificos
module {
  public type Rapero = Principal;

  public type DataMessage = {
    id : ?Nat;
    user : Text;
    img : ?Text;
    message : Text;
    reactions : [PublicReaction];
  };

  public type UserMessage = {
    img : ?Text;
    message : Text;
  };

  public type PublicReaction = {
    user : Text;
    emoji : Text;
  };
};
