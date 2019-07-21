var fs = require('fs');

exports.readFile_ = function(left, right, filename) {
    return function() {
        try {
            var buffer = fs.readFileSync(filename, { encoding: 'UTF-8' });

            return right(buffer.toString());
        } catch (error) {
            return left(error.message);
        }
    }
}
