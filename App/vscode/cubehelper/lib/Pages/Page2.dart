import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key, required this.title});

  final String title;

  @override
  State<Page2> createState() => Page2State();
}

enum ViewType { ListView, TableView, VisualSpoiler }

// card list
class Page2State extends State<Page2> {
  ViewType? _selectedView = ViewType.ListView;

  @override
  void initState() {
    super.initState();
  }

// String imageUrl =
//     'https://cards.scryfall.io/large/front/8/9/89b03b9a-7e20-47cb-bc64-23513acea855.jpg?1592710322';
//

//
// Future<void> loadImage() async {
//   var response = await http.get(Uri.parse(imageUrl));
//

/* case 1

  late ImageProvider _imageProvider;

  Future<void> fetchCard() async {


    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      _imageProvider = MemoryImage(response.bodyBytes);
    } else {
      throw Exception('Failed to load card data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchCard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              width: 100.0,
              height: 150.0,
              color: Colors.grey,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(
          child: Image(
            image: _imageProvider,
          ),
        );
      },
    );
  }
  */ // case 1

  //             'https://cards.scryfall.io/large/front/8/9/89b03b9a-7e20-47cb-bc64-23513acea855.jpg?1592710322'

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Switcher'),
        actions: <Widget>[
          DropdownButton<ViewType>(
            value: _selectedView,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (ViewType? newValue) {
              setState(() {
                _selectedView = newValue;
              });
            },
            items: <DropdownMenuItem<ViewType>>[
              DropdownMenuItem<ViewType>(
                value: ViewType.ListView,
                child: Text('List View'),
              ),
              DropdownMenuItem<ViewType>(
                value: ViewType.TableView,
                child: Text('Table View'),
              ),
              DropdownMenuItem<ViewType>(
                value: ViewType.VisualSpoiler,
                child: Text('Visual Spoiler'),
              ),
            ],
          ),
        ],
      ),
      body: _cardListUI(),
    );
  }

  Widget buildBefore(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
          imageUrl:
              'https://cards.scryfall.io/large/front/0/9/090a5f1f-9a1a-4e93-8c33-a0204c2917d5.jpg?1562428174',
          placeholder: (context, url) => Container(
                width: 300.0,
                height: 400.0,
                color: Colors.grey,
                child: CircularProgressIndicator(),
              ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover),
    );
  }

  Widget _cardListUI() {
    switch (_selectedView) {
      case ViewType.ListView:
        return ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('List View Item $index'),
            );
          },
        );
      case ViewType.TableView:
        return ListTile(
          title: Text('table view'),
        );
        break;
      case ViewType.VisualSpoiler:
        return ListTile(
          title: Text('visual spoiler'),
        );
        break;
      default:
        return Center(child: Text('Please select a view type'));
    }
  }
}
