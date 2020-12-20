import 'dart:convert';

import 'package:book_store/book.dart';
import 'package:book_store/detailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MaterialApp(
      home: MainScreen(),
    ));

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List bookList;

  double screenHeight, screenWidth;
  String titlecenter = "Loading books data...";

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('List of Books'),
      ),
      body: Column(
        children: [
          bookList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(titlecenter,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              )))))
              : Flexible(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                      bookList.length,
                      (index) {
                        return Padding(
                            padding: EdgeInsets.all(1),
                            child: Card(
                                child: InkWell(
                              onTap: () => _loadBookList(index),
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  Container(
                                      height: 100,
                                      width: 100,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "http://slumberjer.com/bookdepo/bookcover/${bookList[index]['cover']}.jpg",
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(
                                          Icons.broken_image,
                                        ),
                                      )),
                                  Text("Rating: " + bookList[index]['rating'],
                                      textAlign: TextAlign.center),
                                  Text("Title: " + bookList[index]['booktitle'],
                                      textAlign: TextAlign.center),
                                  Text("Author: " + bookList[index]['author'],
                                      textAlign: TextAlign.center),
                                  Text("RM " + bookList[index]['price'],
                                      textAlign: TextAlign.center),
                                ],
                              )),
                            )));
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _loadBook() {
    print("Loading books data");
    http.post("http://slumberjer.com/bookdepo/php/load_books.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data
          bookList = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadBookList(int index) {
    print(bookList[index]['booktitle']);
    Book book = new Book(
      bookid: bookList[index]['bookid'],
      booktitle: bookList[index]['booktitle'],
      author: bookList[index]['author'],
      price: bookList[index]['price'],
      description: bookList[index]['description'],
      rating: bookList[index]['rating'],
      publisher: bookList[index]['publisher'],
      isbn: bookList[index]['isbn'],
      cover: bookList[index]['cover'],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailScreen(bk: book)));
  }
}
