var spawnSync = require('child_process').spawnSync;



exports.syncExec_ = function(success, error) {
    return function(command, args) {
        return function() {
            var process = spawnSync(command, args);
            var output;

            if (process.status === 0) {
                output = process.stdout
                    ? process.stdout.toString().trim()
                    : '';

                return success(output);
            }

            return error('Program exited');

        }
    }
}
