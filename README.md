# imageview360

 A Flutter package which provides 360 view of the images with rotation and gesture customisations.


## Supported Dart Versions
**Dart SDK version >= 2.1.0**

## Demo Gif
<img src="https://raw.githubusercontent.com/hd-motion/flutter_imageview_360/master/example/demo/imageview360.gif" height="35%" width="35%"  alt="imageview360 Demo"/>

## Installation
[![Pub](https://img.shields.io/badge/pub-1.2.0-blue)](https://pub.dev/packages/imageview360)

Add the Package
```yaml
dependencies:
  imageview360: ^1.2.0
```
## How to use

Import the package in your dart file

```dart
import 'package:imageview360/imageview360.dart';

```

##### Basic usage :

```dart
ImageView360(
     key: UniqueKey(),
     imageList: imageList,
),
```

Note: For ImageView360 to show instant changes on hot reload, you need to provide `UniqueKey()` so that the widget rebuilds every time.

##### Customisable usage :
```dart
ImageView360(
    key: UniqueKey(),                                           
    imageList: imageList,                                       
    autoRotate: true,                                           //Optional
    rotationCount: 2,                                           //Optional
    rotationDirection: RotationDirection.anticlockwise,         //Optional
    frameChangeDuration: Duration(milliseconds: 50),            //Optional
    swipeSensitivity: 2,                                        //Optional
    allowSwipeToRotate: true,                                   //Optional
    onImageIndexChanged: (currentImageIndex) {                  //Optional
                          print("currentImageIndex: $currentImageIndex");
                        },
)
```
Note: For better experience always precache image before providing the images to the widget as follows.

##### Example for loading and precaching images from assets :

```dart
 List<ImageProvider> imageList = List<ImageProvider>();
   for (int i = 1; i <= 52; i++) {
      imageList.add(AssetImage('assets/sample/$i.png'));
// To precache images so that when required they are loaded faster.
      await precacheImage(AssetImage('assets/sample/$i.png'), context);
    }
```

### Mandatory fields

| Attribute           | Type                | Usage                 |
| -------------       | ------------------- | --------------        |
| imageList           | List<ImageProvider> | The list of images to be displayed|
### Customisable fields

| Attribute           | Type                | Default Value                 |
| -------------       | ------------------- | --------------                |
| autoRotate          | bool                | false                         |
| rotationCount       | int                 | 1                             |
| rotationDirection   | RotationDirection   | RotationDirection.clockwise   |
| frameChangeDuration | Duration            | Duration(milliseconds: 80)    |
| swipeSensitivity    | int                 | 1 (Note : Range allowed is 1-5 , less than 1 would be considered 1 and more than 5 would be considered 5)                      |
| allowSwipeToRotate  | bool                | true                          |
| onImageIndexChanged | Function(int)       | (currentImageIndex){}         |

# Blog Post

To have a better understanding how this package works under the hood, checkout my blog post: [360 degree image showcase in Flutter](https://proandroiddev.com/360-degree-image-showcase-in-flutter-ee53a49e8975)


### Created & Maintained By

[Harpreet Singh](https://github.com/harpreetseera) 

[Damanpreet Singh](https://github.com/damanpreetsb) 

# License
```
Copyright 2020 Harpreet Singh & Damanpreet Singh

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
