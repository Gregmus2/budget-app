class Currency {
  final String isoCode;
  final String symbol;
  final String name;

  Currency({
    required this.isoCode,
    required this.symbol,
    required this.name,
  });

  static Currency? fromISOCode(String isoCode) {
    return _currencyData[isoCode];
  }

  static Currency mustFromISOCode(String currency) {
    final result = _currencyData[currency];
    if (result == null) {
      return Currency(isoCode: '', symbol: '', name: 'Unknown currency');
    }

    return result;
  }

  static List<Currency> getCurrencies() {
    return _currencyData.values.toList();
  }

  static var eur = _currencyData['EUR']!;

  static final Map<String, Currency> _currencyData = {
    'USD': Currency(isoCode: 'USD', symbol: '\$', name: 'US Dollar'),
    'EUR': Currency(isoCode: 'EUR', symbol: '€', name: 'Euro'),
    'GBP': Currency(isoCode: 'GBP', symbol: '£', name: 'British Pound'),
    'JPY': Currency(isoCode: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    'AUD': Currency(isoCode: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    'CAD': Currency(isoCode: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    'CHF': Currency(isoCode: 'CHF', symbol: 'CHF', name: 'Swiss Franc'),
    'CNY': Currency(isoCode: 'CNY', symbol: 'CN¥', name: 'Chinese Yuan'),
    'SEK': Currency(isoCode: 'SEK', symbol: 'kr', name: 'Swedish Krona'),
    'NZD': Currency(isoCode: 'NZD', symbol: 'NZ\$', name: 'New Zealand Dollar'),
    'KRW': Currency(isoCode: 'KRW', symbol: '₩', name: 'South Korean Won'),
    'SGD': Currency(isoCode: 'SGD', symbol: 'S\$', name: 'Singapore Dollar'),
    'NOK': Currency(isoCode: 'NOK', symbol: 'kr', name: 'Norwegian Krone'),
    'MXN': Currency(isoCode: 'MXN', symbol: 'Mex\$', name: 'Mexican Peso'),
    'INR': Currency(isoCode: 'INR', symbol: '₹', name: 'Indian Rupee'),
    'RUB': Currency(isoCode: 'RUB', symbol: '₽', name: 'Russian Ruble'),
    'ZAR': Currency(isoCode: 'ZAR', symbol: 'R', name: 'South African Rand'),
    'TRY': Currency(isoCode: 'TRY', symbol: '₺', name: 'Turkish Lira'),
    'BRL': Currency(isoCode: 'BRL', symbol: 'R\$', name: 'Brazilian Real'),
    'TWD': Currency(isoCode: 'TWD', symbol: 'NT\$', name: 'Taiwan New Dollar'),
    'DKK': Currency(isoCode: 'DKK', symbol: 'kr', name: 'Danish Krone'),
    'PLN': Currency(isoCode: 'PLN', symbol: 'zł', name: 'Polish Zloty'),
    'THB': Currency(isoCode: 'THB', symbol: '฿', name: 'Thai Baht'),
    'IDR': Currency(isoCode: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah'),
    'HUF': Currency(isoCode: 'HUF', symbol: 'Ft', name: 'Hungarian Forint'),
    'CZK': Currency(isoCode: 'CZK', symbol: 'Kč', name: 'Czech Koruna'),
    'ILS': Currency(isoCode: 'ILS', symbol: '₪', name: 'Israeli Shekel'),
    'CLP': Currency(isoCode: 'CLP', symbol: 'CLP\$', name: 'Chilean Peso'),
    'PHP': Currency(isoCode: 'PHP', symbol: '₱', name: 'Philippine Peso'),
    'AED': Currency(isoCode: 'AED', symbol: 'د.إ', name: 'UAE Dirham'),
    'COP': Currency(isoCode: 'COP', symbol: 'COL\$', name: 'Colombian Peso'),
    'SAR': Currency(isoCode: 'SAR', symbol: '﷼', name: 'Saudi Riyal'),
    'MYR': Currency(isoCode: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit'),
    'RON': Currency(isoCode: 'RON', symbol: 'lei', name: 'Romanian Leu'),
    'KES': Currency(isoCode: 'KES', symbol: 'KSh', name: 'Kenyan Shilling'),
    'VND': Currency(isoCode: 'VND', symbol: '₫', name: 'Vietnamese Dong'),
    'NPR': Currency(isoCode: 'NPR', symbol: 'रू', name: 'Nepalese Rupee'),
    'EGP': Currency(isoCode: 'EGP', symbol: 'E£', name: 'Egyptian Pound'),
    'PKR': Currency(isoCode: 'PKR', symbol: 'Rs', name: 'Pakistani Rupee'),
    'IQD': Currency(isoCode: 'IQD', symbol: 'ع.د', name: 'Iraqi Dinar'),
    'QAR': Currency(isoCode: 'QAR', symbol: '﷼', name: 'Qatari Riyal'),
    'KWD': Currency(isoCode: 'KWD', symbol: 'د.ك', name: 'Kuwaiti Dinar'),
    'OMR': Currency(isoCode: 'OMR', symbol: '﷼', name: 'Omani Rial'),
    'BHD': Currency(isoCode: 'BHD', symbol: 'ب.د', name: 'Bahraini Dinar'),
    'JOD': Currency(isoCode: 'JOD', symbol: 'د.ا', name: 'Jordanian Dinar'),
    'LBP': Currency(isoCode: 'LBP', symbol: 'ل.ل', name: 'Lebanese Pound'),
    'CRC': Currency(isoCode: 'CRC', symbol: '₡', name: 'Costa Rican Colón'),
    'HRK': Currency(isoCode: 'HRK', symbol: 'kn', name: 'Croatian Kuna'),
    'DZD': Currency(isoCode: 'DZD', symbol: 'د.ج', name: 'Algerian Dinar'),
    'HNL': Currency(isoCode: 'HNL', symbol: 'L', name: 'Honduran Lempira'),
    'BAM': Currency(isoCode: 'BAM', symbol: 'KM', name: 'Bosnia-Herzegovina Convertible Mark'),
    'MKD': Currency(isoCode: 'MKD', symbol: 'ден', name: 'Macedonian Denar'),
    'BYN': Currency(isoCode: 'BYN', symbol: 'Br', name: 'Belarusian Ruble'),
    'TND': Currency(isoCode: 'TND', symbol: 'د.ت', name: 'Tunisian Dinar'),
    'UAH': Currency(isoCode: 'UAH', symbol: '₴', name: 'Ukrainian Hryvnia'),
    'GEL': Currency(isoCode: 'GEL', symbol: '₾', name: 'Georgian Lari'),
    'XAF': Currency(isoCode: 'XAF', symbol: 'FCFA', name: 'Central African CFA Franc'),
    'XOF': Currency(isoCode: 'XOF', symbol: 'CFA', name: 'West African CFA Franc'),
    'XPF': Currency(isoCode: 'XPF', symbol: 'F', name: 'CFP Franc'),
    'MAD': Currency(isoCode: 'MAD', symbol: 'د.م.', name: 'Moroccan Dirham'),
    'DOP': Currency(isoCode: 'DOP', symbol: 'RD\$', name: 'Dominican Peso'),
    'UGX': Currency(isoCode: 'UGX', symbol: 'USh', name: 'Ugandan Shilling'),
    'UZS': Currency(isoCode: 'UZS', symbol: 'лв', name: 'Uzbekistani Som'),
    'KZT': Currency(isoCode: 'KZT', symbol: '₸', name: 'Kazakhstani Tenge'),
    'TJS': Currency(isoCode: 'TJS', symbol: 'ЅМ', name: 'Tajikistani Somoni'),
    'AZN': Currency(isoCode: 'AZN', symbol: '₼', name: 'Azerbaijani Manat'),
    'AFN': Currency(isoCode: 'AFN', symbol: '؋', name: 'Afghan Afghani'),
    'ALL': Currency(isoCode: 'ALL', symbol: 'L', name: 'Albanian Lek'),
    'AMD': Currency(isoCode: 'AMD', symbol: '֏', name: 'Armenian Dram'),
    'AOA': Currency(isoCode: 'AOA', symbol: 'Kz', name: 'Angolan Kwanza'),
    'ARS': Currency(isoCode: 'ARS', symbol: 'AR\$', name: 'Argentine Peso'),
    'AWG': Currency(isoCode: 'AWG', symbol: 'Afl.', name: 'Aruban Florin'),
    'BBD': Currency(isoCode: 'BBD', symbol: 'Bds\$', name: 'Barbadian Dollar'),
    'BDT': Currency(isoCode: 'BDT', symbol: '৳', name: 'Bangladeshi Taka'),
    'BGN': Currency(isoCode: 'BGN', symbol: 'лв', name: 'Bulgarian Lev'),
    'BIF': Currency(isoCode: 'BIF', symbol: 'FBu', name: 'Burundian Franc'),
    'BMD': Currency(isoCode: 'BMD', symbol: 'BD\$', name: 'Bermudian Dollar'),
    'BND': Currency(isoCode: 'BND', symbol: 'B\$', name: 'Brunei Dollar'),
    'BOB': Currency(isoCode: 'BOB', symbol: 'Bs.', name: 'Bolivian Boliviano'),
    'BSD': Currency(isoCode: 'BSD', symbol: 'B\$', name: 'Bahamian Dollar'),
    'BTN': Currency(isoCode: 'BTN', symbol: 'Nu.', name: 'Bhutanese Ngultrum'),
    'BWP': Currency(isoCode: 'BWP', symbol: 'P', name: 'Botswana Pula'),
    'BZD': Currency(isoCode: 'BZD', symbol: 'BZ\$', name: 'Belize Dollar'),
    'CDF': Currency(isoCode: 'CDF', symbol: 'FC', name: 'Congolese Franc'),
    'CVE': Currency(isoCode: 'CVE', symbol: 'Esc', name: 'Cape Verdean Escudo'),
    'DJF': Currency(isoCode: 'DJF', symbol: 'Fdj', name: 'Djiboutian Franc'),
    'ERN': Currency(isoCode: 'ERN', symbol: 'Nfk', name: 'Eritrean Nakfa'),
    'ETB': Currency(isoCode: 'ETB', symbol: 'Br', name: 'Ethiopian Birr'),
    'FJD': Currency(isoCode: 'FJD', symbol: 'FJ\$', name: 'Fijian Dollar'),
    'FKP': Currency(isoCode: 'FKP', symbol: 'FK£', name: 'Falkland Islands Pound'),
    'GMD': Currency(isoCode: 'GMD', symbol: 'D', name: 'Gambian Dalasi'),
    'GNF': Currency(isoCode: 'GNF', symbol: 'FG', name: 'Guinean Franc'),
    'GTQ': Currency(isoCode: 'GTQ', symbol: 'Q', name: 'Guatemalan Quetzal'),
    'GYD': Currency(isoCode: 'GYD', symbol: 'G\$', name: 'Guyanese Dollar'),
    'HKD': Currency(isoCode: 'HKD', symbol: 'HK\$', name: 'Hong Kong Dollar'),
    'HTG': Currency(isoCode: 'HTG', symbol: 'G', name: 'Haitian Gourde'),
    'JMD': Currency(isoCode: 'JMD', symbol: 'J\$', name: 'Jamaican Dollar'),
    'KGS': Currency(isoCode: 'KGS', symbol: 'лв', name: 'Kyrgyzstani Som'),
    'KHR': Currency(isoCode: 'KHR', symbol: '៛', name: 'Cambodian Riel'),
    'KID': Currency(isoCode: 'KID', symbol: 'CI\$', name: 'Kiribati Dollar'),
    'KMF': Currency(isoCode: 'KMF', symbol: 'CF', name: 'Comorian Franc'),
    'KYD': Currency(isoCode: 'KYD', symbol: 'CI\$', name: 'Cayman Islands Dollar'),
  };
}
