import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/providers/booking_room_provider.dart';
import 'package:hotel_booking_app/providers/hotel_provider.dart';
import 'package:hotel_booking_app/providers/user_provider.dart';
import 'package:hotel_booking_app/screens/home_screen.dart';
import 'package:hotel_booking_app/screens/login_screen.dart';

import 'package:hotel_booking_app/utils/size_config.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '/Theme/theme_data.dart';
import '/screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/screens/onboarding_screen.dart';
import 'providers/room_provider.dart';


bool? seenOnBoard;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //to show status bar
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom,SystemUiOverlay.top]);

  //to load splash screen for the first time only
  SharedPreferences preferences = await SharedPreferences.getInstance();



 
  seenOnBoard = preferences.getBool("seenOnBoard") ?? false;

  // preferences.setBool("isLoggedIn", true);


  await Firebase.initializeApp();
//   final localAuth = LocalAuthentication();
  
//  final canCheckBiometric = await localAuth.canCheckBiometrics;

  runApp(
    // MyApp(canCheckBiometric),
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({ Key? key}) : super(key: key);



  // final cancheckBioMetric;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HotelProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RoomProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingRoomProvider(),
        ),
      ],
      child: LayoutBuilder(builder: (context, boxConstraint) {
        SizeConfig().init(boxConstraint);
        return MaterialApp(
          title: 'hotel booking app',
          theme: ligthTheme(context),
          debugShowCheckedModeBanner: false,
          // home: seenOnBoard == true ? LoginScreen(cancheckBioMetric) : OnBoardingScreen(),

          home: 
          (seenOnBoard == true ? LoginScreen() : const OnBoardingScreen()),

         
          
          

          // home: SignUpScreen(),
        );
       
      }),
    );
  }
}
