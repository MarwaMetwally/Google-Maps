import 'package:flutter/foundation.dart';

import 'package:uber/models/address.dart';

class AppData with ChangeNotifier {
  AddressData pickupLocation, dropoffLocation;

  void updatePickupLocation(AddressData address) {
    pickupLocation = address;
    notifyListeners();
  }

  void updateDropoffLocation(AddressData address) {
    dropoffLocation = address;
    notifyListeners();
  }
}
