# Orchestrator

🤹‍♂️A super simple, opinionated web hooks manager. Built with PureScript.

## Local development

```shell
$ npm install -g spago purescript@0.13.2
$ spago install
$ spago run --watch
```

Running tests

```
spago test --watch
```

## Defining and executing a plan

Create a `configuration.json` file with the following contents:

```json
{
    "id": "first",
    "dir": ".",
    "secret": "secret",
    "commands": [
        "pwd",
        "git branch",
        "git status"
    ]
}

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
Program "git branch" exited with code "undefined" and status "128"

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
```
