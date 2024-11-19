load("@aspect_rules_jest//jest:defs.bzl", _jest_test = "jest_test")
load("@aspect_rules_ts//ts:defs.bzl", _ts_library = "ts_project")
load("@fremtind_rules_vitest//vitest:defs.bzl", _vitest_test = "vitest_test")

def ts_library_internal(name, esm = True, tsconfig = None, **kwargs):
    args = []
    out_dir = None
    if (esm == False):
        args.extend([
            "--target",
            "es5",
            "--module",
            "commonjs",
        ])
        out_dir = "cjs"

    _ts_library(
        name = name,
        args = args,
        declaration = True,
        out_dir = out_dir,
        source_map = True,
        transpiler = "tsc",
        tsconfig = tsconfig if tsconfig else "//:tsconfig",
        **kwargs
    )

def ts_library(name, tsconfig = None, **kwargs):
    ts_library_internal(
        name = name,
        tsconfig = tsconfig,
        **kwargs
    )

    ts_library_internal(
        name = name + "_cjs",
        esm = False,
        tsconfig = tsconfig,
        **kwargs
    )

def ts_test_comp(name, config, deps, data, embed, srcs, test, tsconfig = None):
    lib_name = name + "_library"
    ts_library(
        name = lib_name,
        srcs = srcs,
        tsconfig = tsconfig,
        deps = deps + [
            "//:node_modules/@types/jest",
        ],
    )

    _jest_test(
        name = name,
        config = config,
        data = data + [
            ":" + lib_name + "_cjs",
        ],
        fixed_args = [test],
        node_modules = "//:node_modules",
    )

def ts_test(name, config, data, test, tsconfig = None, **kwargs):
    _jest_test(
        name = name,
        config = config,
        data = data,
        fixed_args = [test],
        node_modules = "//:node_modules",
    )

def ts_vitest(name, config, data, test, tsconfig = None, **kwargs):
    _vitest_test(
        name = name,
        config = config,
        data = data + [test],
        fixed_args = [test],
        node_modules = "//:node_modules",
    )
