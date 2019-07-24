function run(command, args, options) {
    var spawnSync = require("child_process").spawnSync;

    var process = spawnSync(command, args, options || {});
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

exports.asyncExec_ = function(
    right,
    left,
    canceler,
    cb,
    command,
    args,
    options
) {
    setTimeout(function() {
        var result = run(command, args, options);

        cb(result[0] ? right(result[1]) : left(new Error(result[1])))();
    });

    return canceler;
};
