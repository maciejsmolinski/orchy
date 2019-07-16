var spawnSync = require('child_process').spawnSync;



exports.syncExec_ = function(success, error) {
    return function(command, args) {
        return function() {
            var process = spawnSync(command, args);
            var output;
            var program;

            if (process.status === 0) {
                output = process.stdout
                    ? process.stdout.toString().trim()
                    : '';

                return success(output);
            }

            program = [command].concat(args).join(' ')

            return error(
                'Program "' + program + '" exited with code "' + process.error.code + '"'
            );

        }
    }
}
