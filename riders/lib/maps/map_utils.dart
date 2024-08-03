//import 'dart:html';
//import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils
{
  MapUtils._();

  static void launchMapFromSourceToDestination(sourceLat, sourceLng, destinationLat, destinationLng) async
  {
    print("Called map function");
    String mapOptions =
    [
      'saddr=$sourceLat,$sourceLng',
      'daddr=$destinationLat,$destinationLng',
      'dir_action=navigate'
    ].join('&');

    print("Map options = ");
    print(mapOptions);

    final mapUrl = 'https://www.google.com/maps?$mapOptions';
    // Uri uri = Uri.parse(mapUrl);
    // print("uri = ");
    // print(uri);


    if(await canLaunch(mapUrl))
    {
      await launch(mapUrl);
    }
    else
    {
      throw "Could not open the map.";
    }




    // if(await canLaunchUrl(uri))
    //   {
    //     await launchUrl(uri);
    //   }
    // else
    //   {
    //     throw "Could not launch $mapUrl";
    //   }

  }

    // String query = Uri.encodeComponent(fullAddress);
    // String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    //
    // if(await canLaunch(googleMapUrl))
    // {
    //   await launch(googleMapUrl);
    // }
    // else
    // {
    //   throw "Could not open the map.";
    // }


}