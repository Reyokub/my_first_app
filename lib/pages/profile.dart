import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/response/customers_idx_get_res.dart';

class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String url = '';
  late Future<void> loadData;
  late CustomerIdxGetResponse customerIdxGetResponse;
  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    log('${widget.idx}');

    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              log(value);
              delete();
            },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('ยกเลิกสมาชิก'), value: 'delete'),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      customerIdxGetResponse.image,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: fullnameCtl,
                                decoration: InputDecoration(
                                  labelText: 'ชื่อ-นามสกุล',
                                ),
                              ),
                              TextField(
                                controller: phoneCtl,
                                decoration: InputDecoration(
                                  labelText: 'โทรศัพท์',
                                ),
                              ),
                              TextField(
                                controller: emailCtl,
                                decoration: InputDecoration(
                                  labelText: 'อีเมลล์',
                                ),
                              ),
                              TextField(
                                controller: imageCtl,
                                decoration: InputDecoration(
                                  labelText: 'รูปภาพ',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: FilledButton(
                      onPressed: update,
                      child: Text("บันทึกข้อมูล"),
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

  void update() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    // ข้อมูลขาส่งออกไปหา API
    var json = {
      "fullname": fullnameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text,
    };
    log(json.toString());
    var res = await http.put(
      Uri.parse('$url/customers/${widget.idx}'),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      // map to JSON
      body: jsonEncode(json),
    );
    log(res.body);
    // JSON String to map
    var result = jsonDecode(res.body);
    log(result['message']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('สำเร็จ'),
        content: const Text('บันทึกข้อมูลเรียบร้อย'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    log(res.body);
    customerIdxGetResponse = customerIdxGetResponseFromJson(res.body);
    setState(() {
      fullnameCtl.text = customerIdxGetResponse.fullname;
      phoneCtl.text = customerIdxGetResponse.phone;
      emailCtl.text = customerIdxGetResponse.email;
      imageCtl.text = customerIdxGetResponse.image;
    });
  }

  void delete() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'ยืนยันการยกเลิกสมาชิก',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'),
              ),
              FilledButton(
                onPressed: () async {
                  // delete ข้อมูล
                  var config = await Configuration.getConfig();
                  var url = config['apiEndpoint'];
                  var res = await http.delete(
                    Uri.parse('$url/customers/${widget.idx}'),
                  );
                  log(res.statusCode.toString());
                  if (res.statusCode == 200) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('สำเร็จ'),
                        content: Text('ลบข้อมูลสำเร็จ'),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            },
                            child: const Text('ปิด'),
                          ),
                        ],
                      ),
                    ).then((s) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    });
                  } else {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('ผิดพลาด'),
                        content: Text('ลบข้อมูลไม่สำเร็จ'),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('ปิด'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('ยืนยัน'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
