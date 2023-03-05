import { URL } from "url";

export function pathname(input) {
  var url = new URL(input, "http://localhost");

  return url.pathname;
}

export function param_(param, input) {
  var url = new URL(input, "http://localhost");

  return url.searchParams.get(param) || "";
}
