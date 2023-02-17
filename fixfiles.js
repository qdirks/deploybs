const fs = require("fs");

(async function() {


    // read the browser-sync/package.json file, and update the client and ui deps to ref my git branches
    const fileName = "packages/browser-sync/package.json";
    let res, promise = new Promise(r_=>res=r_);
    fs.readFile(fileName, (err, buf)=>{
        const obj = JSON.parse(buf.toString());
        obj.dependencies["browser-sync-client"] = "https://github.com/qdirks/browser-sync.git#browser-sync-client";
        obj.dependencies["browser-sync-ui"] = "https://github.com/qdirks/browser-sync.git#browser-sync-ui";
        let writeStr = JSON.stringify(obj, void 0, '\t');
        if (writeStr.indexOf('\r') === -1) writeStr = writeStr.split('\n').join('\r\n');
        fs.writeFile(fileName, writeStr, ()=>{res();});
    });

    await promise;

    // fix line endings
    function fix(fileName) {
        fs.readFile(fileName, (err, buf)=>{
            if (err) {
                console.log("Hey there's an error", err);
                return;
            }
            let writeStr = buf.toString();
            if (writeStr.indexOf('\r') > -1) return console.log(fileName, "already contains crlf...");
            writeStr = writeStr.split('\n').join('\r\n');
            fs.writeFile(fileName, writeStr, ()=>{});
        });
    }

    /**
     * Remove scripts attribute so that npm will not try to rebuild the git dependency (it's already built).
     * See "npm git dependency". Since it could be source code, a feature of npm is to build the package if "build", "prepare", or other special scripts are present
     * @param {string} fileName 
     * @returns {Promise}
     */
    function removePackageScripts(fileName) {
        let res, promise = new Promise((r_)=>res=r_);
        fs.readFile(fileName, (err, buf)=>{
            const obj = JSON.parse(buf.toString());
            delete obj.scripts;
            let writeStr = JSON.stringify(obj, void 0, '\t');
            if (writeStr.indexOf('\r') === -1) writeStr = writeStr.split('\n').join('\r\n');
            fs.writeFile(fileName, writeStr, ()=>{
                res();
            })
        });
        return promise;
    }

    // put it all together
    fix("packages/browser-sync-client/dist/index.js");
    fix("packages/browser-sync-ui/public/js/app.js");
    ["browser-sync", "browser-sync-client", "browser-sync-ui"].forEach(async packageName=>{
        fix("packages/" + packageName + "/package-lock.json");
        removePackageScripts("packages/" + packageName + "/package.json");
    });


})();