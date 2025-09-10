import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_first_app/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/response/trip_idx_get_res.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});
  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  late Future<void> loadData;
  late TripIdxGetResponse tripIdxGetResponse;
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('รายละเอียดทริป')),
      body: FutureBuilder(
        future: loadData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tripIdxGetResponse.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(tripIdxGetResponse.country),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 16,
                    child: Image.network(tripIdxGetResponse.coverimage),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ราคา ${tripIdxGetResponse.price.toString()} บาท'),
                        Text('โซน${tripIdxGetResponse.destinationZone}'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tripIdxGetResponse.detail),
                        FilledButton(onPressed: () {}, child: Text('จองเลย!!')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResponseFromJson(res.body);
    log("awdawdad");
  }
}
