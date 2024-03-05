import 'package:flutter/material.dart';
import '../routers/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import '../provider/Counter.dart';
import '../provider/Cart.dart';
import '../provider/CheckOut.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Counter()),
            ChangeNotifierProvider(create: (_) => Cart()),
            ChangeNotifierProvider(create: (_) => CheckOut()),
          ],
          child:MaterialApp(
            initialRoute: '/',
            onGenerateRoute: onGenerateRoute,
            theme:ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Colors.white,
                onPrimary:Colors.black,
              ),
            ),
            debugShowCheckedModeBanner: false,
          )
        );
      }
    );
  }
}