import "package:google_api_availability/google_api_availability.dart";

void checkPlayServices() async {
  var status = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
  if (status != GooglePlayServicesAvailability.success) {
    print("🚫 No Google Play Services: $status");
  }
}