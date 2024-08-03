import 'package:url_launcher/url_launcher.dart';

class MapsUtils
{
  MapsUtils._();

  //latitude longitude
  static Future<void> openMapWithPosition(double latitude, double longitude) async
  {
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    if(await canLaunch(googleMapUrl))
    {
      await launch(googleMapUrl);
    }
    else
    {
      throw "Could not open the map.";
    }
  }

  //text address
  static Future<void> openMapWithAddress(String fullAddress) async
  {
    String query = Uri.encodeComponent(fullAddress);
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if(await canLaunch(googleMapUrl))
    {
      await launch(googleMapUrl);
    }
    else
    {
      throw "Could not open the map.";
    }
  }




  //
  // static void launchMapFromSourceToDestination(sourceLat, sourceLng, destinationLat, destinationLng) async
  // {
  //   print("Called map function");
  //   String mapOptions =
  //   [
  //     'saddr=$sourceLat,$sourceLng',
  //     'daddr=$destinationLat,$destinationLng',
  //     'dir_action=navigate'
  //   ].join('&');
  //
  //   final mapUrl = 'https://www.google.com/maps?$mapOptions';
  //   Uri uri = Uri.parse(mapUrl);
  //   print("uri = ");
  //   print(uri);
  //
  //   if(await canLaunchUrl(uri))
  //   {
  //     await launchUrl(uri);
  //   }
  //   else
  //   {
  //     throw "Could not launch $mapUrl";
  //   }
  // }

}