After adding a dependency: `bazel run -- @pnpm//:pnpm --dir $PWD install --lockfile-only`

Run all tests: `bazel test //...`

Print test logs `bazel test //... --test_output=streamed`
