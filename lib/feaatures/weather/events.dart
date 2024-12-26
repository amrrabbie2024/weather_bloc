part of 'bloc.dart';

class WeatherEvents{}

class GetWeatherDataEvent extends WeatherEvents{
  final String q;

  GetWeatherDataEvent({required this.q});
}