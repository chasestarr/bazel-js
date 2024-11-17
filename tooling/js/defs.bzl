load("@aspect_rules_jest//jest:defs.bzl", _jest_test = "jest_test")
load("@aspect_rules_ts//ts:defs.bzl", _ts_library = "ts_project")

# def ts_library(name, tsconfig = None, **kwargs):
#     _ts_library(
#         name = name,
#         tsconfig = tsconfig if tsconfig else "//:tsconfig",
#         declaration = True,
#         source_map = True,
#         transpiler = "tsc",
#         **kwargs
#     )

#     _ts_library(
#         name = name + "_cjs",
#         tsconfig = tsconfig if tsconfig else "//:tsconfig",
#         declaration = True,
#         source_map = True,
#         out_dir = "cjs",
#         transpiler = "tsc",
#         args = [
#             "--target",
#             "es5",
#             "--module",
#             "commonjs",
#         ],
#         **kwargs
#     )

# def ts_test(name, config, deps, test, tsconfig = None, **kwargs):
#     lib_name = name + "_lib"
#     ts_library(
#         name = lib_name,
#         srcs = [test],
#         tsconfig = tsconfig,
#         testonly = True,
#         deps = deps + [
#             "//:node_modules/@types/jest",
#         ],
#         **kwargs
#     )
#     _jest_test(
#         name = name,
#         config = config,
#         data = [
#             ":library_cjs",
#             ":" + lib_name + "_cjs",
#         ],
#         node_modules = "//:node_modules",
#     )

def ts_library(name, esm = True, tsconfig = None, **kwargs):
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

def ts_test(name, config, deps, test, tsconfig = None, **kwargs):
    lib_name = name + "_lib_cjs"
    ts_library(
        name = lib_name,
        srcs = [test],
        tsconfig = tsconfig,
        testonly = True,
        esm = False,
        deps = deps + [
            "//:node_modules/@types/jest",
        ],
        **kwargs
    )

    _jest_test(
        name = name,
        config = config,
        data = deps + [
            ":" + lib_name,
        ],
        node_modules = "//:node_modules",
    )
