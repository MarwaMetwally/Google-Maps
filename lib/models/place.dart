class PlacePrediction {
  String secondarytext;
  String maintext;
  String placeid;
  PlacePrediction({this.maintext, this.placeid, this.secondarytext});

  PlacePrediction.fromJson(Map<String, dynamic> place) {
    placeid = place["place_id"];
    maintext = place["structured_formatting"]["main_text"];
    secondarytext = place["structured_formatting"]["secondary_text"];
  }
}
