
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main () {
  runApp(MaterialApp(
    home: Profile(),
  )
  );
}
class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Data Donor Darah 2014 dan 2016 Bandung',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/1.jpg'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Anadda Ferrell',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 4,
              ),
              Text('21120119130035'),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetailDataSatu()));
                  },
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.pink,Colors.redAccent]
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 100.0,maxHeight: 40.0,),
                      alignment: Alignment.center,
                      child: Text(
                        "Data Covid",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
            ]
            ),
      ),
    )
    );
  }
}

class DetailDataSatu extends StatefulWidget {
  final String item;
  DetailDataSatu({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  _DetailDataSatuState createState() => _DetailDataSatuState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
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
          'Data covid',
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
                            Text("positif = " +
                                snapshot.data[index].positif.toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text("sembuh = " + snapshot.data[index].sembuh.toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text("dirawat = " + snapshot.data[index].dirawat.toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text("meninggal = " + snapshot.data[index].meninggal.toString()),
                            
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
  int positif;
  String name;
  int sembuh;
  int meninggal;
  int dirawat;

  SatuDetail({this.name, this.positif, this.dirawat, this.meninggal, this.sembuh});

  factory SatuDetail.fromJson(json) {
    return SatuDetail(
      name: json['Indonesia'],
      positif: json['positif'],
      dirawat: json['dirawat'],
      meninggal: json['meninggal'],
      sembuh: json['sembuh'],
    );
  }
}

Future<List<SatuDetail>> fetchDetails() async {
  String api =
      'https://api.kawalcorona.com/indonesia/';
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
    throw Exception('Failed to load');
  }
}