import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../repository/wallet repository.dart';

class WalletViewModel extends ChangeNotifier {
  final WalletRepository _repository = WalletRepository();
  late Razorpay _razorpay;

  bool isProcessing = false;
  final TextEditingController amountController = TextEditingController();

  void initRazorpay({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void clearRazorpay() {
    _razorpay.clear();
    amountController.dispose();
  }

  Future<bool> saveWithdrawalRecord(double amount, String paymentId) async {
    isProcessing = true;
    notifyListeners();

    bool success = await _repository.saveWithdrawalRecord(amount, paymentId);

    isProcessing = false;
    notifyListeners();
    return success;
  }

  void startWithdrawal({
    required String amountText,
    required BuildContext context,
    required Function(String) onError,
  }) {
    double amount = double.tryParse(amountText) ?? 0;
    if (amount <= 0) {
      onError("Please enter a valid amount");
      return;
    }

    isProcessing = true;
    notifyListeners();

    try {
      var options = {
        'key': 'rzp_live_YOUR_KEY_HERE', // Replace with your live/test key or fetch securely
        'amount': (amount * 100).toInt(),
        'name': 'RentMe Payout',
        'description': 'Seller Withdrawal Payout',
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {'contact': '', 'email': ''},
        'external': {
          'wallets': ['paytm']
        }
      };

      _razorpay.open(options);
    } catch (e) {
      onError("Error starting payout: $e");
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }
}