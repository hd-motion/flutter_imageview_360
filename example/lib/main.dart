import 'package:flutter/material.dart';
import 'package:imageview360/imageview360.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImageView360 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DemoPage(title: 'ImageView360 Demo'),
    );
  }
}

class DemoPage extends StatefulWidget {
  DemoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  List<AssetImage> imageList = List<AssetImage>();
  bool autoRotate = false;
  bool imagePrecached = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateImageList(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (imagePrecached == true)
                ? ImageView360(
                    key: UniqueKey(),
                    imageList: imageList,
                    autoRotate: autoRotate,
                    rotationCount: 2,
                    // rotationDirection: RotationDirection.anticlockwise,
                  )
                : Text("Pre-Caching images..."),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            autoRotate = !autoRotate;
          });
        },
        tooltip: 'Start',
        child: Icon(autoRotate ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  void updateImageList(BuildContext context) async {
    for (int i = 1; i <= 52; i++) {
      imageList.add(AssetImage('assets/sample/$i.png'));
      var res =
          await precacheImage(AssetImage('assets/sample/$i.png'), context);
    }
    setState(() {
      imagePrecached = true;
    });
  }
}
