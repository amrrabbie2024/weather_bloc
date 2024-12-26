import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bloc/core/design/app_failed.dart';
import 'package:flutter_weather_bloc/core/design/app_loading.dart';
import 'package:flutter_weather_bloc/core/logic/helper_methods.dart';
import 'package:flutter_weather_bloc/feaatures/weather/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kiwi/kiwi.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

final kbloc=KiwiContainer().resolve<WeatherBloc>();
final gbloc=GetIt.I<WeatherBloc>();
bool isVisible=false;
Color color=Colors.white;

class _WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: Text("Weather app"),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 24),
        backgroundColor: color,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              isVisible=!isVisible;
            });
          }, icon: Icon(Icons.search,color: Theme.of(context).primaryColor,size: 28,))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16,vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _searchText(),
            SizedBox(height: isVisible?16:0,),
            BlocConsumer(
              bloc: kbloc,
              buildWhen: (previous, current) => current is WeatherInitialState || current is WeatherLoadingState || current is WeatherFailedState || current is WeatherSuccessState,
              listener: (context, state) {
                if(state is WeatherFailedState)
                  showMessage(state.msg);
                else if(state is WeatherSuccessState)
                  showMessage("Weather data loading ...",isSucess: true);
                else if(state is WeatherShinyState){
                  setState(() {
                    isVisible=false;
                    color=Colors.yellow;
                  });
                }
                else if(state is WeatherNotShinyState){
                  setState(() {
                    isVisible=false;
                    color=Colors.grey.withOpacity(.5);
                  });
                }
              },
              builder: (context, state) {
                if(state is WeatherLoadingState)
                  return AppLoading();
                else if(state is WeatherFailedState)
                  return AppFailed(msg: state.msg,);
                else if(state is WeatherSuccessState)
                  return _weatherData(state.weatherData);
                else if(state is WeatherInitialState)
                  return Center(child: Text(state.msg!,style:  TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 24),));
                else
                  return SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _searchText(){
    return Visibility(
      visible: isVisible,
      child: TextField(
        onSubmitted: (value) {
          kbloc.add(GetWeatherDataEvent(q: value));
          //gbloc.add(GetWeatherDataEvent(q: value));
        },
        decoration: InputDecoration(
          labelText: "City name",
          hintText: "Type here your city name",
          alignLabelWithHint: true,
          prefix: Icon(Icons.location_city,color: Theme.of(context).primaryColor,),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _weatherData(WeatherData weatherData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(weatherData.location.name,style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 21,fontWeight: FontWeight.w500),),
        SizedBox(height: 8,),
        Text(weatherData.current.condition.text,style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 21,fontWeight: FontWeight.w500),),
        SizedBox(height: 8,),
        Text(weatherData.current.tempC.toString(),style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 21,fontWeight: FontWeight.w500),),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network("https:${weatherData.current.condition.icon}",width: 90,height: 90,fit: BoxFit.fill,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Avg Temp:- ${weatherData.forecast.forecastday[0].day.avgtempC}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
                SizedBox(height: 6,),
                Text("Max Temp:- ${weatherData.forecast.forecastday[0].day.maxtempC}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
                SizedBox(height: 6,),
                Text("Min Temp:- ${weatherData.forecast.forecastday[0].day.mintempC}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
                SizedBox(height: 6,),
                Text("Humidity:- ${weatherData.current.humidity}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
                SizedBox(height: 6,),
                Text("Pressure:- ${weatherData.current.pressureIn}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
                SizedBox(height: 6,),
                Text("Wind:- ${weatherData.current.windKph}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
                SizedBox(height: 6,),
                Text("Visible:- ${weatherData.current.visKm}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
                SizedBox(height: 16,),
              ],
            )
          ],
        ),
         _hoursSection(weatherData.forecast.forecastday[0].hour),
      ],
    );
  }

  Widget _hoursSection(List<Hour> hours) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        itemCount: hours.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _hoursItems(hours[index]),),
    );
  }

  _hoursItems(Hour hour) {
    return Card(
      color: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft:  Radius.circular(20)),
        side: BorderSide(color: Theme.of(context).primaryColor)
      ),
      child: Padding(
        padding:  EdgeInsetsDirectional.symmetric(horizontal: 8,vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8,),
            Text("${hour.time.substring(11)}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
            SizedBox(height: 4,),
            Text("${hour.tempC}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
            SizedBox(height: 4,),
            Image.network("https:${hour.condition.icon}",width: 60,height: 45,fit: BoxFit.fill,),
            SizedBox(height: 4,),
            Text("${hour.condition.text}",style: TextStyle(color: Colors.red,fontSize: 19,fontWeight: FontWeight.normal),),
            SizedBox(height: 4,),
          ],
        ),
      ),
    );
  }
}
