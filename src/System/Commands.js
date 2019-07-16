exports.syncExec_ = function(success, error) {
    return function(command, args) {
        var pretty = [command].concat(args).join(' ');

        return function() {
            console.log('(System.Commands/syncExec) executing command');
            console.log('-> ' + pretty);
            console.log('(System.Commands/syncExec) done');
            return success('success');
        }
    }
}
