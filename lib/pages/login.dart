import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/request/customers_login_post_req.dart';
import 'package:my_first_app/model/request/response/customers_login_post_res.dart';
import 'package:my_first_app/pages/register.dart';
import 'package:my_first_app/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int n = 0;
  String phoneNo = '0812345678';
  String pass = '1234';
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController password = TextEditingController();
  String url = "";

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => login(),
              child: Image.asset('assets/images/Test.jpg'),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: 24)),
                  TextField(
                    controller: phoneCtl,
                    // onChanged: (value) {
                    //   phone = value;
                    //   log(value);
                    // },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),
                  Text('รหัสผ่าน', style: TextStyle(fontSize: 24)),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: register,
                    child: const Text(
                      'ลงทะเบียนใหม่',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            Text(text, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void login() {
    // var data = {"phone": "0817399999", "password": "1111"};
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneCtl.text,
      password: password.text,
    );
    http
        .post(
          Uri.parse("$url/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          // log(value.body);
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShowTripPage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
