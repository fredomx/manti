const _kMonthsShort = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

const _kMonthsLong = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

/// "5 ene 2025"
String fmtDateShort(DateTime d) {
  final l = d.toLocal();
  return '${l.day} ${_kMonthsShort[l.month - 1]} ${l.year}';
}

/// "5 de enero"
String fmtDayLong(DateTime d) {
  final l = d.toLocal();
  return '${l.day} de ${_kMonthsLong[l.month - 1]}';
}
