import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bloc/core/constants.dart';
import 'package:flutter_weather_bloc/core/logic/dio_helper.dart';

part 'states.dart';
part 'events.dart';
part 'model.dart';

class WeatherBloc extends Bloc<WeatherEvents,WeatherStates>{
  WeatherBloc():super(WeatherInitialState(msg: "There is no weather data , \n try to search by city name")){
    on<GetWeatherDataEvent>(_getWeatherData);
  }
  

  Future<void> _getWeatherData(GetWeatherDataEvent event, Emitter<WeatherStates> emit) async {
    emit(WeatherLoadingState());

    final response=await DioHelper.get("forecast.json",data: {
      "key":Constants.Weather_Api_Key,
      "q":event.q,
      "days":1
    });

    if(response.isSucess){
      final model=WeatherData.fromJson(response.data);
      if(model.current.tempC > 12){
        emit(WeatherShinyState());
      }else{
        emit(WeatherNotShinyState());
      }
      emit(WeatherSuccessState(weatherData: model));
    }else{
      print("Error:- ${response.msg}");
      emit(WeatherFailedState(msg: response.msg));
    }

  }
}