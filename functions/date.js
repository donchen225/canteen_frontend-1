exports.getStartAndEndDate = (date) => {

    const endDate = new Date();

    date.setHours(0);
    date.setMinutes(0);
    date.setSeconds(0);
    date.setMilliseconds(0);

    endDate.setTime(date.getTime() + 24 * 60 * 60 * 1000);

    return [date, endDate];
}

exports.subtractDate = (date, seconds) => {
    const newDate = new Date();

    newDate.setTime(date.getTime() - seconds);
    return newDate;
}

exports.formatZoomDate = (date) => {
    return date.replace(' ', 'T').split('.')[0];
}