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

Executing
* Running pwd
-> (Right "/Users/maciejsmolinski/git/orchestrator")
* Running git branch
-> (Right "* master")
* Running git status
-> (Right "On branch master\nnothing to commit, working tree clean")
Execution SUCCEEDED
```


in case one of the commands fails:

```shell
$ spago run

Executing
* Running pwd
-> (Right "/Users/maciejsmolinski/git/orchestrator")
* Running make configure
Execution FAILED
```
