# Orchestrator

🤹‍♂️A super simple, opinionated web hooks manager. Built with PureScript.

## Local development

```shell
$ npm install -g spago purescript@0.13.2
$ spago install
$ spago run --watch
```


## Defining and executing a plan

Create a `configuration.json` file with the following contents:

```json
{
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
(Right "/Users/maciejsmolinski/git/orchestrator")
[Log] Executing git branch
(Right "* master")
[Log] Executing git status
(Right "On branch master\nnothing to commit, working tree clean")
[Log] Execution SUCCEEDED
```


in case one of the commands fails:

```shell
$ spago run

[Log] Executing pwd
(Right "/Users/maciejsmolinski/git/orchestrator")
[Log] Executing make configure
[Err] Execution FAILED
```

when `configuration.json` file is missing:

```shell
$ spago run

[Err] ⚠ Failure reading configuration.json
```

when `configuration.json` has a wrong format:

```shell
$ spago run

[Err] ⚠ Configuration file is not structured properly
```
