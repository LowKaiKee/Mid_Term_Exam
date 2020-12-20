import 'dart:convert';

import 'package:book_store/book.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final Book bk;

  const DetailScreen({Key key, this.bk}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List bookDetails;

  double screenHeight, screenWidth;
  String titlecenter = "Loading books data...";

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Book ID: "+widget.bk.bookid),
      ),
      body: Column(children: [
        Container(
            height: 100,
            width: 100,
            child: CachedNetworkImage(
              imageUrl:
                  "http://slumberjer.com/bookdepo/bookcover/${widget.bk.cover}.jpg",
              fit: BoxFit.fill,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(
                Icons.broken_image,
              ),
            )),
        SizedBox(height: 10),
        Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Title: " + widget.bk.booktitle),
              Text("Author: " + widget.bk.author),
              Text("Price: RM " + widget.bk.price),
              Text("Rating: " + widget.bk.rating),
              Text("Publisher:" + widget.bk.publisher),
              Text("ISBN: " + widget.bk.isbn),
              Text("Description: " + widget.bk.description)
            ],
          ),
        ))
      ]),
    );
  }

  void _loadDetails() {
    print("Load Books Details");
    http.post("http://slumberjer.com/bookdepo/php/load_books.php", body: {
      'bookid': widget.bk.bookid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookDetails = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          bookDetails = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
