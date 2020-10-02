import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(Calculator());

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var _appBarColor = Color.fromRGBO(31, 27, 36, 1);
  var _fontColor = Colors.white;
  var _buttonColor = Color.fromRGBO(171, 106, 251, 1);
  var _backgroundColor = Color.fromRGBO(18, 18, 18, 1.0);
  var _splashColor = Color.fromRGBO(171, 106, 251, 0.1);
  String _result = "", _expr = "0", _tempExpr;
  double resultFontSize = 25, exprFontSize = 50;
  var resultColor = Colors.white.withOpacity(0.6);
  var exprColor = Colors.white;
  String storeTemp = "";
  bool isDark = true;
  // Infinity - ∞

  Parser p = Parser();
  Expression exp;

  void calculate(String temp) {
    print(temp);
    resultFontSize = 25;
    exprFontSize = 50;
    resultColor = _fontColor.withOpacity(0.5);
    exprColor = _fontColor;

    // What user wants to do with the result ...
    if (storeTemp == "=" && temp.contains(RegExp("[+|−|%|×|÷]"))) {
      _expr = _result.substring(1);
    } else if (storeTemp == "=" && temp.contains(RegExp("[0-9]"))) {
      _expr = "0";
    }

    // Taking Input from the User ...
    if (temp.contains(RegExp("[0-9]"))) {
      _expr = _expr == "0" ? temp : _expr + temp;
    } else if (temp.contains(RegExp("[+|−|%|×|÷]"))) {
      if (_expr.length > 2 && _expr.substring(_expr.length - 2) == "−−")
        _expr = _expr.substring(0, _expr.length - 2) + temp;
      else if (_expr[_expr.length - 1].contains(RegExp("[+|−|%|×|÷]")))
        _expr = _expr.substring(0, _expr.length - 1) + temp;
      else
        _expr += temp;
    } else if (temp == "⌫") {
      _expr = _expr.substring(0, _expr.length - 1);
      if (_expr == "") _expr = "0";
    } else if (temp == "AC") {
      _expr = "0";
    } else if (temp == "=") {
      resultFontSize = 50;
      exprFontSize = 25;
      resultColor = _fontColor;
      exprColor = _fontColor.withOpacity(0.5);
    } else if (temp == "±") {
      if (_expr[_expr.length - 1] == "−" && _expr[_expr.length - 2] == "−")
        _expr = _expr.substring(0, _expr.length - 1);
      else
        _expr += "−";
    } else if (temp == ".") {
      var ind = _expr.lastIndexOf(RegExp("[+|−|%|×|÷]"));
      if (ind == -1 && !_expr.contains("."))
        _expr += temp;
      else if (ind != -1 && !_expr.substring(ind).contains(".")) _expr += temp;
    }

    // Evaluating Result ...
    try {
      if (_expr != "0") {
        _tempExpr = _expr;
        _tempExpr = _tempExpr.replaceAll("−", "-");
        _tempExpr = _tempExpr.replaceAll("×", "*");
        _tempExpr = _tempExpr.replaceAll("÷", "/");

        if (_expr[_expr.length - 1].contains(RegExp("[+|−|×|÷]"))) {
          if (_expr[_expr.length - 1] == "−" && _expr[_expr.length - 2] == "−")
            exp = p.parse(_tempExpr.substring(0, _expr.length - 2));
          else
            exp = p.parse(_tempExpr.substring(0, _expr.length - 1));
          _result =
              exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
        } else if (_expr[_expr.length - 1].contains("%")) {
          int ind = _expr.lastIndexOf(RegExp("[+|−|×|÷]"));
          print(ind);
          if (ind != -1) {
            var opr = _tempExpr.substring(ind + 1, _tempExpr.length - 1),
                o = _tempExpr[ind];
            _tempExpr = _tempExpr.substring(0, ind);

            exp = p.parse(_tempExpr);
            _result =
                exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
            if (o == "*") {
              _result = (double.parse(_result) * (double.parse(opr) / 100))
                  .toString();
            } else if (o == "+") {
              double temp = double.parse(_result);
              _result = (temp + double.parse(opr) * temp / 100).toString();
            } else if (o == "-") {
              double temp = double.parse(_result);
              _result = (temp - double.parse(opr) * temp / 100).toString();
            } else {
              _result = (double.parse(_result) / (double.parse(opr) / 100))
                  .toString();
            }
          }
        } else {
          exp = p.parse(_tempExpr);
          _result =
              exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
        }
        if (!_result.contains(RegExp("[1-9]"), _result.indexOf(".") + 1)) {
          _result = _result.substring(0, _result.length - 2);
        }
        if (_result == "Infini") _result = "∞";
        _result = _result[0] == "=" ? _result : "=" + _result;
      } else {
        _result = "";
      }
    } catch (e) {
      _result = "Error!";
    }

    setState(() {
      // ignore: unnecessary_statements
      _result;
      // ignore: unnecessary_statements
      _expr;
    });
    storeTemp = temp;
  }

  // Changes the current theme ....
  void changeTheme() {
    print(7262);
    setState(() {
      if (isDark) {
        _fontColor = Colors.black;
        _buttonColor = Color.fromRGBO(255, 128, 0, 1);
        _backgroundColor = Color.fromRGBO(255, 255, 220, 1);
        _appBarColor = Colors.white;
        _splashColor = Color.fromRGBO(230, 230, 234, 1);
        resultColor = Colors.black.withOpacity(0.8);
        exprColor = Colors.black;
      } else {
        _fontColor = Colors.white;
        _buttonColor = Color.fromRGBO(171, 106, 251, 1);
        _backgroundColor = Color.fromRGBO(18, 18, 18, 1.0);
        _appBarColor = Color.fromRGBO(31, 27, 36, 1);
        exprColor = Colors.white;
        _splashColor = Color.fromRGBO(171, 106, 251, 0.1);
        resultColor = Colors.white.withOpacity(0.5);
      }
      isDark = !(isDark);
    });
  }

  // ignore: non_constant_identifier_names
  Widget MyAppBar() {
    return AppBar(
      title: Text(
        "Calculator",
        style: TextStyle(
          color: _buttonColor,
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
      ),
      titleSpacing: 30,
      elevation: 20,
      backgroundColor: _appBarColor,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            isDark ? Icons.brightness_5 : Icons.brightness_4,
            color: _buttonColor,
          ),
          tooltip: isDark ? "Bright Theme" : "Dark Theme",
          splashColor: _splashColor,
          iconSize: 28,
          padding: EdgeInsets.symmetric(horizontal: 15),
          onPressed: () => changeTheme(),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget MainText(String text) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.only(right: 25, bottom: 5),
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: exprColor,
            fontSize: exprFontSize,
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ExpressionText(String text) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.only(right: 25, bottom: 25),
        child: Text(
          text,
          style: TextStyle(
            color: resultColor,
            fontSize: resultFontSize,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget MyButton(String btnText) {
    return Expanded(
      child: Container(
        child: FlatButton(
          onPressed: () => calculate(btnText),
          child: Text(
            btnText,
            style: TextStyle(
              color: btnText.contains(RegExp("[0-9.]"))
                  ? _fontColor
                  : _buttonColor,
              fontWeight: FontWeight.w400,
              fontSize: 35,
            ),
          ),
          color: _appBarColor,
          splashColor: _splashColor,
          padding: EdgeInsets.all(12),
          colorBrightness: Brightness.light,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ButtonList(b1, b2, b3, b4) {
    return Row(
      children: [
        MyButton(b1),
        MyButton(b2),
        MyButton(b3),
        MyButton(b4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
            appBar: MyAppBar(),
            body: Container(
              width: double.infinity,
              color: _backgroundColor,
              child: Column(
                children: <Widget>[
                  Expanded(child: Divider()),
                  MainText(_expr),
                  ExpressionText(_result),
                  Container(
                    padding: EdgeInsets.only(bottom: 10, top: 5),
                    color: _appBarColor,
                    child: Column(
                      children: [
                        ButtonList("AC", "⌫", "%", "÷"),
                        ButtonList("7", "8", "9", "×"),
                        ButtonList("4", "5", "6", "−"),
                        ButtonList("1", "2", "3", "+"),
                        ButtonList("±", "0", ".", "="),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
