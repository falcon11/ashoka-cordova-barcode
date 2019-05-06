var exec = require('cordova/exec');

/**
 * 
 * @param {Object} options 
 * @param {string} options.imageType
 * @param {string} options.uri
 * @param {string} options.base64
 * @param {*} success 
 * @param {*} error 
 */
function readBarcode(options, success, error) {
    exec(success, error, 'ASCDVBarcode', 'readBarcode', [options]);
}
function scanBarcode(success, error) {
    exec(success, error, 'ASCDVBarcode', 'scanBarcode', []);
}
exports.readBarcode = readBarcode;
exports.scanBarcode = scanBarcode;
