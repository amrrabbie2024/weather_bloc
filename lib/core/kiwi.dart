import 'package:flutter_weather_bloc/feaatures/weather/bloc.dart';
import 'package:kiwi/kiwi.dart';

void initKiwi(){
  final kiwi=KiwiContainer();
  kiwi.registerFactory((container) => WeatherBloc());
}