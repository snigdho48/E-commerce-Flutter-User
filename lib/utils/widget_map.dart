import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

showMapInputDialog({
  required BuildContext context,
  required String title,
  String negativeButton = 'CLOSE',
  required Function(String,dynamic) onSubmit,
}) async {
  var location='';
  var locationdata={};

  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: MediaQuery.of(context).size.width*.8,
          height: MediaQuery.of(context).size.height*.6,
          child: FlutterLocationPicker(
              initPosition: LatLong(23, 89),
              searchBarHintText: 'Search Location',
              selectLocationButtonText: 'Save Location',
              // initZoom: 11,
              // minZoomLevel: 5,
              // maxZoomLevel: 16,
              trackMyPosition: true,
              onError: (e) {},
              onPicked: (pickedData)  {
                location=pickedData.address;
                locationdata=pickedData.addressData;
                if (location.isEmpty) return;
                final value = location;
                final map=locationdata;
                Navigator.pop(context);
                onSubmit(value,map);



              })
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(negativeButton),
          ),

        ],
      ));
}
