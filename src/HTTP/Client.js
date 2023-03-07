import https from "https";
import { URL } from "url";

export function post_(url, payload) {
  return function (onError, onSuccess) {
    const parsedUrl = new URL(url);
    const hostname = parsedUrl.hostname;
    const path = parsedUrl.pathname + parsedUrl.search;
    const port =
      parsedUrl.protocol === "https:"
        ? 443
        : parsedUrl.protocol === "http:"
        ? 80
        : parsedUrl.port;

    const request = https.request(
      {
        hostname: hostname,
        path: path,
        port: port,
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
      },
      function (_) {
        onSuccess({});
      }
    );

    request.on("error", onError);
    request.write(payload);
    request.end();

    return function (cancelError, onCancelerError, onCancelerSuccess) {
      request.abort();
      onCancelerSuccess();
    };
  };
}
