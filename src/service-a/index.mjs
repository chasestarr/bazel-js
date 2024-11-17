import assert from "node:assert";
import { addOne } from "../../src/@org/add-one/index.js";
import { addTwo } from "../../src/@org/add-two/index.js";

function main() {
  const value = addOne(1) * addTwo(2);
  assert.strictEqual(value, 8);

  console.log(value);
  console.log(process.cwd());
}

main();
