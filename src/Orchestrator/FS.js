import * as fs from "fs";

export function readFile_(left, right, filename) {
  return function () {
    try {
      const buffer = fs.readFileSync(filename, { encoding: "UTF-8" });

      return right(buffer.toString());
    } catch (error) {
      return left(error.message);
    }
  };
}
