/// App-wide constants for Qotton Shop.
class AppConstants {
  AppConstants._();

  // ── App Info ────────────────────────────────────────────────────────
  static const String appName = 'Qotton Shop';
  static const String appTagline = 'Premium Anime & Hoodies';
  static const String currency = 'JD';

  // ── Assets ──────────────────────────────────────────────────────────
  static const String logoPath = 'img/qottonlogo2.png';
  static const String productImagesDir = 'img/product/';

  // ── SharedPreferences Keys ──────────────────────────────────────────
  static const String prefUserName = 'userName';
  static const String prefUserEmail = 'userEmail';
  static const String prefUserPhone = 'userPhone';

  // ── Sizes ───────────────────────────────────────────────────────────
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXL = 20.0;

  static const double buttonHeight = 56.0;
  static const double logoWidth = 150.0;

  // ── Product Sizes ───────────────────────────────────────────────────
  static const List<String> availableSizes = ['S', 'M', 'L', 'XL'];
  static const String defaultSize = 'M';
}
