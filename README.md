# Orchestrator

🤹‍♂️A super simple, opinionated web hooks manager. Built with PureScript.

## Local development

```shell
$ npm install -g spago purescript@0.13.2
$ spago bundle-app -w
$ npx nodemon index.js
```

Running tests

```shell
$ spago test --watch
```

## Defining and executing a plan

Create a `configuration.json` file with the following contents:

```json
[
    {
        "id": "main",
        "dir": ".",
        "secret": "secret",
        "commands": [
            "pwd",
            "git branch",
            "git status"
        ]
    }
]
```

when all commands succeed:

```shell
$ spago run

[Log] Executing pwd
/Users/maciejsmolinski/git/orchestrator

[Log] Executing git branch
* master

[Log] Executing git status
On branch master
nothing to commit, working tree clean

[Log] Execution SUCCEEDED
```

in case one of the commands fails:

```shell
$ spago run

[Log] Executing pwd
/Users/maciejsmolinski/git/orchestrator

[Log] Executing git branch
fatal: not a git repository (or any of the parent directories): .git
Process exited with status code 128

[Err] Execution FAILED
```

when `configuration.json` file is missing:

```shell
$ spago run

[Err] Failure reading configuration.json
```

when `configuration.json` has a wrong format:

```shell
$ spago run

[Err] Configuration file is not structured properly
Error at array index 0: Error at property "commands": Type mismatch: expected array, found Undefined
```

when `configuration.json` does not contain a "main" definition:

```shell
$ spago run

[Err] Definition with id "main" not found
```
