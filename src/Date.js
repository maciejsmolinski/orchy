function date() {
  const currentDate = new Date();

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
  const [day, month, year] = date();

  return [day, month, year].join("/");
}

export function yyyymmdd() {
  const [day, month, year] = date();

  return [year, month, day].join("/");
}

export function hhmmss() {
  const [, , , hours, minutes, seconds] = date();

  return [hours, minutes, seconds].join(":");
}
