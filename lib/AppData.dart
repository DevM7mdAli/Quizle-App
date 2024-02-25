import 'Questions.dart';


class AppData {
  int qCounter = 0;
  
final List<Questions> _question = [
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

  void changeQuestion(){
    if (qCounter < getSize()){
      qCounter++;
    }
  }

  String getOptionIndex(int op){
    return _question[qCounter].options![op];
  }

  String getQuestion(){
    return _question[qCounter].Q!;
  }

  String getTrueAnswer(){
    return _question[qCounter].trueAnswer!;
  }
  String getImage(){
    return _question[qCounter].imageAsset!;
  }

  int getSize(){
    return _question.length;
  }

  int getCounter(){
    return qCounter;
  }

  void setCounter(int val){
    qCounter = val;
  }
}
