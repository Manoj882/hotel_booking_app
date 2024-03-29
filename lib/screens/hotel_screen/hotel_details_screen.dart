import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constants/constant.dart';

import 'package:hotel_booking_app/screens/room/room_screen.dart';
import 'package:hotel_booking_app/utils/curved_body_widget.dart';
import 'package:hotel_booking_app/utils/google_map/google_map.dart';
import 'package:hotel_booking_app/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../models/hotel_model.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';

import 'edit_hotel_screen.dart';

class HotelDetailsScreen extends StatelessWidget {
  const HotelDetailsScreen({required this.hotel, required this.user, Key? key})
      : super(key: key);

  final Hotel hotel;
  final User user;
  final String imageOfHotel =
      "https://www.nepal-travel-guide.com/wp-content/uploads/2020/05/image-156.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(hotel.hotelName),
        centerTitle: false,
        actions: [
          Provider.of<UserProvider>(context).user.isAdmin
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditHotelScreen(
                              hotelImageUrl: hotel.hotelImage!,
                              model: hotel,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Edit Hotel",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: Padding(
        padding: basePadding,
        
        child: SingleChildScrollView(
          child: Column(
        
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(SizeConfig.height * 3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(SizeConfig.height * 3)),
                  child: hotel.hotelImage == imageOfHotel
                      ? Image.network(
                          imageOfHotel,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          base64Decode(
                            hotel.hotelImage!,
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(
                height: SizeConfig.height * 2,
              ),
        
              Container(
                child: buildHotelDetails(context),
                
              ),  
                  
              
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHotelDetails(
    BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(hotel.hotelAddress),
        // Text(hotel.hotelCity),
        Text(
          "Details",
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: SizeConfig.height,
        ),
        Container(
          child: Text(
            hotel.hotelDescription,
            textAlign: TextAlign.justify,
          ),
        ),
        SizedBox(
          height: SizeConfig.height,
        ),

        Text(
          "Location",
          style: Theme.of(context).textTheme.headline6,
        ),
         SizedBox(
          height: SizeConfig.height,
        ),
        Container(
          width: double.infinity,
          height: 200,
          child: GoogleMapScreen(hotelId: hotel.id!,),
        
          
        ),
         SizedBox(
          height: SizeConfig.height,
        ),

        Text(
          "Amneties",
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: SizeConfig.height,
        ), 
        Text(hotel.hotelAmneties),

        SizedBox(
          height: SizeConfig.height * 1.5,
        ),
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
          Colors.purpleAccent,
            ),
            shape: MaterialStateProperty.all(
             RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            ),
            ),
            fixedSize: MaterialStateProperty.all(
            Size(
            MediaQuery.of(context).size.width,
            40,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ChooseRoomScreen(
                    hotelId: hotel.id!,
                    hotel: hotel,
                    user: user,
                  ),
                ),
              );
            },
            child: Text("Choose Room"),
          ),
        ),
      ],
    );
  }
}
