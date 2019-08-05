function date() {
    var currentDate = new Date();

    return [
        String(currentDate.getDate()).padStart(2, '0'),
        String(currentDate.getMonth() + 1).padStart(2, '0'),
        String(currentDate.getFullYear())
    ];
}


exports.ddmmyyyy = function() {
    var currentDate = date();

    return currentDate[0] + '/' + currentDate[1] + '/' + currentDate[2];
}
