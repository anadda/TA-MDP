import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class DetailDataSatu extends StatefulWidget {
  final String item;
  DetailDataSatu({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  _DetailDataSatuState createState() => _DetailDataSatuState();
}

class _DetailDataSatuState extends State<DetailDataSatu> {
  Future<List<SatuDetail>> detail;

  @override
  void initState() {
    super.initState();
    detail = fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1D2B),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1F1D2B),
        title: Text(
          'Details 2014',
          style:
              TextStyle(color: Colors.white, letterSpacing: .5, fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<List<SatuDetail>>(
          future: detail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Card(
                      borderOnForeground: false,
                      shadowColor: Colors.black,
                      color: Color(0xffF5F5DC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Text("Year = " + snapshot.data[index].uuid),
                            SizedBox(
                              height: 4,
                            ),
                            Text("a = " + snapshot.data[index].a.toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text("b = " + snapshot.data[index].b.toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text("o = " + snapshot.data[index].o.toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text("total = " +
                                snapshot.data[index].total.toString()),
                          ],
                        ),
                      )),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
            return Center(
              child: const CircularProgressIndicator(),
            );
          },
        )),
      ),
    );
  }
}

class SatuDetail {
  int a;
  String uuid;
  int b;
  int c;
  int o;
  int total;

  SatuDetail({this.uuid, this.a, this.b, this.o, this.total});

  factory SatuDetail.fromJson(json) {
    return SatuDetail(
      a: json['a'],
      uuid: json['nama_bulan'],
      b: json['b'],
      o: json['o'],
      total: json['total'],
    );
  }
}

Future<List<SatuDetail>> fetchDetails() async {
  String api =
      'http://data.bandung.go.id/beta/index.php/portal/api/73acec39-5f9e-4ebe-bb18-04281b308be4';
  final response = await http.get(
    Uri.parse(api),
    // headers: headers,
  );

  if (response.statusCode == 200) {
    print(response.body);
    print(response.statusCode);
    var driversShowsJson = jsonDecode(response.body)['data'] as List,
        driversShows =
            driversShowsJson.map((top) => SatuDetail.fromJson(top)).toList();

    return driversShows;
  } else {
    throw Exception('Failed to load drivers');
  }
}
