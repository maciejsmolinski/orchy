import https from "https";
import { URL } from "url";

export function post_(url, payload) {
  return function (onError, onSuccess) {
    var parsedUrl = new URL(url);
    var hostname = parsedUrl.hostname;
    var path = parsedUrl.pathname + parsedUrl.search;
    var port =
      parsedUrl.protocol === "https:"
        ? "443"
        : parsedUrl.protocol === "http:"
        ? 80
        : parsedUrl.port;

    var request = https.request(
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
