import { addOne } from "../../../src/@org/add-one/index.js";
export function addTwo(n) {
  return addOne(addOne(n));
}
