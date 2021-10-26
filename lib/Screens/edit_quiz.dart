import 'package:application_quiz/Screens/quiz_list.dart';
import 'package:application_quiz/Service/database.dart';
import 'package:application_quiz/models/question_model.dart';
import 'package:application_quiz/widgets/ChangeThemeButtonWidget.dart';
import 'package:application_quiz/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_question.dart';

class EditQuiz extends StatefulWidget {

  final String quizId;
  EditQuiz(this.quizId);

  @override
  _EditQuizState createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {

  DatabaseService _databaseService = new DatabaseService();
  late QuerySnapshot querySnapshot;

  bool _isLoading = true;

  QuestionModel getQuestionModelFromSnapshot(DocumentSnapshot questionSnapshot){

    QuestionModel questionModel = new QuestionModel();

    questionModel.questionId = questionSnapshot.data()["questionId"];
    questionModel.questionText = questionSnapshot.data()["questionText"];

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

  _deleteQuizSet(){
    _databaseService.deleteQuizData(widget.quizId).then((value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuizList()));
      setState(() {

      });
    });
  }

  @override
  void initState() {
    _databaseService.getQuestionData(widget.quizId).then((value){
      querySnapshot = value;
      _isLoading = false;
      setState(() {

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuestion(widget.quizId)));
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _deleteQuizSet();
                },
                child: Icon(
                    Icons.delete
                ),
              )
          ),
          ChangeThemeButtonWidget(),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,

      ),
      body: _isLoading? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :
      SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              querySnapshot.docs == null ? Container(
                child: Center(child: Text("Aucun Quiz disponible", style: TextStyle(fontSize: 18, color: Colors.red),)),
              ) :
              ListView.builder(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 34.0),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (context, index){
                    return QuizEditTile(
                        questionModel: getQuestionModelFromSnapshot(querySnapshot.docs[index]),
                        index: index,
                        quizId : widget.quizId
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizEditTile extends StatefulWidget {

  final QuestionModel questionModel;
  final int index;
  final String quizId;
  QuizEditTile({required this.questionModel, required this.index, required this.quizId});

  @override
  _QuizEditTileState createState() => _QuizEditTileState();
}

class _QuizEditTileState extends State<QuizEditTile> {

  DatabaseService _databaseService = new DatabaseService();

  _deleteQuestionData(String questionId){
    _databaseService.deleteQuestionData(widget.quizId, questionId).then((value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditQuiz(widget.quizId)));
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Q${widget.index+1} ${widget.questionModel.questionText}", style: TextStyle(fontSize: 18, color: Colors.black87),),
          SizedBox(height: 10,),
          Row(
            children: [
              IconButton(
                onPressed: (){
                  _deleteQuestionData(widget.questionModel.questionId);
                },
                icon: Icon(Icons.delete_forever_sharp, color: Colors.black87,),
              ),
            ],
          ),

          Divider(color: Colors.green,),

          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
