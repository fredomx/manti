import 'package:manti/core/config/app_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class EntitlementsService {
  EntitlementsService._();
  static final instance = EntitlementsService._();

  bool _isPro = false;
  bool get isPro => _isPro;

  Future<void> init(String apiKey) async {
    await Purchases.configure(PurchasesConfiguration(apiKey));
    Purchases.addCustomerInfoUpdateListener(_update);
    try {
      _update(await Purchases.getCustomerInfo());
    } catch (_) {}
  }

  void _update(CustomerInfo info) {
    _isPro = info.entitlements.active.containsKey('pro');
  }

  Future<bool> purchase(Package package) async {
    final result = await Purchases.purchase(PurchaseParams.package(package));
    _update(result.customerInfo);
    return _isPro;
  }

  Future<bool> restore() async {
    final info = await Purchases.restorePurchases();
    _update(info);
    return _isPro;
  }

  /// Dev flavor only — simulates a successful Pro purchase without hitting RevenueCat.
  Future<bool> debugUnlockPro() async {
    assert(AppConfig.isDev, 'debugUnlockPro must only be called in development flavor');
    _isPro = true;
    return true;
  }
}
