To reproduce failure with rules_esbuild:
```
bazel build //src/esbuild-entrypoint-browser-field-false:lib
```

To reproduce successful run without rules_esbuild:
```
bazel run -- @pnpm//:pnpm --dir $PWD install
pnpm exec esbuild src/esbuild-entrypoint-browser-field-false/entrypoint.ts
```