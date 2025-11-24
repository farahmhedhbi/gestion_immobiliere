import 'package:intl/intl.dart';

class Helpers {
   static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(amount);
  }
}