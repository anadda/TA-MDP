import 'dart:convert';
import 'dart:io';

import 'package:donor_darah/detaildatasatu.dart';
import 'package:donor_darah/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'donor darah',
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<DataSatu>> data1;
  @override
  void initState() {
    super.initState();
    data1 = fetchDataSatuList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '2014',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    // height: 200.0,
                    child: FutureBuilder<List<DataSatu>>(
                        future: data1,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Card(
                                  borderOnForeground: false,
                                  shadowColor: Colors.black,
                                  color: Color(0xffF5F5DC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    title: Text(
                                      snapshot.data[index].uuid,
                                      style: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: .5,
                                          fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailDataSatu(
                                            item: snapshot.data[index].uuid,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DataSatu {
  // String name;
  String uuid;
  // String image;
  // String president;

  // final String rating;

  DataSatu({
    this.uuid,
    // this.name,
    // this.president,
    // this.image,

    // this.rating,
  });

  factory DataSatu.fromJson(Map<String, dynamic> json) {
    return DataSatu(
      uuid: json['nama_bulan'],

    );
  }
}

// function untuk fetch api
Future<List<DataSatu>> fetchDataSatuList() async {

  String api =
      'http://data.bandung.go.id/beta/index.php/portal/api/73acec39-5f9e-4ebe-bb18-04281b308be4';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    print(response.body);
    print(response.statusCode);
    var driversShowsJson = jsonDecode(response.body)['data'] as List,
        driversShows =
            driversShowsJson.map((top) => DataSatu.fromJson(top)).toList();

    return driversShows;
  } else {
    throw Exception('Failed to load');
  }
}
