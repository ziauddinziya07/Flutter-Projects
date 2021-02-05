import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() => runApp(Tasbeeh());

class Tasbeeh extends StatefulWidget {
  @override
  _TasbeehState createState() => _TasbeehState();
}

class _TasbeehState extends State<Tasbeeh> {
  int _count = 0; // 0
  int _outOf = 99; // 99
  bool _isDark = true; // false
  var _outOfList = ["0", "33", "99", "100"];

  Map<String, Color> _colorMap = {
    "Pink": Color.fromRGBO(255, 51, 153, 1.0),
    "Blue": Color.fromRGBO(26, 140, 255, 1.0),
    "Green": Color.fromRGBO(0, 179, 45, 1),
    "Dark": Color.fromRGBO(15, 76, 117, 1)
  };

  Color _color;
  Color _bgColor;
  Color _countColor;

  void initState() {
    super.initState();
    this._color = _colorMap["Dark"];
    getThemeStatus().then(updateColor);
    getCountStatus();
    print("Ziya");
  }

  Future<String> getThemeStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String color = sp.getString("color") ?? "Dark";
    return color;
  }

  void updateColor(String color) {
    print(color);
    this._isDark = (color == "Dark") ? true : false;
    this._color = _colorMap[color];
    setState(() {
      _bgColor = _isDark
          ? Color.fromRGBO(27, 38, 44, 1)
          : Colors.white.withOpacity(0.8);
      _countColor = _isDark ? Color.fromRGBO(187, 225, 250, 1) : Colors.black;
    });
  }

  Future<void> getCountStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    this._count = sp.getInt("count") ?? 0;
    this._outOf = sp.getInt("outOf") ?? 99;
  }

  void count() {
    setState(() {
      _count++;
      if (_count > _outOf && _outOf != 0) _count = 1;
      saveCount();
    });
  }

  Future<void> saveCount() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt("count", this._count);
    sp.commit();
  }

  void reset() {
    setState(() {
      _count = 0;
      saveCount();
    });
  }

  void changeOutOf() {
    int ind = _outOfList.indexOf(_outOf.toString());
    ind = (ind == _outOfList.length - 1) ? 0 : ind + 1;
    setState(() {
      _outOf = int.parse(_outOfList[ind]);
      if (_count > _outOf && _outOf != 0) reset();
    });
    saveOutOf();
  }

  Future<void> saveOutOf() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt("outOf", this._outOf);
    sp.commit();
  }

  void changeTheme(String color) {
    setState(() {
      if (color == "Dark") {
        _isDark = true;
        _color = _colorMap[color];
      } else {
        _isDark = false;
        _color = _colorMap[color];
      }
      _countColor = _isDark ? Color.fromRGBO(187, 225, 250, 1) : Colors.black;
      _bgColor = _isDark
          ? Color.fromRGBO(27, 38, 44, 1)
          : Colors.white.withOpacity(0.8);
      saveColorName(color);
    });
  }

  Future<void> saveColorName(String color) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("color", color);
    sp.commit();
  }

  Widget myPopupMenuItem(String item) {
    return PopupMenuItem<String>(
      value: item,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            "$item",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _isDark ? Colors.white : Colors.black,
            ),
          ),
          Expanded(child: SizedBox()),
          Container(
            width: 20,
            height: 20,
            color: _colorMap[item],
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget myPopupMenuButton() {
    return PopupMenuButton<String>(
      tooltip: "Change Theme",
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        myPopupMenuItem("Blue"),
        myPopupMenuItem("Green"),
        myPopupMenuItem("Pink"),
        myPopupMenuItem("Dark"),
      ],
      padding: EdgeInsets.only(right: 20),
      color: _bgColor,
      onSelected: changeTheme,
    );
  }

  Widget myText(int _count, int _outOf) {
    return Text.rich(
      TextSpan(
        text: _count > 9 ? "$_count" : "0$_count",
        style: TextStyle(
          fontSize: 55,
          color: _countColor,
        ),
        children: <TextSpan>[
          TextSpan(
            text: _outOf == 0 ? "" : "/$_outOf",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: "Tasbeeh",
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
            title: Text(
              "Tasbeeh",
              style: TextStyle(fontSize: 20),
            ),
            titleSpacing: 30,
            elevation: 30.0,
            backgroundColor: _color,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: OutlineButton(
                  child: Text(
                    _outOf == 0 ? "∞" : "$_outOf",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  shape: CircleBorder(),
                  borderSide: BorderSide(
                    color: Colors.white,
                    style: BorderStyle.solid,
                    width: 2.5,
                  ),
                  splashColor: _color.withOpacity(1),
                  highlightedBorderColor: Colors.white,
                  onPressed: () => changeOutOf(),
                ),
              ),
              myPopupMenuButton(),
            ],
          ),
          body: FlatButton(
            onPressed: () => count(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                //   SizedBox.fromSize(
                //     size: Size(double.infinity, _height * 0.0148),
                //   ),
                Container(
                  width: double.infinity,
                  child: myText(_count, _outOf),
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 50),
                  margin: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: _color.withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    child: Container(
                      decoration: BoxDecoration(
                          color: _isDark ? _color : _color.withOpacity(0.8),
                          shape: BoxShape.circle),
                      padding: EdgeInsets.all(60),
                      child: Text(
                        "Count",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    shape: CircleBorder(),
                    elevation: 30,
                    highlightColor: _color.withOpacity(0),
                    splashColor: _color.withOpacity(1),
                    onPressed: () => count(),
                  ),
                ),
                Expanded(child: SizedBox()),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(right: 30, bottom: 30),
                  child: Ink(
                    decoration: ShapeDecoration(
                        shape: CircleBorder(), color: _color.withOpacity(0.8)),
                    child: IconButton(
                      padding: EdgeInsets.all(10),
                      iconSize: 30,
                      icon: Icon(
                        Icons.refresh,
                      ),
                      color: Colors.white,
                      highlightColor: _color.withOpacity(0),
                      splashColor: _color.withOpacity(1),
                      splashRadius: 25,
                      tooltip: "Reset",
                      onPressed: () => reset(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
