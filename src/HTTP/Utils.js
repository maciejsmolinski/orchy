import { URL } from "url";

export function pathname(input) {
  const url = new URL(input, "http://localhost");

  return url.pathname;
}

export function param_(param, input) {
  const url = new URL(input, "http://localhost");

  return url.searchParams.get(param) || "";
}
