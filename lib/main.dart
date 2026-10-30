import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentseller/supabse/supabse.dart';
import 'package:rentseller/view/firebase_options.dart';
import 'package:rentseller/view/spla.dart';
import 'package:rentseller/view_model/addproductviewmodel.dart';
import 'package:rentseller/view_model/authview.dart';
import 'package:rentseller/view_model/bookinfmodel.dart';
import 'package:rentseller/view_model/booking%20details%20view%20model.dart';
import 'package:rentseller/view_model/color.dart';
import 'package:rentseller/view_model/document%20view%20model.dart';
import 'package:rentseller/view_model/product%20edit%20view%20model.dart';
import 'package:rentseller/view_model/productdetailviewmodel.dart';
import 'package:rentseller/view_model/profile.dart';
import 'package:rentseller/view_model/profileeditviewmodel.dart';
import 'package:rentseller/view_model/salesviewmodel.dart';
import 'package:rentseller/view_model/seller%20booking%20view%20model.dart';
import 'package:rentseller/view_model/seller%20view%20model.dart';
import 'package:rentseller/view_model/store%20view%20model.dart';
import 'package:rentseller/view_model/walletviewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (SupabaseConfig.url.isNotEmpty && SupabaseConfig.anonKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
    } catch (_) {}
  }

  runApp(const Proclass());
}

class Proclass extends StatelessWidget {
  const Proclass({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddProductViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileEditViewModel()),
        ChangeNotifierProvider(create: (_) => BookingViewModel()),
        ChangeNotifierProvider(create: (_) => BookingDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => SellerBookingViewModel()),
        ChangeNotifierProvider(create: (_) => SellerHomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProductDetailViewModel()),
        ChangeNotifierProvider(create: (_) => DocumentVerificationViewModel()),
        ChangeNotifierProvider(create: (_) => SalesViewModel()),
        ChangeNotifierProvider(create: (_) => WalletViewModel()),
        ChangeNotifierProvider(create: (_) => StoreViewModel()),

      ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Spla(),
      ),
    );
  }
}