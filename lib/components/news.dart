// ignore_for_file: camel_case_types

import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:drc/components/monthString.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class newList extends StatefulWidget {
  const newList({Key? key}) : super(key: key);

  @override
  _newListState createState() => _newListState();
}

class _newListState extends State<newList> {
  news() async {
    var url = await http.get(
        Uri.parse("https://min-api.cryptocompare.com/data/v2/news/?lang=EN"));
    return json.decode(url.body)['Data'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: news(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                  viewportFraction: 1,
                  pauseAutoPlayOnTouch: true,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index,
                        int pageViewIndex) =>
                    InkWell(
                      onTap: () {
                        launch(
                          snapshot.data[index]["url"],
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,

                          // color: const Color(0xFF0E3311).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                              child: Image.network(
                                snapshot.data[index]['imageurl'],
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                                height: 110,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Text(
                                  dateFormater(
                                      snapshot.data[index]['published_on']),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 5.0,
                              ),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  snapshot.data[index]['title'],
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Text(
                                  "- ${snapshot.data[index]['source']}",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        });
  }

  String dateFormater(date) {
    var postTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    var parsedPostTime = DateTime.parse(postTime.toString());

    var dateString =
        '${monthString(parsedPostTime.month)} ${parsedPostTime.day}, ${parsedPostTime.year}';
    return "Posted on $dateString";
  }
}
