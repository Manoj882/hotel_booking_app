import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constants/constant.dart';
import 'package:hotel_booking_app/providers/hotel_provider.dart';
import 'package:hotel_booking_app/providers/room_provider.dart';
import 'package:hotel_booking_app/screens/book_room/all_user_booked_room.dart';
import 'package:hotel_booking_app/screens/book_room/booking_history.dart';
import 'package:hotel_booking_app/screens/book_room/list_of_booking.dart';
import 'package:hotel_booking_app/screens/finger_print_screen.dart';
import 'package:hotel_booking_app/screens/login_screen.dart';
import 'package:hotel_booking_app/screens/search_screen.dart';

import 'package:hotel_booking_app/utils/google_map/google_map.dart';
import 'package:hotel_booking_app/widgets/general_alert_dialog.dart';

import '../models/hotel_model.dart';
import '../models/room.dart';
import '/providers/user_provider.dart';
import '/screens/hotel_screen/add_hotels_screen.dart';
import '/utils/curved_body_widget.dart';
import '/utils/navigate.dart';
import '/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../profile/profile_screen.dart';
import 'hotel_screen/hotel_details_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final image = "assets/images/profile.png";
  final String imageOfHotel =
      "https://www.nepal-travel-guide.com/wp-content/uploads/2020/05/image-156.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SearchScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.search_outlined,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<UserProvider>(builder: (_, data, __) {
                return UserAccountsDrawerHeader(
                  accountName: Text(data.user.name ?? "No Name"),
                  accountEmail: Text(data.user.email ?? "No Email"),
                  currentAccountPicture: Hero(
                    tag: "image-url",
                    child: SizedBox(
                      height: SizeConfig.height * 16,
                      width: SizeConfig.height * 16,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.height * 8),
                        child: data.user.image == null
                            ? Image.asset(
                                image,
                                fit: BoxFit.cover,
                              )
                            : Image.memory(
                                base64Decode(data.user.image!),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                );
              }),
              buildListTile(
                context,
                iconData: Icons.person_outlined,
                label: "Profile",
                widget: ProfileScreen(imageUrl: image),
              ),
              Provider.of<UserProvider>(context).user.isAdmin
                  ? buildListTile(
                      context,
                      iconData: Icons.book_online_outlined,
                      label: "Reservations",
                      widget: const AllUserBookedRoom(),
                    )
                  : buildListTile(
                      context,
                      iconData: Icons.book_online_outlined,
                      label: "Reservation",
                      widget: const ListOfBookingRoom(),
                    ),
              if (!Provider.of<UserProvider>(context).user.isAdmin)
                buildListTile(
                  context,
                  iconData: Icons.history_outlined,
                  label: "Booking History",
                  widget: BookingHistoryScreen(),
                ),
              buildListTile(
                context,
                iconData: Icons.logout_outlined,
                label: "Log Out",
                widget: LoginScreen(),
              ),
            ],
          ),
        ),
      ),
      body: CurvedBodyWidget(
        widget: FutureBuilder(
          future: Provider.of<HotelProvider>(context, listen: true)
              .fetchHotelData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final listOfHotel = Provider.of<HotelProvider>(context).listOfHotel;
            final user = Provider.of<UserProvider>(context).user;

            return listOfHotel.isEmpty
                ? const Center(
                    child: Text("Any hotel is not available for booking"),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.width * 3,
                              ),
                              child: Text(
                                "Available Hotels",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Provider.of<UserProvider>(context).user.isAdmin
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AddHotelsScreen(
                                              hotelImageUrl: imageOfHotel,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Add Hotel",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.height * 1.5,
                        ),
                        SizedBox(
                          height: SizeConfig.height * 1.5,
                        ),
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: listOfHotel.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => navigate(
                                context,
                                HotelDetailsScreen(
                                  hotel: listOfHotel[index],
                                  user: user,
                                ),
                              ),
                              child: hotelCard(
                                context,
                                hotelName: listOfHotel[index].hotelName,
                                hotelAddress: listOfHotel[index].hotelAddress,
                                hotelCity: listOfHotel[index].hotelCity,
                                hotel: listOfHotel[index],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: SizeConfig.height * 1.5,
                            );
                          },
                          shrinkWrap: true,
                          primary: false,
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget buildListTile(
    BuildContext context, {
    required IconData iconData,
    required String label,
    required Widget widget,
  }) {
    return ListTile(
      leading: Icon(
        iconData,
      ),
      title: Text(label),
      onTap: () => navigate(
        context,
        widget,
      ),
    );
  }

  hotelCard(
    BuildContext context, {
    required String hotelName,
    required String hotelAddress,
    required String hotelCity,
    required Hotel hotel,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          SizeConfig.height * 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: SizeConfig.height * 18,
            width: SizeConfig.height * 100,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  SizeConfig.height * 2,
                ),
                topRight: Radius.circular(
                  SizeConfig.height * 2,
                ),
              ),
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

          Padding(
            padding: basePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotelName,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          color: Colors.black38,
                        ),
                        Text(
                          hotelAddress,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Colors.black38,
                                  ),
                        ),
                        const Text(", "),
                        Text(
                          hotelCity,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Colors.black38,
                                  ),
                        ),
                      ],
                    ),
                    if (Provider.of<UserProvider>(context).user.isAdmin)
                      IconButton(
                        onPressed: () async {
                          await GeneralAlertDialog()
                              .customDeleteDialog(context, hotel);
                        },
                        icon: const Icon(
                          Icons.delete_outlined,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          //delete hotel
        ],
      ),
    );
  }
}
