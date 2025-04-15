import "package:flutter/widgets.dart";
import "package:google_api_availability/google_api_availability.dart";

void checkPlayServices() async {
  var status = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
  if (status != GooglePlayServicesAvailability.success) {
    debugPrint(" No Google Play Services: $status");
  }
}