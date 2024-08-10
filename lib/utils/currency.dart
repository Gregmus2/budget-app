// todo replace money2 usage to own lib with list of currencies
class Currency {
  final isoCode = '';
  final symbol = '';
  final name = '';

  static Currency fromISOCode(String isoCode) {
    // todo throw exception if not found
    return Currency();
  }

  static List<Currency> getCurrencies() {
    return [];
  }
}

