exports.startSync_ = function startSync_(port, onSuccess) {
    var http = require('http');
    var server = http.createServer(function(req, res) {
        onSuccess(req.url)();
        res.end('success');
    });
    server.listen(port);
}

exports.startAsync_ = function startAsync_(port) {
    return function(onError, onSuccess) {
        var http = require('http');
        var server = http.createServer(function(req, res) {
            onSuccess(req.url);
            res.end('success');
        });
        server.on('error', onError);
        server.listen(port);
    }
}
