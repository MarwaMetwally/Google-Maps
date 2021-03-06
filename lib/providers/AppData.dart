import 'package:flutter/foundation.dart';

import 'package:uber/models/address.dart';

class AppData with ChangeNotifier {
  AddressData pickupLocation;

  void updatePickupLocation(AddressData address) {
    pickupLocation = address;
    notifyListeners();
  }
}
