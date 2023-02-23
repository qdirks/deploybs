const fs = require("fs");
const transformsMap = Object.create(null);
/**
 * @param {string} fileName 
 * @returns {function[]}
 */
function getTransforms(fileName) {
    if (!transformsMap[fileName]) transformsMap[fileName] = [];
    return transformsMap[fileName];
}
getTransforms("packages/browser-sync/package.json").push(
    redirectDependencies
);
getTransforms("packages/browser-sync-client/dist/index.js").push(
    fixLineEndings
);
getTransforms("packages/browser-sync-ui/public/js/app.js").push(
    fixLineEndings
);
["browser-sync-client", "browser-sync-ui", "browser-sync"]
.forEach(packageName=>{
    getTransforms("packages/" + packageName + "/package-lock.json").push(
        fixLineEndings
    );
    getTransforms("packages/" + packageName + "/package.json").push(
        removePackageScripts,
        fixLineEndings
    );
});
// apply the transforms to the files
Object.keys(transformsMap).forEach(fileName=>{
    fs.readFile(fileName, (err, buf)=>!err &&
    fs.writeFile(fileName, transformsMap[fileName].reduce(
        (str, tf)=>tf(str), buf.toString()), ()=>{} ));
});
/** @param {string} str */
function fixLineEndings(str) {
    if (str.indexOf('\r') === -1) return str.split('\n').join('\r\n');
    else return str;
}
/** @param {string} str */
function redirectDependencies(str) {
    const obj = JSON.parse(str);
    obj.dependencies["browser-sync-client"] = "https://github.com/qdirks/browser-sync.git#browser-sync-client";
    obj.dependencies["browser-sync-ui"] = "https://github.com/qdirks/browser-sync.git#browser-sync-ui";
    return JSON.stringify(obj, void 0, '\t');
}
/** @param {string} str */
function removePackageScripts(str) {
    const obj = JSON.parse(str);
    delete obj.scripts;
    return JSON.stringify(obj, void 0, '\t');
}
