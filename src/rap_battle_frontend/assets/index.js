
async function fetchData() {
  const canisterId = "myCanister";
  const methodName = "get";
  const arg = "myArg";

  const { HttpAgent } = require("@dfinity/agent");
  const { Actor, HttpAgent } = require("@dfinity/agent");
  const { idlFactory } = require("./.dfx/local/myCanister.did.js");

  const agent = new HttpAgent();
  const canister = await Actor.createActor(idlFactory, {
    agent,
    canisterId,
  });
  const result = await canister[methodName](arg);
  console.log(result);
}

document.getElementById("boton").addEventListener("onClick", fetchData)
