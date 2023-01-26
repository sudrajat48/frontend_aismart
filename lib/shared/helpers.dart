// File helper can be used for formatting like datetime or number format etc
part of 'shared.dart';

class CurrencyFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    double value = double.parse(newValue.text);
    final money = NumberFormat("###,###,###", "en_us");

    String newText = money.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class Helpers {
  static void focusScope(context) =>
      FocusScope.of(context).requestFocus(FocusNode());

  static String formatDateDMY(String datetime) {
    if (datetime.isEmpty || datetime == '') {
      return '';
    }
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String resultFormatting = dateFormat.format(DateTime.parse(datetime));
    return resultFormatting;
  }

  static String formatDateTime(String datetime) {
    if (datetime.isEmpty || datetime == '') {
      return '';
    }
    DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');
    String resultFormatting = dateFormat.format(DateTime.parse(datetime));
    return resultFormatting;
  }

  static String formatDateNowWithoutTime() {
    DateTime dateNow = DateTime.now();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String resultFormatting = dateFormat.format(dateNow);
    return resultFormatting;
  }

  static String formatCurrencyID(String nomor) {
    return NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0)
        .format(int.parse(nomor));
  }

  Future<void> urlLaunchMethod(String url, {LaunchMode? mode}) async {
    if (!await launchUrl(Uri.parse(url),
        mode: mode ?? LaunchMode.platformDefault)) {
      throw 'Could not launch $url';
    }
  }
}
