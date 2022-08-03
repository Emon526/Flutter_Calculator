// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:math_expressions/math_expressions.dart';

import 'consts/consts.dart';
import 'providers/theme_provider.dart';
import 'widgets/buttonwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userInput = '';
  var answer = '';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final themestate = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      themestate.setTheme = !themestate.getDarkTheme;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    child: Icon(
                      themestate.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      color: Theme.of(context).iconTheme.color,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.05,
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    child: Text(
                      userInput,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.1,
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    child: Text(
                      answer,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      log('History pressed');
                    },
                    child: Icon(
                      Icons.history_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).canvasColor,
              child: GridView.builder(
                  primary: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Consts.buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    // Clear Button
                    if (index == 0) {
                      return ButtonsWidget(
                        buttoncolor: Theme.of(context).canvasColor,
                        onTap: () {
                          setState(() {
                            userInput = '';
                            answer = '0';
                          });
                        },
                        buttonText: Consts.buttons[index],
                        textColor: Theme.of(context).primaryColor,
                      );
                    }
                    // DEL button
                    else if (index == 1) {
                      return ButtonsWidget(
                        buttoncolor: Theme.of(context).canvasColor,
                        buttonText: Consts.buttons[index],
                        textColor: Theme.of(context).colorScheme.secondary,
                        onTap: () {
                          setState(() {
                            if (userInput.isNotEmpty) {
                              log(userInput.length.toString());
                              userInput =
                                  userInput.substring(0, userInput.length - 1);
                            }
                          });
                        },
                      );
                    }
                    // % Button
                    else if (index == 2) {
                      return ButtonsWidget(
                        buttoncolor: Theme.of(context).canvasColor,
                        onTap: () {
                          // setState(() {
                          //   userInput += Consts.buttons[index];
                          // });
                        },
                        buttonText: Consts.buttons[index],
                        textColor: Theme.of(context).colorScheme.secondary,
                      );
                    }

                    // , Button
                    else if (index == 16) {
                      return ButtonsWidget(
                        buttoncolor: Theme.of(context).canvasColor,
                        onTap: () {
                          log(',');
                          // setState(() {
                          //   userInput += Consts.buttons[index];
                          // });
                        },
                        buttonText: Consts.buttons[index],
                        textColor: themestate.getDarkTheme
                            ? const Color(0xffAAAAAA)
                            : const Color(0xff706E6E),
                      );
                    }
                    // Equal_to Button
                    else if (index == 19) {
                      return ButtonsWidget(
                          onTap: () {
                            setState(() {
                              if (hasOperator()) {
                                return;
                              } else if (userInput.isEmpty) {
                                return;
                              } else {
                                equalPressed();
                              }

                              log(Consts.buttons[index]);
                            });
                          },
                          buttonText: Consts.buttons[index],
                          textColor: Theme.of(context).scaffoldBackgroundColor,
                          buttoncolor: Theme.of(context).primaryColor);
                    }
                    // Expressions
                    else if (index == 3 ||
                        index == 7 ||
                        index == 11 ||
                        index == 15) {
                      return ButtonsWidget(
                          onTap: () {
                            setState(() {
                              if (userInput.isEmpty) {
                                return;
                              } else if (hasOperator()) {
                                return;
                              } else {
                                userInput += Consts.buttons[index];
                                log(Consts.buttons[index]);
                              }
                            });
                          },
                          buttonText: Consts.buttons[index],
                          textColor: themestate.getDarkTheme
                              ? Colors.black
                              : const Color(0xff706E6E),
                          buttoncolor: Theme.of(context).buttonColor);
                    }

                    //  other buttons
                    else {
                      return ButtonsWidget(
                        buttoncolor: Theme.of(context).canvasColor,
                        onTap: () {
                          setState(() {
                            userInput += Consts.buttons[index];
                          });
                        },
                        buttonText: Consts.buttons[index],
                        textColor: themestate.getDarkTheme
                            ? const Color(0xffAAAAAA)
                            : const Color(0xff706E6E),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
  }

  bool hasOperator() {
    if (userInput.endsWith('/') ||
        userInput.endsWith('x') ||
        userInput.endsWith('-') ||
        userInput.endsWith('+')) {
      return true;
    }
    return false;
  }
}
