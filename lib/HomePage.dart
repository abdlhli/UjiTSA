import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ujitsa/LandingPage.dart';
import 'package:ujitsa/LokasiPage.dart';
import 'package:ujitsa/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      print(auth.currentUser!.email);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Home"),
        actions: [
          IconButton(
            color: Colors.white,
            tooltip: "Profile",
            iconSize: 25,
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Profile()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 37),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Selamat Datang, \n",
                    style: TextStyle(color: Colors.blue[300]),
                  ),
                  TextSpan(
                    text: auth.currentUser!.email,
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Cari"),
            ),
            const SizedBox(height: 20),
            Container(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LokasiPage(),
                    ),
                  );
                },
                icon: Icon(Icons.map_sharp),
                label: Text("Mencari Lokasi Saat Ini"),
              ),
            ),
            Container(
              child: ElevatedButton.icon(
                onPressed: () {
                  _signOut().then(
                    (value) => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => landingPage(),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.logout_outlined),
                label: Text('Logout'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
