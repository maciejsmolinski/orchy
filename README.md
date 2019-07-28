# Orchestrator

🤹‍♂️A super simple, opinionated web hooks manager. Built with PureScript.

## Running the server

```shell
$ npm install -g spago purescript@0.13.2
$ spago run
```

The web hooks server will run under [http://localhost:8181](http://localhost:8181)

## Configuring hooks

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

To execute the `main` configuration, open [http://localhost:8181/run?definition=main](http://localhost:8181/run?definition=main) in your browser or run the following in terminal

```
$ curl http://localhost:8181/run?definition=main
```

while the browser will show only the `success` message, the server will give you more feedback

## Feedback

When `configuration.json` file is missing:

```shell
$ spago run

[Err] Failure reading configuration.json
```

When `configuration.json` has a wrong format:

```shell
$ spago run

[Err] Configuration file is not structured properly
Error at array index 0: Error at property "commands": Type mismatch: expected array, found Undefined
```

When selected definition is not present in the configuration:

```shell
$ spago run

[Log] [HTTP/GET] /run?definition=unknown

[Err] Definition with id "unknown" not found
```

When definition exists but one of the commands fails:

```shell
$ spago run

[Log] [HTTP/GET] /run?definition=main

[Log] Running definition "main"

[Log] Executing pwd
/Users/maciejsmolinski/git/orchestrator

[Log] Executing git branch
fatal: not a git repository (or any of the parent directories): .git
Process exited with status code 128

[Err] Execution FAILED
```

Finally, when everything succeeds:

```shell
$ spago run

[Log] [HTTP/GET] /run?definition=main

[Log] Running definition "main"

[Log] Executing pwd
/Users/maciejsmolinski/git/orchestrator

[Log] Executing git branch
* master

[Log] Executing git status
On branch server
nothing to commit, working tree clean

[Log] Execution SUCCEEDED
```

## Local development

```shell
$ spago bundle-app -w
$ npx nodemon index.js
```

Running tests

```shell
$ spago test --watch
```
