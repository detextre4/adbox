// craer tipos especificos
module {
  public type Rapero = Principal;

  public type DataMessage = {
    user: Text;
    img : ?Text;
    message : Text;
  };

  public type UserMessage = {
    img : ?Text;
    message : Text;
  };
};
