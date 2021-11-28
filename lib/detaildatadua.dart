import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class DetailDataDua extends StatefulWidget {
  final String item;
  DetailDataDua({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  _DetailDataDuaState createState() => _DetailDataDuaState();
}

class _DetailDataDuaState extends State<DetailDataDua> {
  Future<List<DuaDetail>> detail;

  @override
  void initState() {
    super.initState();
    detail = fetchDetails(widget.item);
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
          'Details Covid per Provinsi',
          style:
              TextStyle(color: Colors.white, letterSpacing: .5, fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<List<DuaDetail>>(
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
                            Text("Provinsi = " + snapshot.data[index].uuid),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                                "Kasus = " + snapshot.data[index].a.toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text("Sembuh = " +
                                snapshot.data[index].b.toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text("Meninggal = " +
                                snapshot.data[index].o.toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text("Dirawat = " +
                                snapshot.data[index].c.toString()),
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

class DuaDetail {
  int a;
  String uuid;
  int b;
  int c;
  int o;

  DuaDetail({
    this.uuid,
    this.a,
    this.b,
    this.o,
    this.c,
  });

  factory DuaDetail.fromJson(json) {
    return DuaDetail(
      a: json['kasus'],
      uuid: json['provinsi'],
      b: json['sembuh'],
      o: json['meninggal'],
      c: json['dirawat'],
    );
  }
}

Future<List<DuaDetail>> fetchDetails(uuid) async {
  String api =
      'https://apicovid19indonesia-v2.vercel.app/api/indonesia/provinsi?name=$uuid';
  final response = await http.get(
    Uri.parse(api),
    // headers: headers,
  );

  if (response.statusCode == 200) {
    print(response.body);
    print(response.statusCode);
    var driversShowsJson = jsonDecode(response.body) as List,
        driversShows =
            driversShowsJson.map((top) => DuaDetail.fromJson(top)).toList();

    return driversShows;
  } else {
    throw Exception('Failed to load drivers');
  }
}
