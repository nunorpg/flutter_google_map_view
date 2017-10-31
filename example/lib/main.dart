import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

void main() {
  MapView.setApiKey("<your_key>");
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;

  @override
  initState() {
    super.initState();
    cameraPosition = new CameraPosition(new Location(0.0, 0.0), 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Plugin example app'),
          ),
          body: new Column(
            children: <Widget>[
              new MaterialButton(
                onPressed: showMap,
                child: new Text("Show Map"),
              ),
              new Text(
                  "Camera Position: ${cameraPosition.center.latitude}, ${cameraPosition.center.longitude}. Zoom: ${cameraPosition.zoom}"),
            ],
          )),
    );
  }

  showMap() {
    mapView.show(
        new MapOptions(
          showUserLocation: true,
          initialCameraPosition:
              new CameraPosition(new Location(45.5235258, -122.6732493), 14.0),
        ),
        toolbarActions: [new ToolbarAction("Close", 1)]);
    mapView.updateAnnotations(<MapAnnotation>[
      new MapAnnotation("1234", "Pin 1", 38.33527476, -122.408227),
      new MapAnnotation("2345", "Pin 2", 38.0322, -122.5443),
      new MapAnnotation("4567", "Pin 3", 38.01113, -122.2246),
    ]);
    mapView.zoomToFit();
    mapView.onLocationUpdated
        .listen((location) => print("Location updated $location"));
    mapView.onTouchAnnotation.listen(
        (annotation) => mapView.zoomTo(["1234", "4567"], padding: 75.0));
    mapView.onMapTapped
        .listen((location) => print("Touched location $location"));
    mapView.onCameraChanged.listen((cameraPosition) =>
        this.setState(() => this.cameraPosition = cameraPosition));
    mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        _handleDismiss();
      }
    });
  }

  _handleDismiss() async {
    double zoomLevel = await mapView.zoomLevel;
    Location centerLocation = await mapView.centerLocation;
    List<MapAnnotation> visibleAnnotations = await mapView.visibleAnnotations;
    print("Zoom Level: $zoomLevel");
    print("Center: $centerLocation");
    print("Visible Annotation Count: ${visibleAnnotations.length}");
    mapView.dismiss();
  }
}