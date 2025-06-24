const fs = require("node:fs");
const path = require("node:path");
const esbuild = require("esbuild");

const entrypoint = path.join(__dirname, "entrypoint.ts");
const outfile = path.join(__dirname, "lib.js");

const args = {
  "bundle":true,
  "define":{},
  "entryPoints":[entrypoint],
  "external":[],
  "ignoreAnnotations":true,
  "logLevel":"warning",
  "logLimit":0,
  "metafile":false,
  "outfile":outfile,
  "platform":"browser",
  "preserveSymlinks":false,
  "sourcemap":"linked",
  "sourcesContent":false,
  "target":"es2015",
  // missing when not running with rules_esbuild
  // "tsconfig":"external/aspect_rules_esbuild+/esbuild/private/empty.json"
};

esbuild.build(args);

console.log(fs.readFileSync(outfile, "utf-8"));
