import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ureca_restaurant_reviews_flutter/models/dining-area-detail-model.dart';
import 'package:ureca_restaurant_reviews_flutter/util/constants.dart';

class DiningAreaDetailPage extends StatefulWidget {
  int id = 1;
  DiningAreaDetailPage({int id}) {
    this.id = id;
  }

  @override
  _DiningAreaDetailPageState createState() =>
      _DiningAreaDetailPageState(id: id);
}

class _DiningAreaDetailPageState extends State<DiningAreaDetailPage>
    with TickerProviderStateMixin {
  int id;
  _DiningAreaDetailPageState({int id}) {
    this.id = id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40.0,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "LOCATION DETAIL",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: new FutureBuilder<DiningAreaDetailModel>(
        future: getDiningArea(this.id),
        builder: (context, snapshot) {
          return _buildDiningAreaDetailsPage(context, snapshot.data);
        },
      ),
      //bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Future<DiningAreaDetailModel> getDiningArea(int id) async {
    final response = await get(
        Constants.API_RESOURCE_URL + '/webapp/api/diningarea/' + id.toString());
    dynamic responseJson = json.decode(response.body.toString());

    DiningAreaDetailModel diningArea =
        DiningAreaDetailModel.fromJson(responseJson);

    return diningArea;
  }

  _buildDiningAreaDetailsPage(
      BuildContext context, DiningAreaDetailModel model) {
    Size screenSize = MediaQuery.of(context).size;

    return ListView(
      children: <Widget>[
        Container(
          child: Card(
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDiningAreaImagesWidgets(model.images),
                _buildNameWidget(model.name),
                SizedBox(height: 12.0),
                _buildBasicInfoWidgets(model.addr, 'address'),
                SizedBox(height: 12.0),
                _buildBasicInfoWidgets(model.subLoc, 'subLoc'),
                SizedBox(height: 12.0),
                _buildBasicInfoWidgets(model.phoneNo, 'phoneNo'),
                SizedBox(height: 12.0),
                _buildBasicInfoWidgets(model.operatingHour, 'operatingHour'),
                SizedBox(height: 12.0),
                _buildBasicInfoWidgets(model.capacity.toString(), 'capacity'),
                SizedBox(height: 12.0),
                // _buildDivider(screenSize),
                // SizedBox(height: 12.0),
                // _buildFurtherInfoWidget(),
                // SizedBox(height: 12.0),
                // _buildDivider(screenSize),
                // SizedBox(height: 12.0),
                // _buildSizeChartWidgets(),
                // SizedBox(height: 12.0),
                // _buildDetailsAndMaterialWidgets(),
                // SizedBox(height: 12.0),
                // _buildStyleNoteHeader(),
                // SizedBox(height: 6.0),
                // _buildDivider(screenSize),
                // SizedBox(height: 4.0),
                // _buildStyleNoteData(),
                // SizedBox(height: 20.0),
                // _buildMoreInfoHeader(),
                // SizedBox(height: 6.0),
                // _buildDivider(screenSize),
                // SizedBox(height: 4.0),
                // _buildMoreInfoData(),
                // SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildDivider(Size screenSize) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[600],
          width: screenSize.width,
          height: 0.25,
        ),
      ],
    );
  }

  _buildDiningAreaImagesWidgets(List<String> images) {
    List<Widget> imageWidgets = [];
    imageWidgets.addAll(images
        .map((image) => Image.network(Constants.API_RESOURCE_URL + image)));

    TabController imagesController =
        TabController(length: imageWidgets.length, vsync: this);

    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
      child: Container(
        height: 250.0,
        child: Center(
          child: DefaultTabController(
            length: imageWidgets.length,
            child: Stack(
              children: <Widget>[
                TabBarView(
                  controller: imagesController,
                  children: imageWidgets,
                ),
                Container(
                  alignment: FractionalOffset(0.5, 0.95),
                  child: TabPageSelector(
                    controller: imagesController,
                    selectedColor: Colors.grey,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildNameWidget(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Center(
        child: Text(
          name,
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
      ),
    );
  }

  _buildBasicInfoWidgets(String text, String type) {
    Icon icon;
    switch (type) {
      case 'address':
        icon = new Icon(
          Icons.room,
          color: Colors.red[600],
        );
        break;
      case 'subLoc':
        icon = new Icon(
          Icons.pin_drop,
          color: Colors.blue[600],
        );
        break;
      case 'phoneNo':
        icon = new Icon(
          Icons.phone,
          color: Colors.green[600],
        );
        break;
      case 'operatingHour':
        icon = new Icon(
          Icons.timer,
          color: Colors.grey[600],
        );
        break;
      case 'capacity':
        text += ' Seats';
        icon = new Icon(
          Icons.local_dining,
          color: Colors.grey[600],
        );
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          icon,
          SizedBox(
            width: 8.0,
          ),
          new Container(
            padding: const EdgeInsets.all(4.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  text,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildFurtherInfoWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.local_offer,
            color: Colors.grey[500],
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            "Tap to get further info",
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  _buildSizeChartWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.straighten,
                color: Colors.grey[600],
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(
                "Size",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Text(
            "SIZE CHART",
            style: TextStyle(
              color: Colors.blue[400],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildDetailsAndMaterialWidgets() {
    TabController tabController = new TabController(length: 2, vsync: this);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "DETAILS",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "MATERIAL & CARE",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            height: 40.0,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                Text(
                  "76% acrylic, 19% polyster, 5% metallic yarn Hand-wash cold",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "86% acrylic, 9% polyster, 1% metallic yarn Hand-wash cold",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildStyleNoteHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ),
      child: Text(
        "STYLE NOTE",
        style: TextStyle(
          color: Colors.grey[800],
        ),
      ),
    );
  }

  _buildStyleNoteData() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ),
      child: Text(
        "Boys dress",
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  _buildMoreInfoHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ),
      child: Text(
        "MORE INFO",
        style: TextStyle(
          color: Colors.grey[800],
        ),
      ),
    );
  }

  _buildMoreInfoData() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ),
      child: Text(
        "Product Code: 410\nTax info: Applicable GST will be charged at the time of chekout",
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "SAVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.greenAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.card_travel,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "ADD TO BAG",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
