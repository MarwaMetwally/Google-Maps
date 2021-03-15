import 'package:flutter/material.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:uber/models/direction.dart';
import 'package:uber/services/assisant.dart';
import 'package:uber/screens/mainscreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class PickUpCar extends StatefulWidget {
  DirectionDetails directionDetails;
  Function ontap;
  Function canceltap;
  PickUpCar(this.directionDetails, this.ontap, this.canceltap);
  @override
  _PickUpCarState createState() => _PickUpCarState();
}

class _PickUpCarState extends State<PickUpCar> {
  AssistantMethods assistantMethods;
  bool carSelected = false;

  bool scooterSelected = false;

  bool taxiSelected = false;
  TextStyle txtstyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return MainScreen.requestpanel != true
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'pickUp car',
                    style: txtstyle.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            carSelected = true;
                            scooterSelected = taxiSelected = false;
                          });
                        },
                        child: ListTile(
                          leading: Image.network(
                              "https://www.mercedes-benz.com.eg/en/passengercars/mercedes-benz-cars/accessories-and-service/car-accessories/accessories-catalogue/_jcr_content/par/productinfotabnav/tabnav/productinfotabnavite_180621836/tabnavitem/productinfotextimage_2140964595/media2/slides/videoimageslide/image.MQ6.12.20191010125352.jpeg"),
                          title: Text(
                            "Car",
                            style: txtstyle,
                          ),
                          trailing: Text(
                            "EGP ${AssistantMethods.calculateFares(widget.directionDetails).truncate()}",
                            style: txtstyle,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            scooterSelected = true;
                            carSelected = taxiSelected = false;
                          });
                        },
                        child: ListTile(
                          leading: Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa6kvZKeGBGBDLoftVQh9Xx95TfOfs2JfSsg&usqp=CAU"),
                          title: Text(
                            "Scooter",
                            style: txtstyle,
                          ),
                          trailing: Text(
                            "EGP ${(AssistantMethods.calculateFares(widget.directionDetails) * 0.2).truncate()}",
                            style: txtstyle,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            taxiSelected = true;
                            scooterSelected = carSelected = false;
                          });
                        },
                        child: ListTile(
                          selectedTileColor: Colors.red,
                          leading: Image.network(
                              "https://image.shutterstock.com/image-illustration/yellow-taxi-isolated-3d-rendering-260nw-618786881.jpg"),
                          title: Text(
                            "Taxi",
                            style: txtstyle,
                          ),
                          trailing: Text(
                            "EGP ${(AssistantMethods.calculateFares(widget.directionDetails) * 0.3).truncate()}",
                            style: txtstyle,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Icon(Icons.payment, color: Colors.black),
                        title: Text(
                          'Cash',
                          style: txtstyle,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                        ),
                      ),
                      FlatButton(
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width * 75,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onPressed: widget.ontap,
                          child: Text(
                            "Request",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Positioned(
                  left: 50,
                  top: 30,
                  child: FadeAnimatedTextKit(
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    text: [
                      "Request a Ride",
                      "Please Wait...",
                      "Search for driver"
                    ],
                    textStyle:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Positioned(
                    top: 150,
                    left: MediaQuery.of(context).size.width * 0.43,
                    child: InkWell(
                      onTap: widget.canceltap,
                      child: Icon(
                        Icons.cancel_sharp,
                        size: 55,
                      ),
                    ))
              ],
            ),
          );
  }
}
