exports.execFn = function(command, args) {
    return function() {
        console.log('(Commands/exec) executing ' + command + ' with args "' + args.join(' ') + '"...');
        console.log('-> ' + command + ' ' + args.join(' '));
        console.log('(Commands/exec) done');
        console.log('done');
    }
}
