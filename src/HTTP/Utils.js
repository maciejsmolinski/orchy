exports.pathname = function pathname(input) {
    var URL = require('url').URL;
    var url = new URL(input, 'http://localhost');

    return url.pathname;
}

exports.param_ = function param_(param, input) {
    var URL = require('url').URL;
    var url = new URL(input, 'http://localhost');

    return url.searchParams.get(param) || ''
}
