import 'package:intl/intl.dart';

String formatDateBydMMMYYY(DateTime date) {
  return DateFormat("d MMM, yyyy").format(date);
}
