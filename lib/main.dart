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
List answerResult = [];

  Widget options({Color ?backColor , String ?optionName}){
    return  Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: backColor,
                        foregroundColor: Colors.white,
                        shape: const BeveledRectangleBorder()),
                    onPressed: () {},
                    child: Text(
                      optionName!,
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                );
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
            const Row(
              children: [
                Text("Score: ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700 ),),
                Icon(Icons.thumb_up, color: Colors.green),
                Icon(Icons.thumb_down, color: Colors.red),
              ],
            )
          ],

        ),


        //Answer Part
        Column(
          children: [
            //First Line Row
            Row(
              children: [
                options(backColor: Colors.green, optionName: "Option 1"),

                const SizedBox(
                  width: 20,
                ),

                options(backColor: Colors.purple, optionName: "Option 2"),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            //Second Line Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              options(backColor: Colors.yellow[600], optionName: "Option 3"),

                const SizedBox(
                  width: 20,
                ),
              options(backColor: Colors.blue[900], optionName: "Option 4"),
              ],
            ),
          ],
        )
      ],
    );
  }
}
