// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'HomePage.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({Key? key}) : super(key: key);

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  String location = 'Belum Mendapatkan Lat dan long, Silahkan tekan button';
  String address = 'Mencari lokasi...';

  //getLongLAT
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    //permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }

    //continue accessing the position of device
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Titik Koordinat',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "${location}",
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            const Text(
              'Alamat',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '${address}',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () async {
                      Position position = await _getGeoLocationPosition();
                      setState(() {
                        location =
                            '${position.latitude}, ${position.longitude}';
                      });
                      getAddressFromLongLat(position);
                    },
                    icon: Icon(Icons.gps_fixed_outlined),
                    label: const Text('Ambil Koordinat'),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Position position = await _getGeoLocationPosition();
                      setState(() {
                        location =
                            '${position.latitude}, ${position.longitude}';
                        MapsLauncher.launchCoordinates(
                          position.latitude,
                          position.longitude,
                        );
                      });
                    },
                    icon: Icon(
                      Icons.map_rounded,
                    ),
                    label: const Text(
                      'Buka Pada Maps',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            Center(
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios_new_outlined),
                  label: const Text('Kembali'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
