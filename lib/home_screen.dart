import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:math_expressions/math_expressions.dart';

import 'consts/consts.dart';
import 'models/history_model.dart';
import 'providers/theme_provider.dart';

import 'services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userInput = '';
  var answer = '';

  bool visible = false;
  bool isEmpty = true;

  @override
  void initState() {
    _gethistories();

    super.initState();
  }

  final DatabaseService _databaseService = DatabaseService();
  Future<List<HistoryModel>> _gethistories() async {
    return await _databaseService.histories();
  }

  Future<void> _onSave() async {
    final input = userInput;
    final ans = answer;

    await _databaseService
        .insertHistory(HistoryModel(userinput: input, answer: ans));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final themestate = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    visible = false;
                  });
                },
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            themestate.setTheme = !themestate.getDarkTheme;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.all(10),
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
                            setState(() {
                              visible = !visible;
                            });
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
              ),
            ),
            visible
                ? Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).canvasColor,
                      child: FutureBuilder<List<HistoryModel>>(
                        future: _gethistories(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          }
                          if (snapshot.data!.isNotEmpty) {
                            isEmpty == false;
                            return Column(
                              children: [
                                Expanded(
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      thickness: 1,
                                    ),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      isEmpty = false;
                                      final history = snapshot.data![index];
                                      return _historyWidget(
                                        history,
                                        context,
                                        visible,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }

                          return Container(
                            alignment: Alignment.center,
                            height: size.height * 0.67,
                            child: Text(
                              'No History',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      color: Theme.of(context).canvasColor,
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Consts.buttons.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            // Clear Button
                            if (index == 0) {
                              return _buttonWidget(
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
                              return _buttonWidget(
                                buttoncolor: Theme.of(context).canvasColor,
                                buttonText: Consts.buttons[index],
                                textColor:
                                    Theme.of(context).colorScheme.secondary,
                                onTap: () {
                                  setState(() {
                                    if (userInput.isNotEmpty) {
                                      // log(userInput.length.toString());
                                      userInput = userInput.substring(
                                          0, userInput.length - 1);
                                    }
                                  });
                                },
                              );
                            }
                            // % Button
                            else if (index == 2) {
                              return _buttonWidget(
                                buttoncolor: Theme.of(context).canvasColor,
                                onTap: () {
                                  // setState(() {
                                  //   userInput += Consts.buttons[index];
                                  // });
                                },
                                buttonText: Consts.buttons[index],
                                textColor:
                                    Theme.of(context).colorScheme.secondary,
                              );
                            }

                            // , Button
                            else if (index == 16) {
                              return _buttonWidget(
                                buttoncolor: Theme.of(context).canvasColor,
                                onTap: () {
                                  // log(',');
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
                              return _buttonWidget(
                                  onTap: () {
                                    setState(() {
                                      if (hasOperator()) {
                                        return;
                                      } else if (userInput.isEmpty) {
                                        return;
                                      } else {
                                        equalPressed();
                                        _onSave();
                                        isEmpty = false;
                                      }
                                    });
                                  },
                                  buttonText: Consts.buttons[index],
                                  textColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  buttoncolor: Theme.of(context).primaryColor);
                            }
                            // Expressions
                            else if (index == 3 ||
                                index == 7 ||
                                index == 11 ||
                                index == 15) {
                              return _buttonWidget(
                                  onTap: () {
                                    setState(() {
                                      if (userInput.isEmpty) {
                                        return;
                                      } else if (hasOperator()) {
                                        return;
                                      } else {
                                        userInput += Consts.buttons[index];
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
                              return _buttonWidget(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: (visible && !isEmpty)
            ? Material(
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      await _databaseService.clearHistory();

                      setState(() {
                        visible = !visible;
                        userInput = '';
                        answer = '';
                        isEmpty = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Clear History',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    )),
              )
            : const SizedBox());
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

  Widget _historyWidget(
      HistoryModel history, BuildContext context, bool visible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          history.userinput,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          '= ${history.answer}',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buttonWidget({
    required Function onTap,
    required String buttonText,
    required Color textColor,
    required Color buttoncolor,
  }) {
    return Material(
      elevation: 0,
      color: buttoncolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          onTap();
        },
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 25,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
