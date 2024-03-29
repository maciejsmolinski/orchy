import http from "http";

export function startSync_(port, onSuccess) {
  const server = http.createServer(function (req, res) {
    onSuccess(req.url)();
    res.end("success");
  });
  server.listen(port);
}

export function startAsync_(port) {
  return function (onError, onSuccess) {
    const server = http.createServer(function (req, res) {
      onSuccess(req.url);
      res.end("success");
    });
    server.on("error", onError);
    server.listen(port);
  };
}
