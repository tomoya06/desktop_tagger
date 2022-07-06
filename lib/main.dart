import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(200, 100),
    skipTaskbar: false,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    windowManager.setPosition(const Offset(100, 0));
  });

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
      home: const Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
            child: MyHomePage()),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  bool isEditing = false;
  late TextEditingController _controller;
  final TextStyle _textStyle = const TextStyle(
    fontSize: 20.0,
    height: 2.0,
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "New HomePage");

    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    setState(() {});
  }

  @override
  void onWindowMoved() async {
    Offset position = await windowManager.getPosition();
    windowManager.setPosition(Offset(position.dx, 0));
  }

  void _submitNewName() {
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isEditing) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isEditing = true;
          });
        },
        child: Text(
          _controller.text,
          style: _textStyle,
          textAlign: TextAlign.left,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            _submitNewName();
          }
        },
        child: TextField(
          style: _textStyle,
          autofocus: true,
          controller: _controller,
          onSubmitted: (String val) {
            _submitNewName();
          },
        ),
      ),
    );
  }
}
