DateTime roundUpHour(DateTime dt, Duration d) {
  return dt
      .subtract(Duration(
          minutes: dt.minute,
          seconds: dt.second,
          milliseconds: dt.millisecond,
          microseconds: dt.microsecond))
      .add(d);
}
