import 'dart:convert';

import 'package:uber/models/address.dart';
import 'package:uber/models/place.dart';
//import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber/providers/AppData.dart';
import 'package:http/http.dart' as http;
//import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_webservice/places.dart';
import 'dart:async';
//import 'package:google_maps_webservice/geolocation.dart';

//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:search_map_place/search_map_place.dart';

String mapKey = "AIzaSyCyt_eysLh70lE25053JEzJaTYsvrQGfRE";

class PickUpScreen extends StatefulWidget {
  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  TextEditingController pickUp = TextEditingController();
  int listCount = 0;
  List<PlacePrediction> placeData = [];
  TextEditingController dropOff = TextEditingController();
  GoogleMapController mapController;

  Future<void> findPlace(String placeName, BuildContext context) async {
    if (placeName.length > 1) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:eg";
      var res = await http.get(url);
      String data = res.body;
      var decodedData = json.decode(data);
      if (decodedData == 'failed') {
        return;
      } else {
        if (decodedData['status'] == "OK") {
          var prediction = decodedData["predictions"];
          var placeList = (prediction as List)
              .map((e) => PlacePrediction.fromJson(e))
              .toList();
          setState(() {});
          placeData = placeList;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // String address = Provider.of<AppData>(context, listen: false)
    //         .pickupLocation
    //         .placeName ??
    //     Provider.of<AppData>(context, listen: false).pickupLocation.placeName;
    // pickUp.text = address == null ? "" : address;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                child: Container(
                  height: 40,
                  child: Row(children: [
                    Icon(
                      Icons.arrow_back,
                    ),
                    Text('Set Drop Off'),
                  ]),
                ),
              ),
              Column(
                children: [
                  TextField(
                    controller: pickUp,
                    decoration:
                        InputDecoration(hintText: 'Enter Pick-up location'),
                  ),
                  TextField(
                    onChanged: (value) {
                      findPlace(value, context);
                    },
                    controller: dropOff,
                    decoration: InputDecoration(hintText: 'Where To?'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  placeData.length > 0
                      ? ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: placeData.length,
                          itemBuilder: (context, index) {
                            return PredictionTile(placeData[index]);
                          },
                        )
                      : Container()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePrediction placePrediction;
  PredictionTile(this.placePrediction);

  void getPlaceDetails(String placeId, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
                Text('please wait ..')
              ],
            ),
          ),
        );
      },
    );
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    final res = await http.get(url);
    Navigator.pop(context);
    String data = res.body;
    var decodedData = json.decode(data);
    if (decodedData["status"] == "OK") {
      AddressData addressData = AddressData();
      addressData.placeName = decodedData["result"]["name"];
      addressData.placeID = placeId;
      addressData.lat = decodedData["result"]["geometry"]["location"]["lat"];
      addressData.long = decodedData["result"]["geometry"]["location"]["lng"];
      Provider.of<AppData>(context, listen: false)
          .updateDropoffLocation(addressData);
      print('detailssssssssssss');
      print(addressData.placeName);
      Navigator.pop(context, "from search screen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          getPlaceDetails(placePrediction.placeid, context);
        },
        child: Container(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(Icons.add_location, color: Colors.white),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placePrediction.maintext,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      placePrediction.secondarytext,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
