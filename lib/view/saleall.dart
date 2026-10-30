import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/salesviewmodel.dart';

class Saleall extends StatefulWidget {
  const Saleall({super.key});

  @override
  State<Saleall> createState() => _SaleallState();
}

class _SaleallState extends State<Saleall> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SalesViewModel>(
      builder: (context, salesVM, child) {
        return Scaffold(
          backgroundColor: const Color(0xffF7F5FF),
          body: ListView.builder(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 10,
            ),
            itemCount: salesVM.itemNames.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.grey.shade200,
                          image: DecorationImage(
                            image: AssetImage(
                              salesVM.images[index],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              salesVM.itemNames[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              salesVM.saleDates[index],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        salesVM.saleAmounts[index],
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}