import 'dart:convert';

import 'package:donor_darah/detaildatadua.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataDuaList extends StatefulWidget {
  DataDuaList({Key key}) : super(key: key);

  @override
  _DataDuaListState createState() => _DataDuaListState();
}

class _DataDuaListState extends State<DataDuaList> {
  Future<List<DataDua>> data2;
  @override
  void initState() {
    super.initState();
    data2 = fetchDataSatuList();
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
                  'Covids',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    // height: 200.0,
                    child: FutureBuilder<List<DataDua>>(
                        future: data2,
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
                                          builder: (context) => DetailDataDua(
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

class DataDua {
  // String name;
  String uuid;
  // String image;
  // String president;

  // final String rating;

  DataDua({
    this.uuid,
    // this.name,
    // this.president,
    // this.image,

    // this.rating,
  });

  factory DataDua.fromJson(Map<String, dynamic> json) {
    return DataDua(
      uuid: json['provinsi'],
      // name: json['circuitName'],
      // image: json['logo'],
      // president: json['president'],

      // rating: json['rating'],
    );
  }
}

// function untuk fetch api
Future<List<DataDua>> fetchDataSatuList() async {
  // var headers = {
  //   "content-type": "application/json",
  //   'x-rapidapi-host': 'api-formula-1.p.rapidapi.com',
  //   'x-rapidapi-key': 'cf5aae3f2dmshcd438ec09b4c502p162dbfjsn5f4c66d38bea',
  // };
  // var header = ("Access-Control-Allow-Origin: *");
  String api =
      'https://apicovid19indonesia-v2.vercel.app/api/indonesia/provinsi';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    print(response.body);
    print(response.statusCode);
    var driversShowsJson = jsonDecode(response.body) as List,
        driversShows =
            driversShowsJson.map((top) => DataDua.fromJson(top)).toList();

    return driversShows;
  } else {
    throw Exception('Failed to load drivers');
  }
}
