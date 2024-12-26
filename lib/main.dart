import 'package:flutter/material.dart';
import 'package:flutter_weather_bloc/core/get_it.dart';
import 'package:flutter_weather_bloc/core/kiwi.dart';

import 'core/logic/helper_methods.dart';
import 'views/weather/view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initGetIt();
  initKiwi();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigtorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green,primary: Colors.green),
        useMaterial3: true,
      ),
      home: const WeatherView(),
    );
  }
}


