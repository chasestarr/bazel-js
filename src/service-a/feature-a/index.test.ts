import { foo } from "./index";

test("foo works", () => {
  expect(foo("fizz")).toBe("fizz bar");
});

test("another", () => {
  expect(foo("fizz")).toBe("fizz bar");
  // fails ts typecheck, but vitest has no complaints
  // expect(foo(2)).toBe("fizz bar");
});
