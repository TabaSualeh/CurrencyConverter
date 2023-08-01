// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:currency_converter/models/currencyrates.dart';
import 'package:currency_converter/models/ratedata.dart';
import 'package:currency_converter/widget/currencybar.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  currencyRate currency = currencyRate();

  List<RateData> _rateDataList = [];
  Map currencyData = {};
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getCurrencyRate();
    });
    super.initState();
  }

  Future<void> getCurrencyRate({String Currency = "USD"}) async {
    showDialog(
        context: context,
        builder: (context) {
          print("Loading start");
          return const Center(
              child: CupertinoActivityIndicator(
            radius: 25,
            color: Colors.white60,
          ));
        });

    http.Response response = await http
        .get(Uri.parse("https://open.er-api.com/v6/latest/$Currency"));
    print(response.statusCode);
    final decoded = jsonDecode(response.body);
    final Map<String, dynamic> rates = decoded['rates'];
    currencyData = decoded['rates'];
    setState(() {
      currency = currencyRate.fromJson(jsonDecode(response.body));
      rates.forEach((currencyCode, rate) {
        _rateDataList.add(RateData(
            currencyCode: currencyCode,
            rate: rate,
            Currentcurrency: currency.baseCode));
      });
    });
    Navigator.of(context).pop();
  }

  bool _showSearch = false;
  String currencyName = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: _showSearch
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      color: Color(0xff212436)),
                  child: TextField(
                    style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                    autofocus: true,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _showSearch = false;
                    },
                    onSubmitted: ((value) {}),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: Colors.white60.withOpacity(0.3),
                          fontWeight: FontWeight.w600),
                      hintText: 'Type Your Currency',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                )
              : Text("Currency Converter",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
          centerTitle: true,
          actions: [
            IconButton(
              color: Colors.white60,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: _showSearch
                  ? const Icon(Icons.cancel_rounded)
                  : Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _showSearch = !_showSearch;
                });
              },
            ),
          ],
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Color(0xff0F111E),
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage("assets/Frame.png"))),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 65, 10, 15),
            child: Column(
              children: [
                Text("Current Currency"),
                TextButton(
                  onPressed: (() {
                    _showDropdownMenu(context, currency.baseCode);
                  }),
                  child: currency.baseCode != null
                      ? Text(
                          "${currency.baseCode}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 40),
                        )
                      : Text(
                          "---",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 40),
                        ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Color(0xff2F2F34),
                        borderRadius: BorderRadius.circular(50)),
                    child: currency.timeNextUpdateUtc != null
                        ? Text(currency.timeNextUpdateUtc!.substring(0, 16))
                        : Text("--/--/--")),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.only(top: 15),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: ((context, index) {
                        var titlekey = currencyData.keys.elementAt(index);
                        var value = currencyData[titlekey];
                        return CurrencyBar(
                          titleKey: titlekey,
                          value: value,
                          myCallback: () {
                            showBottomSheet(
                                titlekey,
                                value.toStringAsFixed(2),
                                currency.baseCode,
                                currencyData[currency.baseCode]
                                    .toStringAsFixed(2));
                          },
                        );
                      }),
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 1,
                          endIndent: 19,
                          indent: 19,
                          color: Color(0xff212436),
                        );
                      },
                      itemCount: currencyData.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet(
      var ratekey, var rateValue, var basecode, var baseValue) {
    baseValue = double.parse(baseValue.toString());
    rateValue = double.parse(rateValue.toString());
    TextEditingController rateController =
        TextEditingController(text: "$rateValue");
    TextEditingController baseController =
        TextEditingController(text: "$baseValue");

    showModalBottomSheet(
        backgroundColor: Color(0xff1A1B27),
        elevation: 1,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.fromLTRB(
                25, 25, 25, MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                    //IMage
                    image: AssetImage("assets/comparison.png")),
                //TextField 1
                Container(
                  margin: EdgeInsets.only(top: 29, bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xff212436)),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: baseController,
                          style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                          onChanged: ((value) {
                            setState(() {
                              if (value != null) {
                                rateController.text =
                                    (double.parse(value) * rateValue)
                                        .toStringAsFixed(2);
                              }
                            });
                          }),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text("$basecode"),
                    ],
                  ),
                ),
                //TextField 2
                Container(
                  margin: EdgeInsets.only(bottom: 61),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      color: Color(0xff212436)),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          // readOnly: true,
                          keyboardType: TextInputType.number,
                          controller: rateController,
                          style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                          onChanged: ((value) {
                            setState(() {
                              if (value != null) {
                                baseController.text = ((baseValue / rateValue) *
                                        double.parse(value))
                                    .toStringAsFixed(2);
                              }
                            });
                          }),
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: Colors.white60.withOpacity(0.3),
                                fontWeight: FontWeight.w600),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text("$ratekey")
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void _showDropdownMenu(BuildContext context, String? Currentcurrency) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Currencies'),
          content: DropdownButtonHideUnderline(
            child: DropdownButton<RateData>(
              borderRadius: BorderRadius.circular(18),
              elevation: 10,
              dropdownColor: Color(0xff0F111D),
              focusColor: Colors.white,
              isExpanded: true,
              style: GoogleFonts.urbanist(
                  color: Color(0xffFFFFFF),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
              hint: Text(
                "$Currentcurrency",
                style: GoogleFonts.urbanist(
                    color: Color(0xffFFFFFF),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              items: _rateDataList.map((RateData data) {
                return DropdownMenuItem<RateData>(
                  value: data,
                  child: Text('${data.currencyCode}'),
                );
              }).toList(),
              onChanged: (RateData? selectedRate) {
                if (selectedRate != null) {
                  getCurrencyRate(Currency: selectedRate.currencyCode);
                }
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}
