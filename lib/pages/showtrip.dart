import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_first_app/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/response/trip_get_res.dart';
import 'package:my_first_app/pages/profile.dart';
import 'package:my_first_app/pages/trip.dart';

class ShowTripPage extends StatefulWidget {
  int cid = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = "";
  List<TripGetResponse> tripGetResponses = [];
  List<TripGetResponse> allTrips = [];

  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                child: Text('ข้อมูลส่วนตัว'),
                value: 'profile',
              ),
              PopupMenuItem<String>(child: Text('ออกจากระบบ'), value: 'logout'),
            ],
          ),
        ],
      ),
      body:
          // Load dara from API
          // working => Loading Indocator
          FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }
              // done => show data
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ปลายทาง'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8,
                        children: [
                          FilledButton(
                            onPressed: getTrips,
                            child: Text("ทั้งหมด"),
                          ),
                          FilledButton(
                            onPressed: Asia_zone,
                            child: Text("เอเชีย"),
                          ),
                          FilledButton(
                            onPressed: Europe_zone,
                            child: Text("ยุโรป"),
                          ),
                          FilledButton(
                            onPressed: Asean_zone,
                            child: Text("อาเซียน"),
                          ),
                          FilledButton(
                            onPressed: Thai_zone,
                            child: Text("ประเทศไทย"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tripGetResponses
                              .map(
                                (e) => Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        spacing: 12,
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            height: 150,
                                            child: Image.network(
                                              e.coverimage,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => SizedBox(width: 100),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('ประเทศ ${e.country}'),
                                              Text('ระยะเวลา ${e.duration}'),
                                              Text('ราคา ${e.price}'),
                                              FilledButton(
                                                onPressed: () =>
                                                    gotoTrip(e.idx),
                                                child: Text('รายละเอียด'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          //   Card(
                          //     child: Row(
                          //       children: [
                          //         SizedBox(
                          //           width: 150,
                          //           height: 150,
                          //           child: Image.network(
                          //             'https://cdn.britannica.com/65/162465-050-9CDA9BC9/Alps-Switzerland.jpg',
                          //           ),
                          //         ),
                          //         Column(
                          //           children: [
                          //             Text(
                          //               ' ประเทศสวิตเซอร์แลนด์ \n ระยะเวลา 10 วัน \n ราคา 1199000',
                          //             ),
                          //             FilledButton(
                          //               onPressed: () {},
                          //               child: Text('รายละเอียด'),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  void gotoTrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }

  void Asia_zone() {
    List<TripGetResponse> Asia = [];

    for (var trip in tripGetResponses) {
      if (trip.destinationZone == 'เอเชีย') {
        Asia.add(trip);
      }
    }
    setState(() {
      tripGetResponses = allTrips
          .where((trip) => trip.destinationZone == 'เอเชีย')
          .toList();
    });
    log("เอเชีย");
  }

  void Europe_zone() {
    List<TripGetResponse> Europe = [];

    for (var trip in tripGetResponses) {
      if (trip.destinationZone == 'ยุโรป') {
        Europe.add(trip);
      }
    }
    setState(() {
      tripGetResponses = allTrips
          .where((trip) => trip.destinationZone == 'ยุโรป')
          .toList();
    });
    log("ยุโรป");
  }

  void Asean_zone() {
    List<TripGetResponse> Asean = [];

    for (var trip in tripGetResponses) {
      if (trip.destinationZone == 'เอเชียตะวันออกเฉียงใต้') {
        Asean.add(trip);
      }
    }
    setState(() {
      tripGetResponses = allTrips
          .where((trip) => trip.destinationZone == 'เอเชียตะวันออกเฉียงใต้')
          .toList();
    });
    log("อาเซียน");
  }

  void Thai_zone() {
    List<TripGetResponse> Thai = [];

    for (var trip in tripGetResponses) {
      if (trip.destinationZone == 'ประเทศไทย') {
        Thai.add(trip);
      }
    }
    setState(() {
      tripGetResponses = allTrips
          .where((trip) => trip.destinationZone == 'ประเทศไทย')
          .toList();
    });
    log("ประเทศไทย");
  }

  Future<void> getTrips() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    // setState(() {
    tripGetResponses = tripGetResponseFromJson(res.body);
    // });
    log("ทั้งหมด");
    allTrips = tripGetResponses;
    setState(() {
      tripGetResponses = allTrips;
    });
  }
}
