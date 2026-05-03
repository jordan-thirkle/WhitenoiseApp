import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final iapServiceProvider = Provider<IapService>((ref) => IapService());

class IapService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  static const String proId = 'com.jordanthirkle.murmur.pro';
  
  final ValueNotifier<bool> isPro = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAvailable = ValueNotifier<bool>(false);
  final ValueNotifier<List<ProductDetails>> products = ValueNotifier<List<ProductDetails>>([]);

  void init() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      debugPrint('IAP Subscription Error: $error');
    });

    isAvailable.value = await _iap.isAvailable();
    if (isAvailable.value) {
      await _loadProducts();
      await _loadLocalStatus();
    }
  }

  Future<void> _loadProducts() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails({proId});
    if (response.error == null) {
      products.value = response.productDetails;
    }
  }

  Future<void> _loadLocalStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isPro.value = prefs.getBool('is_pro') ?? false;
  }

  Future<void> buyPro() async {
    if (products.value.isEmpty) return;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: products.value.first);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        // Show pending UI if needed
      } else {
        if (purchase.status == PurchaseStatus.error) {
          debugPrint('Purchase Error: ${purchase.error}');
        } else if (purchase.status == PurchaseStatus.purchased ||
                   purchase.status == PurchaseStatus.restored) {
          _verifyPurchase(purchase);
        }
        
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
  }

  void _verifyPurchase(PurchaseDetails purchase) async {
    // In a zero-data model, we perform local verification of the product ID
    if (purchase.productID == proId) {
      isPro.value = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_pro', true);
      debugPrint('Murmur Pro Activated!');
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}
