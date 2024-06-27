import 'package:flutter/material.dart';

import '../Global/global.dart';
import '../Global/define.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ColumnData {
  final String categoryName;
  final List<String> cardNames;

  ColumnData({required this.categoryName, required this.cardNames});
}

class ColumnAttribute {
  final int index;
  final String name;
  final Color color;

  ColumnAttribute(
      {required this.index, required this.name, required this.color});
}

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

  List<Card_DB>? refCards;

  List<ColumnAttribute> columns = [
    ColumnAttribute(index: 0, name: 'White', color: Colors.white),
    ColumnAttribute(index: 1, name: 'Blue', color: Colors.blue),
    ColumnAttribute(index: 2, name: 'Black', color: Colors.black),
    ColumnAttribute(index: 3, name: 'Red', color: Colors.red),
    ColumnAttribute(index: 4, name: 'Green', color: Colors.green),
    ColumnAttribute(index: 5, name: 'Multicolor', color: Colors.orange),
    ColumnAttribute(index: 6, name: 'Colorless', color: Colors.grey),
    ColumnAttribute(index: 7, name: 'Land', color: Colors.brown),
  ];

  List<List<ColumnData>> columnData = [
    [
      ColumnData(
        categoryName: 'creature',
        cardNames: ['Card 1', 'Card 2', 'Card 3', 'Card 4', 'Card 5'],
      ),
      ColumnData(
        categoryName: 'instant',
        cardNames: ['Card 6', 'Card 7', 'Card 8', 'Card 9', 'Card 10'],
      ),
    ],

    [
      ColumnData(
        categoryName: 'instatnt',
        cardNames: ['blue 1', 'blue 2', 'Card 3', 'Card 4', 'Card 5'],
      ),
      ColumnData(
        categoryName: 'sorcery',
        cardNames: ['blue 6', 'blue7', 'Card 8', 'Card 9', 'Card 10'],
      ),
    ],
    // Add more List<ColumnData> instances for other categories...
  ];

  @override
  void initState() {
    super.initState();

    G.Log("ACH - Page2 activate");

    G.Log("ACH - Selected Cube - ${Global.selectedCube.name}");

    refCards = Global.getCurrentCubeCardList();

    if (refCards == null) {
      G.Log("ACH - Selected Cube's cards null ");
    } else {
      int len = refCards?.length ?? 0;

      G.Log("ACH - Selected Cube Cards - $len");
    }
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

  bool _hasSelectedCube() {
    return refCards != null && refCards?.isNotEmpty == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Switcher'),
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
            items: const <DropdownMenuItem<ViewType>>[
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
      body: _hasSelectedCube()
          ? _cardListUI()
          : const Center(child: Text('선택된 정보가 없습니다.')),
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
                child: const CircularProgressIndicator(),
              ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover),
    );
  }

  Widget _cardListUI() {
    switch (_selectedView) {
      case ViewType.ListView:
        return _page2ListViewItem();
      case ViewType.TableView:
        return _page2TableViewItem();
        break;
      case ViewType.VisualSpoiler:
        return _buildImageView();
        break;
      default:
        return const Center(child: Text('Please select a view type'));
    }
  }

  ///////////////////////////////////////////////////////////////////
  // ViewType.ListView UI
  Widget _page2ListViewItem() {
    return ListView.builder(
      itemCount: refCards?.length,
      itemBuilder: (context, index) {
        String name = refCards?[index].refStorage.smallImageUrl ?? "";
        String truncatedName =
            name.length > 20 ? name.substring(0, 20) + "..." : name;

        return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "$name\nCMC: ${refCards?[index].refStorage.manaCost ?? "N/A"}"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      truncatedName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                        "${refCards?[index].refStorage.manaCost ?? "N/A"}"),
                  ),
                ],
              ),
            ));
      },
    );
  }

  ///////////////////////////////////////////////////////////////////
  // ViewType.TableView
  Widget _page2TableViewItem() {
    return ListView.builder(
      itemCount: columns.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(
            columns[index].name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: List.generate(
            columnData[index].length,
            (categoryIndex) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    columnData[index][categoryIndex].categoryName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount:
                        columnData[index][categoryIndex].cardNames.length,
                    itemBuilder: (context, itemIndex) {
                      return Card(
                        color: columns[index].color,
                        child: Center(
                          child: Text(columnData[index][categoryIndex]
                              .cardNames[itemIndex]),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  ///////////////////////////////////////////////////////////////////
  // ViewType.VisualSpoiler
  Widget _buildImageView() {
    int len = refCards?.length ?? 0;

    if (len == 0) {
      return const Center(child: Text('카드 정보가 잘 못 되었습니다.'));
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: len,
      itemBuilder: (context, index) {
        return _buildCardImage(
            refCards?[index].refStorage.normalImageUrl ?? "");
      },
    );
  }

  Widget _buildCardImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
