import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:uber/models/address.dart';
import 'package:uber/models/direction.dart';
import 'package:uber/providers/AppData.dart';
import 'package:uber/screens/WelcomeScreen.dart';
import 'package:uber/screens/loginScreen.dart';

import 'pick-up screen.dart';
import 'package:uber/services/assisant.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:uber/widgets/pickUpCarContainer.dart';
import 'package:uber/models/users.dart';
import 'package:uber/Globalvariables.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main';
  static bool requestpanel = false;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PanelController _pc = new PanelController();
  AddressData address = new AddressData();

  DirectionDetails tripDetails;
  String addressss;
  List<String> subaddress = [];
  var first;
  String placeName = "";
  Position currentPosition;
  Geolocator geolocator = Geolocator();
  List<LatLng> plinesCoord = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  var res;
  @override
  void initState() {
    AssistantMethods.getCurrentUserInfo();
    plinesCoord.clear();
    polylineSet.clear();
    markers.clear();
    circles.clear();
    super.initState();
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.033333, 31.233334),
    zoom: 14.4746,
  );
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newGoogleMapController;
  DatabaseReference riderRequestRef;
  void saveRideRequest() {
    riderRequestRef =
        FirebaseDatabase.instance.reference().child("ride requests").push();

    var pickup = Provider.of<AppData>(context, listen: false).pickupLocation;
    var dropoff = Provider.of<AppData>(context, listen: false).dropoffLocation;
    Map pickupMap = {"lat": pickup.lat, "long": pickup.long};
    Map dropoffMap = {"lat": dropoff.lat, "long": dropoff.long};
    Map rideInfoMap = {
      "driver_id": "driver1",
      "payement_method": "cash",
      "pickup": pickupMap,
      "dropoff": dropoffMap,
      "created_at": DateTime.now().toString(),
      "rider_name": Globals.users,
      "pickupadress": pickup.placeName,
      "dropoffaddress": dropoff.placeName
    };
    riderRequestRef.set(rideInfoMap);
  }

  void cancelRequest() {
    riderRequestRef.remove();
  }

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

    print("${first.featureName} : ${first.addressLine}");
    address.lat = currentPosition.latitude;
    address.long = currentPosition.longitude;
    address.placeName = first.addressLine;
    subaddress = first.addressLine.toString().split(',');
    print(subaddress[0]);
    address.name = subaddress[0];
    // print('testttttttttttt0');
    //  print(first.name);
    Provider.of<AppData>(context, listen: false).updatePickupLocation(address);

    addressss = first.addressLine;
    print('addddd$addressss');
    return addressss;
  }

  Future<DirectionDetails> getPlaceDirection(BuildContext context) async {
    AssistantMethods assistantMethods = AssistantMethods();
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickupLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropoffLocation;

    var pickUpLatLng = LatLng(initialPos.lat, initialPos.long);
    var dropoffLatLng = LatLng(finalPos.lat, finalPos.long);
    var details = await assistantMethods.placeDirectionDetails(
        pickUpLatLng, dropoffLatLng);
    // setState(() {
    //   tripdetails = details;
    // });
    print('pointsssss');
    print(details.encodedPoints);
    print(details.durationText);
    print(details.durationValue);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result =
        polylinePoints.decodePolyline(details.encodedPoints);
    plinesCoord.clear();
    if (result.isNotEmpty) {
      result.forEach((PointLatLng pointLatLng) {
        plinesCoord.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();

    Polyline polyline = Polyline(
        polylineId: PolylineId("PolyLine Id"),
        color: Colors.black,
        points: plinesCoord,
        jointType: JointType.round,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true);
    polylineSet.add(polyline);

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropoffLatLng.latitude &&
        pickUpLatLng.longitude > dropoffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropoffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropoffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropoffLatLng.longitude),
          northeast: LatLng(dropoffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropoffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropoffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropoffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropoffLatLng);
    }
    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
    Marker pickupMarker = Marker(
        position: pickUpLatLng,
        markerId: MarkerId("pickup Id"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow:
            InfoWindow(title: initialPos.placeName, snippet: "My Location "));
    Marker dropoffMarker = Marker(
        position: dropoffLatLng,
        markerId: MarkerId("dropoff Id"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
            title: finalPos.placeName, snippet: "Dropoff Location "));

    Circle pickupCircle = Circle(
      circleId: CircleId("pickup Id"),
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.black,
    );
    Circle dropoffCircle = Circle(
      circleId: CircleId("dropoff Id"),
      center: dropoffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.red,
    );

    setState(() {
      tripDetails = details;
      markers.add(pickupMarker);
      markers.add(dropoffMarker);
      circles.add(pickupCircle);
      circles.add(dropoffCircle);
    });
    print('testtt${details.durationValue}');

    return details;
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
                            Text('UserName'),
                            SizedBox(
                              height: 5,
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
                        InkWell(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut().then(
                                (value) => Navigator.pushReplacementNamed(
                                    context, WelcomeScreen.id));
                          },
                          child: ListTile(
                              leading:
                                  Icon(Icons.exit_to_app, color: Colors.black),
                              title: Text(
                                'Logout',
                                style: TextStyle(color: Colors.black),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          body: SlidingUpPanel(
            controller: _pc,
            backdropTapClosesPanel: true,
            backdropEnabled: true,
            minHeight: 65,
            maxHeight: MainScreen.requestpanel ? 250 : 350,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            panel: polylineSet.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 18),
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
                          onTap: () async {
                            _pc.close();
                            res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => PickUpScreen()));
                            if (res == "from search screen") {
                              await getPlaceDirection(context);
                              _pc.open();
                            }
                          },
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
                                        placeName =
                                            Provider.of<AppData>(context)
                                                .pickupLocation
                                                .name;
                                        return Text(
                                            snapshot.data == null
                                                ? ""
                                                : placeName,
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
                  )
                : PickUpCar(tripDetails, () {
                    setState(() {
                      MainScreen.requestpanel = true;
                      saveRideRequest();
                    });
                  }, () {
                    cancelRequest();
                  }),
            body: Stack(
              children: [
                GoogleMap(
                  markers: markers,
                  circles: circles,
                  polylines: polylineSet,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  onMapCreated: (controller) async {
                    _googleMapController.complete(controller);
                    newGoogleMapController = controller;
                    // getAddress();
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
