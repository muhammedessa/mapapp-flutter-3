import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';


var api_key = "AIzaSyDrHKl8IxB4cGXIoELXQOzzZwiH1xtsRf4";

void main() {
  MapView.setApiKey(api_key);
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
  ));
}



class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var compositeSubscription = new CompositeSubscription();
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider = new StaticMapProvider(api_key);
  Uri staticMapUri;

  //Marker bubble
  List<Marker> _markers = <Marker>[

    new Marker("1", "Sulaymaniyah 1", 35.572922, 45.442752,
      color: Colors.blue,
    ),

    new Marker("2", "Sulaymaniyah 2", 35.571686, 45.437107,
      color: Colors.deepOrange,
    ),
  ];





  showMap() {
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,

            initialCameraPosition: new CameraPosition(
                new Location(35.555736, 45.436535), 12.0),
            hideToolbar: false,
            title: "Recently Visited"),
        toolbarActions: [new ToolbarAction("Close", 1)]);
    mapView.setMarkers(_markers);
    mapView.zoomToFit(padding: 100);

      mapView.onMapTapped
        .listen((_) {
          setState(() {
            mapView.setMarkers(_markers);
            mapView.zoomToFit(padding: 100);
          });
      });


    //2. Listen for the onMapReady
    var sub = mapView.onMapReady.listen((_)  {debugPrint('');});
    compositeSubscription.add(sub);


    //4. Listen for toolbar actions
    sub = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });
    compositeSubscription.add(sub);


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraPosition = new CameraPosition(new Location(35.555736, 45.436535), 12.0 );
    staticMapUri = staticMapProvider.getStaticUri(
        new Location(35.555736, 45.436535), 12,height: 400,width: 900
        ,mapType: StaticMapViewType.roadmap
    );
  }


  @override
  Widget build(BuildContext context) {





    return  new Scaffold(
          appBar: new AppBar(
            title: new Text('My Map'),
          ),
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                height: 250.0,
                child: new Stack(
                  children: <Widget>[
                    new Center(
                        child: new Container(
                          child: new Text(
                            "Map should show here !",
                            textAlign: TextAlign.center,
                          ),
                          padding: const EdgeInsets.all(20.0),
                        )),
                    new InkWell(
                      child: new Center(
                        child: new Image.network(staticMapUri.toString()),
                      ),
                      onTap: showMap,
                    )
                  ],
                ),
              ),
              new Container(
                padding: new EdgeInsets.only(top: 10.0),
                child: new Text(
                  "Tap the map to interact",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new Container(
                padding: new EdgeInsets.only(top: 25.0),
                child:
                new Text("Camera Position: \n\nLat: ${cameraPosition.center
                    .latitude}\n\nLng:${cameraPosition.center
                    .longitude}\n\nZoom: ${cameraPosition.zoom}"),
              ),
            ],
          )
    );












  }







}


class CompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}