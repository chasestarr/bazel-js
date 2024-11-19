load("@aspect_rules_jest//jest:defs.bzl", _jest_test = "jest_test")
load("@aspect_rules_js//npm:defs.bzl", _npm_package = "npm_package")
load("@aspect_rules_swc//swc:defs.bzl", _swc = "swc")
load("@aspect_rules_ts//ts:defs.bzl", _ts_library = "ts_project")
load("@bazel_skylib//lib:partial.bzl", _partial = "partial")
load("@npm//:defs.bzl", _npm_link_all_packages = "npm_link_all_packages")

def ts_library(name, tsconfig = None, **kwargs):
    _ts_library(
        name = name,
        declaration = True,
        source_map = True,
        transpiler = _partial.make(_swc, source_maps = True),
        tsconfig = tsconfig if tsconfig else "//:tsconfig",
        **kwargs
    )

def ts_test(name, embed, test, tsconfig = None):
    lib_name = name + "_library"
    ts_library(
        name = lib_name,
        srcs = [test],
        tsconfig = tsconfig,
        deps = embed + [
            "//:node_modules/@types/jest",
        ],
    )

    _jest_test(
        name = name,
        config = "//tooling/jest:jest_config",
        data = embed + [
            ":" + lib_name,
            "//:node_modules/@swc/jest",
        ],
        fixed_args = [test.replace('.ts', '.js')],
        node_modules = "//:node_modules",
    )

def ts_workspace(srcs, visibility):
    _npm_link_all_packages()

    _npm_package(
        name = "pkg",
        srcs = srcs,
        visibility = visibility,
    )
