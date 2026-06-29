import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/firebase_options.dart';
import 'package:food_ordering_app/model/address_model.dart';
import 'package:food_ordering_app/model/addtocart_model.dart';
import 'package:food_ordering_app/model/addon_model.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/navigation/bottom_navigation_screen.dart';
import 'package:food_ordering_app/view/sign_in.dart';
import 'package:food_ordering_app/view/splash_screen.dart';
import 'package:food_ordering_app/viewmodel/addtoCart_view_model.dart';
import 'package:food_ordering_app/viewmodel/address_view_model.dart';
import 'package:food_ordering_app/viewmodel/auth_view_model.dart';
import 'package:food_ordering_app/viewmodel/favourite_provider.dart';
import 'package:food_ordering_app/viewmodel/location_view_model.dart';
import 'package:food_ordering_app/viewmodel/profile_provider.dart';
import 'package:food_ordering_app/viewmodel/receipt_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Hive ─────────────────────────────────────────────────────────
  await Hive.initFlutter();

  Hive.registerAdapter(AddonModelAdapter()); // typeId 0
  Hive.registerAdapter(AddtocartModelAdapter()); // typeId 1
  Hive.registerAdapter(FavouriteModelAdapter()); // typeId 2
  Hive.registerAdapter(AddressModelAdapter()); // typeId 3

  await Hive.openBox<AddtocartModel>('cart');
  await Hive.openBox<FavouriteModel>('favourites');
  await Hive.openBox<AddressModel>('addresses');

  // ── Firebase ─────────────────────────────────────────────────────
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddtocartProvider()),
        ChangeNotifierProvider(create: (_) => ReceiptProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = FavouriteViewModel();
            final uid = FirebaseAuth.instance.currentUser?.uid;
            if (uid != null) {
              provider.init(uid);
            }
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Food App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const SplashScreen(),
      routes: {
        "/signin": (context) => const SignInScreen(),
        "/navigation": (context) => const NavigationScreen(),
      },
    );
  }
}
