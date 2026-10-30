import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../view_model/walletviewmodel.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      walletVM.initRazorpay(
        onSuccess: _handleWithdrawSuccess,
        onError: _handleWithdrawError,
        onExternalWallet: _handleExternalWallet,
      );
    });
  }

  @override
  void dispose() {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    walletVM.clearRazorpay();
    super.dispose();
  }

  void _handleWithdrawSuccess(PaymentSuccessResponse response) async {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    double withdrawAmount = double.tryParse(walletVM.amountController.text) ?? 0;

    bool success = await walletVM.saveWithdrawalRecord(withdrawAmount, response.paymentId ?? "N/A");

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Withdrawal request successful!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving withdrawal record"), backgroundColor: Colors.red),
      );
    }
  }

  void _handleWithdrawError(PaymentFailureResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Withdrawal Failed: ${response.message}"), backgroundColor: Colors.red),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}"), backgroundColor: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletViewModel>(
      builder: (context, walletVM, child) {
        return Scaffold(
          backgroundColor: Color(0xffF7F5FF),
          appBar: AppBar(
            backgroundColor: Color(0xffF7F5FF),
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(CupertinoIcons.back, color: Colors.black),
            ),
            title: Text(
              "Withdraw",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Text("Enter Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 10),
                  TextField(
                    controller: walletVM.amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: "₹ ",
                      hintText: "Enter amount",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade50,
                          child: Icon(CupertinoIcons.building_2_fill, color: Colors.deepPurple),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Bank Account", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("**** **** 4582", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: walletVM.isProcessing
                        ? null
                        : () {
                      walletVM.startWithdrawal(
                        amountText: walletVM.amountController.text,
                        context: context,
                        onError: (msg) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(msg), backgroundColor: Colors.red),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: walletVM.isProcessing
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Withdraw",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text("Withdrawal may take 1-3 business days", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}