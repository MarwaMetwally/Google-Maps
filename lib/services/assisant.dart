import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uber/models/direction.dart';

String mapKey = 'AIzaSyCyt_eysLh70lE25053JEzJaTYsvrQGfRE';

class AssistantMethods {
  Future<DirectionDetails> placeDirectionDetails(
      LatLng initialpos, LatLng finalpos) async {
    DirectionDetails directionDetails = DirectionDetails();
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialpos.latitude},${initialpos.longitude}&destination=${finalpos.latitude},${finalpos.longitude}&key=$mapKey";
    final res = await http.get(url);

    String data = res.body;
    var decodedData = json.decode(data);
    if (decodedData["status"] == "OK") {
      directionDetails.encodedPoints =
          decodedData["routes"][0]["overview_polyline"]["points"];

      directionDetails.distText =
          decodedData["routes"][0]["legs"][0]["distance"]["text"];

      directionDetails.distValue =
          decodedData["routes"][0]["legs"][0]["distance"]["value"];

      directionDetails.durationText =
          decodedData["routes"][0]["legs"][0]["duration"]["text"];

      directionDetails.durationValue =
          decodedData["routes"][0]["legs"][0]["duration"]["value"];

      return directionDetails;
    } else {
      print(decodedData["status"]);
    }
  }
}
