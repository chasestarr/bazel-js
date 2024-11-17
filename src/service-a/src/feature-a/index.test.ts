import { foo } from "./index";

test("foo works", () => {
  expect(foo("fizz")).toBe("fizz bar");
});
