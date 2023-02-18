const fs = require("fs");
const transforms = Object.create(null);
function transform(fileName) {
    if (!transforms[fileName]) transforms[fileName] = [];
    return transforms[fileName];
}
transform("packages/browser-sync/package.json").push(
    redirectDependencies
);
transform("packages/browser-sync-client/dist/index.js").push(
    fixLineEndings
);
transform("packages/browser-sync-ui/public/js/app.js").push(
    fixLineEndings
);
["browser-sync-client", "browser-sync-ui", "browser-sync"]
.forEach(packageName=>{
    transform("packages/" + packageName + "/package-lock.json").push(
        fixLineEndings
    );
    transform("packages/" + packageName + "/package.json").push(
        removePackageScripts,
        fixLineEndings
    );
});
Object.keys(transforms).forEach(fileName=>{
    fs.readFile(fileName, (err, buf)=>{
        if (err) return;
        const writeStr = transforms[fileName].reduce((pv, cv)=>{
            return cv(pv);
        }, buf.toString());
        fs.writeFile(fileName, writeStr, ()=>{});
    });
});
function fixLineEndings(str) {
    if (str.indexOf('\r') === -1) return str.split('\n').join('\r\n');
    else return str;
}
function redirectDependencies(str) {
    const obj = JSON.parse(str);
    obj.dependencies["browser-sync-client"] = "https://github.com/qdirks/browser-sync.git#browser-sync-client";
    obj.dependencies["browser-sync-ui"] = "https://github.com/qdirks/browser-sync.git#browser-sync-ui";
    return JSON.stringify(obj, void 0, '\t');
}
function removePackageScripts(str) {
    const obj = JSON.parse(str);
    delete obj.scripts;
    return JSON.stringify(obj, void 0, '\t');
}
