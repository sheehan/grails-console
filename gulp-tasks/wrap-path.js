import through from 'through2';
import path from 'path';

export default function wrapPath(relativeDir, fcn) {
    return through.obj(function (file, encoding, callback) {
        const requirePath = path.relative(relativeDir, path.resolve(file.path));
        const tag = fcn(requirePath);
        file.contents = new Buffer(tag);
        return callback(null, file);
    });
};
