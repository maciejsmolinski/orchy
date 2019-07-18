var spawnSync = require("child_process").spawnSync;

function run(command, args) {
    var process = spawnSync(command, args);
    var output;
    var program;

    if (process.status === 0) {
        output = process.stdout ? process.stdout.toString().trim() : "";

        return [true, output];
    }

    program = [command].concat(args).join(" ");

    return [
        false,
        'Program "' +
        program +
        '" exited with code "' +
        (process.error && process.error.code) +
        '" and status "' +
        process.status +
        '"'
    ];
}

exports.syncExec_ = function(right, left) {
    return function(command, args) {
        return function() {
            var result = run(command, args);

            return result[0] ? right(result[1]) : left(result[1]);
        };
    };
};

exports.asyncExec_ = function(right, left, canceler, cb, command, args) {
    setTimeout(function() {
        var result = run(command, args);

        cb(result[0] ? right(right(result[1])) : left(result[1]))();
    });

    return canceler;
};
