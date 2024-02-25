import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'AppData.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.white30,
          title: const Text(
            "Quizle",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(10.0),
          child: QuizWidget(),
        ),
      ),
    ),
  );
}

class QuizWidget extends StatefulWidget {
  const QuizWidget({super.key});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  List<Widget> answerResult = [];
  int correctAsnwers = 0;
  AppData appData = AppData();

  Widget options(
      {Color? backColor, String? optionName, String? corectOrFalse}) {
    return Expanded(
      child: SizedBox(
        height: 160,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: backColor,
              foregroundColor: Colors.white,
              shape: const BeveledRectangleBorder()),
          onPressed: () {
            setState(() {
              answerResult.add(thumb(answer: corectOrFalse));
              appData.changeQuestion();
              if (appData.isFnished()) {
                Alert(
                        context: context,
                        title: "Congrats You Finished",
                        desc:
                            "Your Score is $correctAsnwers / ${appData.getSize()} \n Number of wrong answers ${appData.getSize() - correctAsnwers}")
                    .show();
                correctAsnwers = 0;
                appData.reset();
                answerResult = [];
              }
            });
          },
          child: Text(
            optionName!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget thumb({String? answer}) {
    return (answer?.toLowerCase().trim() ==
            appData.getTrueAnswer().toLowerCase().trim())
        ? () {
            correctAsnwers++;
            return const Icon(Icons.thumb_up, color: Colors.green);
          }()
        : const Icon(Icons.thumb_down, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //Q A S part
      children: [
        //Q part
        Column(
          children: [
            Image.asset(appData.getImage()),

            Text(
              appData.getQuestion(),
              style: const TextStyle(fontSize: 25, color: Colors.white),
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 13,
            ),

            // Score Place
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                children: answerResult,
              ),
            )
          ],
        ),

        //Answer Part
        Column(
          children: [
            //First Line Row
            Row(
              children: [
                options(
                    backColor: Colors.green,
                    optionName: appData.getOptionIndex(0),
                    corectOrFalse: appData.getOptionIndex(0)),
                const SizedBox(
                  width: 20,
                ),
                options(
                    backColor: Colors.purple,
                    optionName: appData.getOptionIndex(1),
                    corectOrFalse: appData.getOptionIndex(1)),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            //Second Line Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                options(
                    backColor: Colors.yellow[600],
                    optionName: appData.getOptionIndex(2),
                    corectOrFalse: appData.getOptionIndex(2)),
                const SizedBox(
                  width: 20,
                ),
                options(
                    backColor: Colors.blue[900],
                    optionName: appData.getOptionIndex(3),
                    corectOrFalse: appData.getOptionIndex(3)),
              ],
            ),
          ],
        )
      ],
    );
  }
}
