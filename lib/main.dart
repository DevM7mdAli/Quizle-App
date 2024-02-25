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

class Questions {
  String? Q;
  List<String>? options;
  String? trueAnswer;
  String? imageAsset;

  Questions({this.Q, this.options, this.trueAnswer, this.imageAsset});
}

class QuizWidget extends StatefulWidget {
  const QuizWidget({super.key});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  List<Widget> answerResult = [];
  List<Questions>? question = [
    Questions(
        options: ["Company", "CPU", "GPU", "ALU"],
        Q: "what does Arm mean in CPU World",
        trueAnswer: "Company",
        imageAsset: "images/181600416980514.jpg"),
    Questions(
        options: ["Arctecture", "GPU", "Nvidea", "All of the above"],
        Q: "what does ARM Offer in CPU world to company",
        trueAnswer: "Arctecture",
        imageAsset: "images/ARM-Chip.jpg"),
    Questions(
        options: ["Windows", "OS", "X86", "ARM"],
        Q: "what is the arctecture does intel use in CPU",
        trueAnswer: "X86",
        imageAsset: "images/s-l1600.jpg"),
    Questions(
        options: ["Windows", "OS", "X86", "ARM"],
        Q: "what is the arctecture does intel use in CPU",
        trueAnswer: "X86",
        imageAsset: "images/s-l1600.jpg"),
  ];
  int qCounter = 0;

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
              qCounter++;
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
    return answer == question![qCounter].trueAnswer!
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
            Image.asset(question![qCounter].imageAsset!),

            Text(
              question![0].Q!,
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
                    optionName: question![qCounter].options![0],
                    corectOrFalse: question![qCounter].options![0]),
                const SizedBox(
                  width: 20,
                ),
                options(
                    backColor: Colors.purple,
                    optionName: question![qCounter].options![1],
                    corectOrFalse: question![qCounter].options![1]),
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
                    optionName: question![qCounter].options![2],
                    corectOrFalse: question![qCounter].options![2]),
                const SizedBox(
                  width: 20,
                ),
                options(
                    backColor: Colors.blue[900],
                    optionName: question![qCounter].options![3],
                    corectOrFalse: question![qCounter].options![3]),
              ],
            ),
          ],
        )
      ],
    );
  }
}
