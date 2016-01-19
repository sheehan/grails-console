const through   = require('through2');
const path      = require('path');

module.exports = (relativeDir, fcn) => {
    return through.obj(function(file, encoding, callback) {
        var requirePath = path.relative(relativeDir, path.resolve(file.path));
        var tag = fcn(requirePath);
        file.contents = new Buffer(tag);
        return callback(null, file);
    })
};