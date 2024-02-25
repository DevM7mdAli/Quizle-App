import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.lightBlue,
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

  Widget options({Color? backColor, String? optionName , bool? corectOrFalse}) {
    return Expanded(
      child: SizedBox(
        height: 180,
        width: 180,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: backColor,
              foregroundColor: Colors.white,
              shape: const BeveledRectangleBorder()),
          onPressed: () {
            setState(() {
            answerResult.add(thumb(answer: corectOrFalse));
            });
          },
          child: Text(
            optionName!,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget thumb({bool? answer}) {
    return answer == true
        ? const Icon(Icons.thumb_up, color: Colors.green)
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
            Image.asset("images/ARM-Chip.jpg"),

            const Text(
              "Question says that what Is Arm company do in CPU industry",
              style: TextStyle(fontSize: 25, color: Colors.white),
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
                options(backColor: Colors.green, optionName: "Option 1" ,corectOrFalse: false),
                const SizedBox(
                  width: 20,
                ),
                options(backColor: Colors.purple, optionName: "Option 2" ,corectOrFalse: true),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            //Second Line Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                options(backColor: Colors.yellow[600], optionName: "Option 3" ,corectOrFalse: true),
                const SizedBox(
                  width: 20,
                ),
                options(backColor: Colors.blue[900], optionName: "Option 4" ,corectOrFalse: false),
              ],
            ),
          ],
        )
      ],
    );
  }
}
