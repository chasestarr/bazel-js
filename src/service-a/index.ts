import { addOne } from "@org/add-one";
import { addTwo } from "@org/add-two";

export function fizz() {
  const value = addOne(1) * addTwo(2);
  return value;
}
