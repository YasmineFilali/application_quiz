import 'package:application_quiz/Screens/quiz_list.dart';
import 'package:application_quiz/widgets/ChangeThemeButtonWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:application_quiz/models/question_model.dart';
import 'package:application_quiz/Service/database.dart';
import 'package:application_quiz/Screens/result.dart';
import 'package:application_quiz/widgets/quiz_play_widget.dart';
import 'package:application_quiz/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {

  final String quizId;
  PlayQuiz(this.quizId);


  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

late Stream infoStream;

class _PlayQuizState extends State<PlayQuiz> {

  DatabaseService _databaseService = new DatabaseService();

  late QuerySnapshot querySnapshot;


  bool _isLoading = true;
  QuestionModel getQuestionModelFromSnapshot(DocumentSnapshot questionSnapshot){

    QuestionModel questionModel = new QuestionModel();
    questionModel.questionText = questionSnapshot.data()["questionText"];
    questionModel.questionImageUrl = questionSnapshot.data()["questionImageUrl"];
    List<String> options =
    [
      questionSnapshot.data()["option1"],
      questionSnapshot.data()["option2"],
      questionSnapshot.data()["option3"],
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];

    questionModel.correctOption = questionSnapshot.data()["correctAnswer"];
    questionModel.correctAnswer = questionSnapshot.data()["correctAnswer"];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void initState() {
    String quizId=widget.quizId;
    _databaseService.getQuestionData(widget.quizId).then((value){
      querySnapshot = value;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = querySnapshot.docs.length;
      print("total $total");
      _isLoading = false;
      setState(() {});
    });

    super.initState();
    print("init don $total ${widget.quizId} ");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => QuizList()));
              },
              icon: Icon(Icons.list_alt_sharp, color: Colors.white,)
          ),
          ChangeThemeButtonWidget(),
        ],

      ),
      body: _isLoading? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :
      SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 34.0),

          child: Column(
            children: [
              querySnapshot.docs == null ? Container(
                child: Center(
                  child: Text("Aucune question disponible",
                      style: TextStyle(fontSize: 18, color: Colors.red)),),
              ) :
              ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (context, index){
                    return QuizPlayTile(
                      questionModel: getQuestionModelFromSnapshot(querySnapshot.docs[index]),
                      index: index,
                    );
                  }
              )
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.next_plan),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Results(
              correct: _correct,
              incorrect: _incorrect,
              total: total
          )));
        },
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {

  final QuestionModel questionModel;
  final int index;
  QuizPlayTile({required this.questionModel, required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {

  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.questionModel.questionImageUrl),
          Text (" ${widget.questionModel.questionText}", style: TextStyle(fontSize: 18, color: Colors.black87),),
          SizedBox(height: 12,),
          GestureDetector(
            onTap: (){
              if(!widget.questionModel.answered){
                if(widget.questionModel.option1 == widget.questionModel.correctOption){

                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {

                  });

                }else{

                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {

                  });

                }
              }
            },
            child: OptionTile(
                option: "A",
                description: widget.questionModel.option1,
                correctAnswer: widget.questionModel.correctAnswer,
                optionSelected: optionSelected
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: (){
              if(!widget.questionModel.answered){
                if(widget.questionModel.option2 == widget.questionModel.correctOption){

                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {

                  });

                }else{

                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {

                  });

                }
              }
            },
            child: OptionTile(
                option: "B",
                description: widget.questionModel.option2,
                correctAnswer: widget.questionModel.correctAnswer,
                optionSelected: optionSelected
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: (){
              if(!widget.questionModel.answered){
                if(widget.questionModel.option3 == widget.questionModel.correctOption){

                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {

                  });

                }else{

                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {

                  });

                }
              }
            },
            child: OptionTile(
                option: "C",
                description: widget.questionModel.option3,
                correctAnswer: widget.questionModel.correctAnswer,
                optionSelected: optionSelected
            ),
          ),
          SizedBox(height: 4,),
        ],
      ),
    );
  }
}
