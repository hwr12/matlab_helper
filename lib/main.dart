import 'dart:convert';
import 'dart:math';

import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:matlab_helper/VideoPlayerPage.dart';
import 'package:provider/provider.dart';

import 'MatlabProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
          // ChangeNotifierProvider를 통해 변화에 대해 구독(하나만 구독 가능)
          create: (BuildContext context) =>
              MatlabProvider(), // count_provider.dart
          child: const MyHomePage(
              title:
                  'Flutter Demo Home Page') // home.dart // child 하위에 모든 것들은 CountProvider에 접근 할 수 있다.
          ),
      builder: EasyLoading.init(),
    );
  }
}

class Property {
  final int id;
  String label;
  String formula;
  final Color color;
  Property(this.id, this.label, this.formula, this.color);

  void setFormula(String formula) {
    this.formula = formula;
  }

  // tojson
  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'formula': formula,
        'color': color.value,
      };
  static Property fromJson(Map<String, dynamic> json) {
    return Property(
      json['id'] as int,
      json['label'] as String,
      json['formula'] as String,
      Color(json['color'] as int),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> startCordinates = [];
  List<int> endCordinates = [];
  Property? selectedProperty;
  Map<String, int> matrixAndProperty = {};
  Map<String, int> coordinateAndProperty = {};
  bool dragging = false;
  List<Property> propertyList = [];

  List<Color> commonColorList = [
    const Color(0xffFBFACD),
    const Color(0xffDEBACE),
    const Color(0xffBA94D1),
    const Color(0xffA8D1D1),
    const Color(0xff9F8772),
    const Color(0xffBCE29E),
    const Color(0xffE5EBB2),
    const Color(0xffF8C4B4),
    const Color(0xffFF8787),
    const Color(0xffEDE4E0),
    const Color(0xffC8DBBE),
    const Color(0xff98A8F8),
    const Color(0xff54BAB9),
    const Color(0xffFFDBA4),
    const Color(0xffFFF89A),
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.brown,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.amber,
    Colors.deepOrange,
    Colors.deepPurple,
  ];

  void _clearSelected() {
    startCordinates = [];
    endCordinates = [];
    setState(() {});
  }

  Future<void> loadAsset() async {
    EasyLoading.show(status: '로딩...');
    String goodgun1 = await rootBundle.loadString('assets/goodgun1.txt');
    jsonToDart(goodgun1);
    Future.delayed(const Duration(milliseconds: 1500), () {
      EasyLoading.dismiss();
    });
  }

  void codeGenerate() {
    String code = '';
    for (Property property in propertyList) {
      int id = property.id;
      String formula = property.formula;
      String matrix = matrixAndProperty.keys
          .where(
            (k) => matrixAndProperty[k] == id,
          )
          .join(';');
      if (formula.isNotEmpty) {
        String text =
            '% #$id\nsection_$id = {$matrix};\nlen = size(section_$id);\nm = len(1);\nfor index = 1:m\n    i_vec = section_$id{index,1};\n    j_vec = section_$id{index,2};\n    for iter1 = 1:length(i_vec)\n        for iter2 = 1:length(j_vec)\n            i = i_vec(iter1);\n            j = j_vec(iter2);\n            $formula\n        end\n    end\nend';
        code += '$text\n\n';
      }
    }
    Provider.of<MatlabProvider>(context, listen: false).setMatlabText(code);
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.light
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.green
      ..backgroundColor = Colors.transparent
      ..indicatorColor = Colors.green
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    MatlabProvider matlabProvider =
        Provider.of<MatlabProvider>(context, listen: false);

    matlabProvider.setConvertText(
        dartToJson([matrixAndProperty, coordinateAndProperty, propertyList]));
    text:
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            const Spacer(),
            Container(
              height: 900,
              child: Column(
                children: [
                  Container(
                    height: 100,
                  ),
                  Container(
                    height: 800,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '40',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '35',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '30',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '25',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '20',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '15',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '10',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '5',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  child: Column(
                    children: const [
                      Text(
                        '열전달 4조 matlab simulation helper',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text('좌표를 드래그 하여 구역 설정 -> 우측 리스트에서 라벨과 수식 설정 -> 코드 생성'),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  width: 800,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '0',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '5',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '10',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '15',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '20',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '25',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '30',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '35',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '40',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 800,
                  height: 800,
                  child: GridView.builder(
                    itemCount: 40 * 40, //item 개수
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 40, //1 개의 행에 보여줄 item 개수
                      childAspectRatio: 1, //item 의 가로 1, 세로 2 의 비율
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      int x = index % 40 + 1;
                      int y = 40 - index ~/ 40;
                      Color boxColor = Colors.white;
                      if (matrixAndProperty.isNotEmpty) {
                        //print('1');
                        int? propertyId = coordinateAndProperty['$x,$y'];
                        if (propertyId != null) {
                          boxColor = propertyList
                              .firstWhere((element) => element.id == propertyId)
                              .color;
                        }
                      }
                      List<String> coordiList = matrixAndProperty.keys
                          .where(
                              (element) => matrixAndProperty[element] == index)
                          .toList();

                      for (int i = 0; i < coordiList.length; i++) {
                        String coordi = coordiList[i];
                        List<String> coordiSplit = coordi.split(',');
                        int x = int.parse(coordiSplit[0]);
                        int y = int.parse(coordiSplit[1]);
                        if (x == 1 || y == 1 || x == 40 || y == 40) {
                          boxColor = Colors.black;
                        }
                      }
                      return Listener(
                        onPointerDown: (event) {
                          dragging = true;
                          startCordinates = [x, y];
                          endCordinates = [x, y];
                          setState(() {});
                        },
                        onPointerUp: (event) {
                          print(event);
                          dragging = false;
                          print(
                              'startCordinates : $startCordinates endCordinates : $endCordinates');
                          int toX = max(endCordinates[0], startCordinates[0]);
                          int fromX = min(endCordinates[0], startCordinates[0]);
                          int toY = max(endCordinates[1], startCordinates[1]);
                          int fromY = min(endCordinates[1], startCordinates[1]);
                          print('$fromX,$fromY,$toX,$toY');

                          Property property = selectedProperty != null
                              ? selectedProperty!
                              : Property(
                                  propertyList.isEmpty
                                      ? 0
                                      : propertyList.last.id + 1,
                                  '',
                                  '',
                                  commonColorList[propertyList.isEmpty
                                      ? 0
                                      : propertyList.last.id % 30 + 1]);

                          Map<String, int> coordinateList = {};
                          for (x = fromX; x <= toX; x++) {
                            for (y = fromY; y <= toY; y++) {
                              if (coordinateAndProperty['$x,$y'] != null) {
                                return _clearSelected();
                              }
                              coordinateList.addAll({'$x,$y': property.id});
                            }
                          }
                          coordinateAndProperty.addAll(coordinateList);
                          matrixAndProperty.addAll({
                            coordinateSqaureToMatrix(fromX, toX, fromY, toY):
                                property.id
                          });
                          if (selectedProperty == null) {
                            propertyList.add(property);
                          }
                          codeGenerate();
                          _clearSelected();
                        },
                        child: MouseRegion(
                          onEnter: (PointerEnterEvent event) {
                            if (dragging) {
                              endCordinates = [x, y];
                              setState(() {});
                            }
                          },
                          child: GridTile(
                              child: Container(
                                  width: 1,
                                  height: 1,
                                  decoration: BoxDecoration(
                                    color: startCordinates.length == 2 &&
                                            endCordinates.length == 2
                                        ? ((endCordinates[0] - x) *
                                                        (startCordinates[0] -
                                                            x) <=
                                                    0 &&
                                                (endCordinates[1] - y) *
                                                        (startCordinates[1] -
                                                            y) <=
                                                    0)
                                            ? selectedProperty != null
                                                ? selectedProperty!.color
                                                : Colors.black26
                                            : boxColor
                                        : boxColor,
                                    border: Border(
                                        left: const BorderSide(
                                            color: Colors.black, width: 0.5),
                                        bottom: const BorderSide(
                                            color: Colors.black, width: 0.5),
                                        top: BorderSide(
                                            color: Colors.black,
                                            width: y % 5 == 0 ? 1.5 : 0.5),
                                        right: BorderSide(
                                            color: Colors.black,
                                            width: x % 5 == 0 ? 1.5 : 0.5)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      coordinateAndProperty['$x,$y'] != null
                                          ? propertyList
                                              .firstWhere((e) =>
                                                  e.id ==
                                                  coordinateAndProperty[
                                                      '$x,$y'])
                                              .label
                                              .toString()
                                          : '',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 8),
                                    ),
                                  ))),
                        ),
                      );
                    },
                    //item 의 반목문 항목 형성
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  width: 500,
                  height: 400,
                  child: Scrollbar(
                    child: ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          String matrixExpression = matrixAndProperty.keys
                              .where((element) =>
                                  matrixAndProperty[element] ==
                                  propertyList[index].id)
                              .map((e) => '$e; ')
                              .join('');

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedProperty == propertyList[index]) {
                                  return selectedProperty = null;
                                }
                                selectedProperty = propertyList[index];
                              });
                            },
                            child: ListTile(
                              tileColor: selectedProperty == propertyList[index]
                                  ? Colors.lightBlue.withOpacity(0.3)
                                  : Colors.white,
                              title: Text('{$matrixExpression}'),
                              subtitle: Column(
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                        hintText: '라벨...',
                                        border: InputBorder.none),
                                    controller: TextEditingController(
                                        text: propertyList[index].label),
                                    onChanged: (value) {
                                      propertyList[index].label = value;
                                      codeGenerate();
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: '구역에 해당하는 수식을 작성하세요...',
                                        border: InputBorder.none),
                                    initialValue: propertyList[index].formula,
                                    // controller: TextEditingController(
                                    //     text: propertyList[index].formula),
                                    onChanged: (value) {
                                      propertyList[index].setFormula(value);
                                      codeGenerate();
                                    },
                                  ),
                                ],
                              ),
                              leading: Container(
                                width: 20,
                                height: 20,
                                color: propertyList[index].color,
                              ),
                              trailing:
                                  Text('index : ${propertyList[index].id}'),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: propertyList.length),
                  ),
                ),

                Consumer<MatlabProvider>(
                  builder: (context, matlabProvider, child) => Container(
                    width: 500,
                    height: 100,
                    child: TextField(
                      maxLines: 2,
                      decoration: const InputDecoration(
                          label: Text('현재 데이터'),
                          hintText: '코드를 작성하세요...',
                          border: InputBorder.none),
                      controller: matlabProvider.convertTextController,
                    ),
                  ),
                ),
                //Save button
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: matlabProvider.convertTextController.text));
                        const snackBar = SnackBar(
                          content: Text('클립보드에 데이터가 복사되었습니다.'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: const Text('저장'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        jsonToDart(matlabProvider.convertTextController.text);
                        //matlabProvider.update();
                        codeGenerate();
                      },
                      child: const Text('로드'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      onPressed: () async {
                        await loadAsset();
                        //matlabProvider.update();
                        codeGenerate();
                      },
                      child: const Text('에셋에서 로드'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VideoPlayerPage()));
                      },
                      child: const Text('시뮬레이션 영상'),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: matlabProvider.matlabText.text));
                    // String list = '';
                    // for (var element in propertyList) {
                    //   list += '${element.label} \n';
                    //   list += '${element.formula} \n\n';
                    // }
                    // Clipboard.setData(ClipboardData(text: list));
                    const snackBar = SnackBar(
                      content: Text('클립보드에 코드가 복사되었습니다.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Consumer<MatlabProvider>(
                    builder: (context, matlabProvider, child) {
                      return codeEditor(matlabProvider.matlabText.text);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const Spacer()
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (propertyList.isEmpty) return;
              int propertyIdToDelete = propertyList.last.id;
              propertyList.removeWhere((e) => e.id == propertyIdToDelete);
              matrixAndProperty
                  .removeWhere((key, value) => value == propertyIdToDelete);
              coordinateAndProperty
                  .removeWhere((key, value) => value == propertyIdToDelete);
              setState(() {});
            },
            tooltip: '실행취소',
            child: const Icon(Icons.undo),
          ),
          const SizedBox(
            width: 10,
          ),
          if (selectedProperty != null)
            FloatingActionButton(
              onPressed: () {
                if (propertyList.isEmpty) return;
                int propertyIdToDelete = selectedProperty!.id;
                propertyList.removeWhere((e) => e.id == propertyIdToDelete);
                matrixAndProperty
                    .removeWhere((key, value) => value == propertyIdToDelete);
                coordinateAndProperty
                    .removeWhere((key, value) => value == propertyIdToDelete);
                selectedProperty = null;
                setState(() {});
              },
              tooltip: '삭제',
              child: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }

  String dartToJson(List<dynamic> listOfData) {
    Map<String, dynamic> json = {
      'matrixAndProperty': matrixAndProperty,
      'propertyList': propertyList.map((e) => e.toJson()).toList(),
    };
    // List<String> jsonList = [];
    // for (int i = 0; i < listOfData.length; i++) {
    //   listOfData[i] is Map
    //       ? jsonList.add(jsonEncode(listOfData[i]))
    //       : jsonList
    //           .add(jsonEncode(listOfData[i].map((e) => e.toJson()).toList()));
    // }
    return const JsonEncoder().convert(json);
  }

  void jsonToDart(String json) {
    matrixAndProperty.clear();
    propertyList.clear();
    coordinateAndProperty.clear();
    Map<String, dynamic> jsonMap = jsonDecode(json) as Map<String, dynamic>;
    matrixAndProperty = Map<String, int>.from(jsonMap['matrixAndProperty']);
    propertyList = (jsonMap['propertyList'] as List)
        .map((e) => Property.fromJson(e))
        .toList();
    matrixAndProperty.forEach((key, value) => matrixToCoordinateList(key)
        .forEach((e) => coordinateAndProperty[e] = value));
    print(coordinateAndProperty.length);
    print(coordinateAndProperty.toString());
    setState(() {});
  }

  String listToJson(List<dynamic> list) {
    return jsonEncode(list);
  }

  String mapToJson(Map<dynamic, dynamic> map) {
    return jsonEncode(map);
  }

  List<String> matrixToCoordinateList(String matrix) {
    List matrixList = matrix.split(',');
    List<String> xRange = matrixList[0].split(':');
    List<String> yRange = matrixList[1].split(':');
    List<String> coordinateList = [];
    int xStart = int.parse(xRange[0]);
    int xEnd = xRange.length > 1 ? int.parse(xRange[1]) : xStart;
    int yStart = int.parse(yRange[0]);
    int yEnd = yRange.length > 1 ? int.parse(yRange[1]) : yStart;
    for (int x = xStart; x <= xEnd; x++) {
      for (int y = yStart; y <= yEnd; y++) {
        coordinateList.add('$x,$y');
      }
    }
    return coordinateList;
  }

  String coordinateSqaureToMatrix(
    int xMin,
    int xMax,
    int yMin,
    int yMax,
  ) {
    String xComponent = xMin == xMax ? '$xMin' : '$xMin:$xMax';
    String yComponent = yMin == yMax ? '$yMin' : '$yMin:$yMax';
    return '$xComponent,$yComponent';
  }

  Widget codeEditor(String code) {
    EditorModel model = EditorModel(
      files: [
        FileEditor(
            name: "매트랩 코드(클릭하여 텍스트 복사)",
            language: "MATLAB",
            code: code // [code] needs a string
            ),
      ], // the files created above
      styleOptions:
          EditorModelStyleOptions(fontSize: 13, heightOfContainer: 200),
    );
    return Container(
      width: 500,
      height: 262,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      child: CodeEditor(
        model: model, // the model created above, not required since 1.0.0
        edit: false, // can edit the files ? by default true
        disableNavigationbar:
            false, // hide the navigation bar ? by default false
        onSubmit: (String? language,
            String?
                value) {}, // when the user confirms changes in one of the files
      ),
    );
  }
}
