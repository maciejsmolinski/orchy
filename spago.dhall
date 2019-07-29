{ name =
    "orchy"
, dependencies =
    [ "effect"
    , "console"
    , "psci-support"
    , "generics-rep"
    , "arrays"
    , "functions"
    , "aff"
    , "simple-json"
    , "strings"
    , "spec"
    , "node-process"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
