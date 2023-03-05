function date() {
  var currentDate = new Date();

  return [
    String(currentDate.getDate()).padStart(2, "0"),
    String(currentDate.getMonth() + 1).padStart(2, "0"),
    String(currentDate.getFullYear()).padStart(4, "0"),
    String(currentDate.getHours()).padStart(2, "0"),
    String(currentDate.getMinutes()).padStart(2, "0"),
    String(currentDate.getSeconds()).padStart(2, "0"),
  ];
}

export function ddmmyyyy() {
  var currentDate = date();

  return currentDate[0] + "/" + currentDate[1] + "/" + currentDate[2];
}

export function yyyymmdd() {
  var currentDate = date();

  return currentDate[2] + "/" + currentDate[1] + "/" + currentDate[0];
}

export function hhmmss() {
  var currentDate = date();

  return currentDate[3] + ":" + currentDate[4] + ":" + currentDate[5];
}
