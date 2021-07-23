extension Dates on DateTime {
  DateTime normalize() => DateTime(year, month, day, 0, 0, 0, 0, 0);
  int toDatabase() => normalize().millisecondsSinceEpoch;
  int toDatabaseWithoutNormalize() => millisecondsSinceEpoch;
}