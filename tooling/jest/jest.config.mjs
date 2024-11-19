import path from 'node:path';

export default {
  setupFiles: [path.join(process.cwd(), "tooling/jest/jest-env.js")],
  testEnvironment: "node",
  transformIgnorePatterns: ['node_modules\/(?!@org|\.aspect_rules_js\/@org)'],
  transform: { '^.+\\.(t|j)sx?$': '@swc/jest' },
};
