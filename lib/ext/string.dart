extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension StringExtensions on String {
  bool containsIgnoreCase(String secondString) => toLowerCase().contains(secondString.toLowerCase());
}
