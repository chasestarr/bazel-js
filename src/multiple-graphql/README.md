```
bazel run //src/multiple-graphql:graphql_inspector_bin -- diff $(bazel info workspace)/src/multiple-graphql/old.graphql $(bazel info workspace)/src/multiple-graphql/new.graphql
# produces error:

error Error: Cannot use GraphQLObjectType "User" from another module or realm.

Ensure that there is only one instance of "graphql" in the node_modules
directory. If different versions of "graphql" are the dependencies of other
relied on modules, use "resolutions" to ensure only one version is installed.

https://yarnpkg.com/en/docs/selective-version-resolutions

Duplicate "graphql" modules cannot be used at the same time since different
versions may have different capabilities and behavior. The data from one
version used in the function from another could produce confusing and
spurious results.
```

```
cd bazel-bin/src/multiple-graphql/graphql_inspector_bin_/graphql_inspector_bin.runfiles && find . -name "graphql"
# produces:

./_main/node_modules/.aspect_rules_js/@graphql-tools+utils@10.2.1_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-tools+utils@10.8.4_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-inspector+core@6.2.1_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-tools+graphql-file-loader@8.0.1_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-inspector+ci@5.0.6_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-inspector+config@4.0.2_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-inspector+commands@5.0.4_1974688395/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-tools+import@7.0.1_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-typed-document-node+core@3.2.0_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-inspector+diff-command@5.0.8_1974688395/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-inspector+graphql-loader@5.0.1_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/graphql@16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-tools+load@8.0.2_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-tools+schema@10.0.21_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-inspector+git-loader@5.0.1_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-tools+code-file-loader@8.1.2_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-tools+merge@9.0.22_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-inspector+loaders@4.0.5_291858257/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-tools+git-loader@8.0.6_graphql_16.9.0/node_modules/graphql
./_main/node_modules/.aspect_rules_js/@graphql-tools+graphql-tag-pluck@8.3.1_graphql_16.9.0/node_modules/graphql
./_main/src/multiple-graphql/node_modules/graphql
```

We managed to workaround the graphql multiple version issue, but it's
definitely not solved. What was happening is that if two different packages try
to load graphql, they get different instances (because the path is different,
even though they symlink to the same place).

In the PNPM docs https://pnpm.io/9.x/symlinked-node-modules-structure it says
that Node is supposed to traverse the symlinks to resolve this, but it doesn't
seem to be happening (maybe because this is a peer dependency?).

Our workaround was simply to ensure that only 1 package imports graphql. This
means we have to implement our own wrapper around the behavior we are trying to
build in this case use @graphql-inspector/core directly rather than call it
through @graphql-inspector/ci. This is viable this time, but will break down
again in the future.

Installing `node_modules` locally and running through exec seems to work fine:
```
multiple-graphql on main $ pnpm install
multiple-graphql on main $ pnpm exec graphql-inspector diff old.graphql new.graphql

Detected the following changes (1) between schemas:

✖  Field age was removed from object type User
error Detected 1 breaking change
```
