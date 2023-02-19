const fs = require('fs');
const fileName = "packages/browser-sync-ui/public/js/app.js";
fs.readFile(fileName, (err, buf)=>!err &&
fs.writeFile(fileName, fixLineEndings(buf.toString()), ()=>{}));
/** @param {string} str */
function fixLineEndings(str) {
    if (str.indexOf('\r') === -1) return str.split('\n').join('\r\n');
    else return str;
}
