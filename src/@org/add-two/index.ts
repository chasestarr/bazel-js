import { addOne } from "@org/add-one";
export function addTwo(n: number) {
  return addOne(addOne(n));
}
