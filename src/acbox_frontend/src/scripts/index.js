import { acbox_backend } from "../../../declarations/acbox_backend";
import { sign_enchancer_backend } from "../../../declarations/sign_enchancer_backend";

document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  console.log("ejecutnado");

  const button = e.target.querySelector("button");

  const name = document.getElementById("name").value.toString();

  button.setAttribute("disabled", true);


  // Interact with foo actor, calling the greet method
  const acBox = await acbox_backend.getUserMessages();
  console.log(acBox);

  button.removeAttribute("disabled");

  document.getElementById("greeting").innerText = acBox;

  console.log("fin ejecucion");
  return false;
});
