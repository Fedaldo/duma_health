import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:duma_health/afripay/afripay_data.dart';
import 'package:duma_health/afripay/afripay_screen.dart';
import 'package:duma_health/models/doctor.dart';
import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/models/product.dart';
import 'package:duma_health/models/product_category.dart';
import 'package:duma_health/screens/authentication/auth.dart';
import 'package:duma_health/screens/authentication/sign_in.dart';
import 'package:duma_health/screens/authentication/sign_up.dart';
import 'package:duma_health/screens/chat.dart';
import 'package:duma_health/screens/main.dart';
import 'package:duma_health/screens/pages/all_categories.dart';
import 'package:duma_health/screens/pages/all_doctors.dart';
import 'package:duma_health/screens/pages/all_hospitals.dart';
import 'package:duma_health/screens/pages/cart.dart';
import 'package:duma_health/screens/pages/category_products.dart';
import 'package:duma_health/screens/checkout/checkout.dart';
import 'package:duma_health/screens/pages/doctor_details.dart';
import 'package:duma_health/screens/pages/hospital_services.dart';
import 'package:duma_health/screens/pages/notifications.dart';
import 'package:duma_health/screens/pages/order_details.dart';
import 'package:duma_health/screens/pages/product_details.dart';
import 'package:duma_health/screens/pages/profile.dart';
import 'package:duma_health/services/cart_provider.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/theme/manager.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    PreferenceUtils.getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
        builder: (context, themeManager, Widget? child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Duma Health",
        home: AnimatedSplashScreen(
            duration: 5000,
            splashTransition: SplashTransition.slideTransition,
            splashIconSize: double.infinity,
            splash: const SplashScreen(),
            nextScreen: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              debugShowMaterialGrid: false,
              theme: _themeData(themeManager.theme),
              darkTheme: _themeData(themeManager.theme),
              key: themeManager.key,
              routerConfig: _router,
            ),
            backgroundColor: Colors.white),
      );
    });
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const MainScreen(),
        routes: [
          GoRoute(
            path: "${RouterPath.allHospitals}",
            builder: (context, state) => const AllHospitalsPage(),
          ),
          GoRoute(
              path: "${RouterPath.hospitalServices}",
              builder: (context, state) {
                Hospital h = state.extra as Hospital;
                return HospitalServicesPage(hospital: h);
              }),
          GoRoute(
              path: "${RouterPath.doctors}",
              builder: (context, state) => const AllDoctorsPage()),
          GoRoute(
              path: "${RouterPath.doctorDetails}",
              builder: (context, state) {
                Doctor d = state.extra as Doctor;
                return DoctorDetailsPage(doctor: d);
              }),
          GoRoute(
            path: "${RouterPath.authentication}",
            builder: (context, state) {
              String nP = state.extra as String;
              return AuthScreen(
                nextPath: nP,
              );
            },
          ),
          GoRoute(
              path: "${RouterPath.signIn}",
              builder: (context, state) {
                String nP = state.extra as String;
                return SignInPage(
                  nextPath: nP,
                );
              }),
          GoRoute(
              path: "${RouterPath.signUp}",
              builder: (context, state) {
                String nP = state.extra as String;
                return SignUpPage(
                  nextPath: nP,
                );
              }),
          GoRoute(
              path: "${RouterPath.profile}",
              builder: (context, state) => const ProfileScreen()),
          GoRoute(
              path: "${RouterPath.notifications}",
              builder: (context, state) => const NotificationsScreen()),
          GoRoute(
              path: "${RouterPath.categories}",
              builder: (context, state) => const AllCategoriesPage()),
          GoRoute(
            path: "${RouterPath.categoryProducts}",
            builder: (context, state) {
              ProductCategory pc = state.extra as ProductCategory;
              return CategoryProductsPage(category: pc);
            },
          ),
          GoRoute(
            path: "${RouterPath.productDetails}",
            builder: (context, state) {
              Product p = state.extra as Product;
              return ProductDetailsPage(product: p);
            },
          ),
          GoRoute(
            path: "${RouterPath.cart}",
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: "${RouterPath.checkout}",
            builder: (context, state) => const CheckoutPage(),
          ),
          GoRoute(
            path: "${RouterPath.orderDetails}",
            builder: (context, state) => const OrderDetailsPage(),
          ),
          GoRoute(
            path: "${RouterPath.afripay}",
            builder: (context, state) {
              AfripayData p = state.extra as AfripayData;
              return AfripayScreen(afripayData: p);
            },
          ),
          GoRoute(
            path: "${RouterPath.chat}",
            builder: (context, state) => const ChatPage(),
          ),
        ],
      ),
    ],
  );

  ThemeData _themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.ralewayTextTheme(
        theme.textTheme,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Image.asset(
        'assets/logo.png',
        width: size.width,
        height: size.height * 0.2,
      ),
    );
  }
}
