import { spawnSync } from "child_process";

function run(command, args, options) {
  var process = spawnSync(command, args, options || {});
  var output;

  if (process.status === 0) {
    output = process.stdout ? process.stdout.toString().trim() : "";

    return [true, output];
  }

  return [
    false,
    "" + process.stderr + "Process exited with status code " + process.status,
  ];
}

export function asyncExec_(right, left, canceler, cb, command, args, options) {
  setTimeout(function () {
    var result = run(command, args, options);

    cb(result[0] ? right(result[1]) : left(new Error(result[1])))();
  });

  return canceler;
}
