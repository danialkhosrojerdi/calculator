import 'package:calculator/constants.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var inputText = '';
  var result = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: backgroundGreyDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          inputText,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 32,
                              color: textGreen,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          result,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 48,
                              color: textGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  color: backgroundGrey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      getCalcRow('AC', 'CE', '%', '/'),
                      getCalcRow('7', '8', '9', '*'),
                      getCalcRow('4', '5', '6', '-'),
                      getCalcRow('1', '2', '3', '+'),
                      getCalcRow('00', '0', '.', '='),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row getCalcRow(
    String num1,
    String num2,
    String num3,
    String num4,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        getCalcButtonNumber(num1),
        getCalcButtonNumber(num2),
        getCalcButtonNumber(num3),
        getCalcButtonNumber(num4),
      ],
    );
  }

  Widget getCalcButtonNumber(String number) {
    return TextButton(
      style: TextButton.styleFrom(
          shape: const CircleBorder(
            side: BorderSide(color: Colors.transparent),
          ),
          backgroundColor: getBackgroundColor(number)),
      onPressed: () {
        setState(() {
          if (number == 'CE') {
            if (inputText.isNotEmpty) {
              inputText = inputText.substring(0, inputText.length - 1);
            }
          } else if (number == '=') {
            Parser parser = Parser();
            Expression expression = parser.parse(inputText);
            ContextModel contextModel = ContextModel();
            double eval =
                expression.evaluate(EvaluationType.REAL, contextModel);
            result = eval.toString();
          } else if (number == 'AC') {
            inputText = '';
            result = '';
          } else {
            getInputText(number);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          number,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: getTextColor(number)),
        ),
      ),
    );
  }

  Color getBackgroundColor(String sign) {
    if (isOperator(sign)) {
      return backgroundGreyDark;
    } else {
      return backgroundGrey;
    }
  }

  Color getTextColor(String sign) {
    if (isOperator(sign)) {
      return textGreen;
    } else {
      return textGrey;
    }
  }

  bool isOperator(String sign) {
    final operators = ['AC', 'CE', '%', '/', '*', '-', '+', '='];
    for (var item in operators) {
      if (sign == item) {
        return true;
      }
    }
    return false;
  }

  void getInputText(String text) {
    setState(() {
      inputText = inputText + text;
    });
  }
}
