import 'package:flutter_weather_bloc/feaatures/weather/bloc.dart';
import 'package:get_it/get_it.dart';

void initGetIt(){
  final getit=GetIt.instance;
  getit.registerFactory(() => WeatherBloc());
}