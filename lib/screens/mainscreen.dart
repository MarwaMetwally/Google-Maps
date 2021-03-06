import 'dart:async';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:uber/models/address.dart';
import 'package:uber/providers/AppData.dart';
import 'pick-up screen.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AddressData address = new AddressData();
  String addressss;
  var first;
  String placeName = "";
  Position currentPosition;
  Geolocator geolocator = Geolocator();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.033333, 31.233334),
    zoom: 14.4746,
  );
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newGoogleMapController;
  void getPosition() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLang =
        LatLng(currentPosition.latitude, currentPosition.longitude);

    CameraPosition newCameraPosition =
        CameraPosition(target: latLang, zoom: 14.4746);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<String> getAddress() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates =
        new Coordinates(currentPosition.latitude, currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;

    print("${first.countryName} : ${first.addressLine}");
    address.lat = currentPosition.latitude;
    address.long = currentPosition.longitude;
    address.placeName = first.addressLine;
    Provider.of<AppData>(context, listen: false).updatePickupLocation(address);
    addressss = first.addressLine;
    print('addddd$addressss');
    return addressss;
  }

  @override
  Widget build(BuildContext context) {
    // print(addressss);

    return SafeArea(
      child: Scaffold(
          key: _globalKey,
          drawer: Container(
            //width: 250,
            child: Drawer(
              child: ListView(
                children: [
                  Container(
                    color: Colors.black,
                    height: 120,
                    child: DrawerHeader(
                      child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, size: 50),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('UserName'),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Visit Profile')
                              ],
                            )
                          ]),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: ListView(
                      children: [
                        ListTile(
                            leading: Icon(Icons.history, color: Colors.black),
                            title: Text(
                              'history',
                              style: TextStyle(color: Colors.black),
                            )),
                        ListTile(
                            leading: Icon(Icons.person, color: Colors.black),
                            title: Text(
                              'Visit Profile',
                              style: TextStyle(color: Colors.black),
                            )),
                        ListTile(
                            leading: Icon(Icons.info, color: Colors.black),
                            title: Text(
                              'About',
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          body: SlidingUpPanel(
            minHeight: 65,
            maxHeight: 300,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            panel: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi There',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'where To?',
                    style: TextStyle(color: Colors.black, fontSize: 23),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => PickUpScreen())),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 9,
                              spreadRadius: 0.4,
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.black),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Search Drop off',
                                style: TextStyle(color: Colors.black))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.black,
                          size: 35,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: getAddress(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  placeName = Provider.of<AppData>(context)
                                      .pickupLocation
                                      .placeName;
                                  return Text(
                                      snapshot.data == null
                                          ? ""
                                          : placeName.substring(0, 40) + '.',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ));
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            Text('Your Living Home Address',
                                style: TextStyle(color: Colors.black45))
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 1,
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.work,
                          color: Colors.black,
                          size: 33,
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add Work',
                                style: TextStyle(color: Colors.black)),
                            Text(
                              'Your Office Address',
                              style: TextStyle(color: Colors.black45),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  onMapCreated: (controller) async {
                    _googleMapController.complete(controller);
                    newGoogleMapController = controller;
                    getAddress();
                    getPosition();
                  },
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: Container(
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              blurRadius: 6,
                              spreadRadius: 0.7,
                              offset: Offset(0.7, 0.7))
                        ]),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 30,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _globalKey.currentState.openDrawer();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
