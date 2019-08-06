# Orchy

🤹‍♂️A simple, opinionated web hooks manager. Built with PureScript.

<img src="https://raw.githubusercontent.com/maciejsmolinski/orchy/master/assets/success.gif" width="650" height="333"/>

## Installation

```
$ npm install -g orchy
```

## Configure web hooks and start the server

Create a `configuration.json` file with the following contents:

```json
[
    {
        "id": "main",
        "dir": ".",
        "secret": "secret-token",
        "commands": [
            "git branch",
            "git status"
        ]
    }
]
```

Now, run the orchy server under [http://localhost:8181](http://localhost:8181)

```shell
$ orchy

Orchy server is running at http://localhost:8181
```

To run it on a different port:

```
$ PORT=8282 orchy

Orchy server is running at http://localhost:8282
```

To execute the `main` configuration, open [http://localhost:8181/run?definition=main&secret=secret-token](http://localhost:8181/run?definition=main&secret=secret-token) in your browser or run the following in terminal

```
$ curl "http://localhost:8181/run?definition=main&secret=secret-token"
```

while the browser will show only a `success` message, the server will give you more feedback

## Feedback from the server

When `configuration.json` file is missing:

```shell
2019/08/05 23:55:40 err Failure reading configuration.json
```

When `configuration.json` has a wrong format:

```shell
2019/08/05 23:56:40 err Configuration file is not structured properly
2019/08/05 23:56:40     Error at array index 0: Error at property "id": Type mismatch: expected String, found Undefined
```

When selected definition is not present in the configuration:

```shell
2019/08/06 23:57:52 log Incoming request /run?definition=unknown&secret=unknown-token
2019/08/06 23:57:52 err Definition with provided id and secret not found
```

When definition exists but one of the commands fails:

```shell
2019/08/06 00:02:20 log Incoming request /run?definition=main&secret=secret-token
2019/08/06 00:02:20 log Running definition "main"
2019/08/06 00:02:20 log Executing git branch
2019/08/06 00:02:20     fatal: not a git repository (or any of the parent directories): .git
2019/08/06 00:02:20     Process exited with status code 128
2019/08/06 00:02:20 err Execution FAILED
```

Finally, when everything succeeds:

```shell
2019/08/06 00:03:30 log Incoming request /run?definition=main&secret=secret-token
2019/08/06 00:03:30 log Running definition "main"
2019/08/06 00:03:30 log Executing git branch
2019/08/06 00:03:30     * master
2019/08/06 00:03:30 log Executing git status
2019/08/06 00:03:30     On branch master
2019/08/06 00:03:30     nothing to commit, working tree clean
2019/08/06 00:03:30 log Execution SUCCEEDED
```

## Local development

```shell
$ npm install -g spago@0.8.5 purescript@0.13.2
$ spago bundle-app -w
$ npx nodemon index.js
```

Running tests

```shell
$ spago test --watch
```
