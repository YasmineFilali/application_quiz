import 'package:flutter/material.dart';
import 'package:application_quiz/Service/database.dart';
import 'package:application_quiz/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class AddQuestion extends StatefulWidget {

  final String quizId;
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {

  final _formKey = GlobalKey<FormState>();
  late String question, option1, option2, option3, correctAnswer, questionId;

  bool _isLoading = false;

  DatabaseService _databaseService = new DatabaseService();

  _uploadQuestionData() async{
    if(_formKey.currentState!.validate()){

      setState(() {
        _isLoading = true;
      });

      questionId = randomAlphaNumeric(16);

      Map<String, String> questionData =
      {
        "questionText" : question,
        "option1" : option1,
        "option2" : option2,
        "option3" : option3,
        "correctAnswer" : correctAnswer,
        "questionId" : questionId
      };

      await _databaseService.addQuestionData(questionData, widget.quizId, questionId).then((value) => {
        setState(() {
          _isLoading = false;
        })
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appBar(context),
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Question"
                ),
                onChanged: (val){
                  question = val;
                },
                validator: (val){
                  if (val != null && val.isEmpty) {
                    return"saisissez la question";
                  }                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "première réponse"
                ),
                onChanged: (val){
                  option1 = val;
                },
                validator: (val){
                  if (val != null && val.isEmpty) {
                    return "saisissez la première réponse";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Deuxième réponse"
                ),
                onChanged: (val){
                  option2 = val;
                },
                validator: (val){
                  if (val != null && val.isEmpty) {
                    return "Saisissez la 2eme réponse";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "troisième réponse"
                ),
                onChanged: (val){
                  option3 = val;
                },
                validator: (val){
                  if (val != null && val.isEmpty) {
                    return "Saisissez la 3eme réponse";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Correct answer"
                ),
                onChanged: (val){
                  correctAnswer = val;
                },
                validator: (val){
                  if (val != null && val.isEmpty) {
                    return "Saisissez la réponse correcte";
                  }

                },
              ),
              Spacer(),

              Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: orangeButton(context, "Submit", MediaQuery.of(context).size.width/2 - 36, Colors.deepOrangeAccent)
                    ),
                    SizedBox(width: 24,),
                    GestureDetector(
                        onTap: (){
                          _uploadQuestionData();
                        },
                        child: orangeButton(context, "Add Question", MediaQuery.of(context).size.width/2 - 36, Colors.blueAccent)
                    ),
                  ]
              ),
              SizedBox(height: 40.0)
            ],
          ),
        ),
      ),
    );
  }
}
