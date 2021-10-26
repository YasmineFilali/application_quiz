import 'package:application_quiz/Screens/quiz_list.dart';
import 'package:application_quiz/widgets/ChangeThemeButtonWidget.dart';
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
  late String questionText, questionImageUrl, option1, option2, option3, correctAnswer, questionId;

  bool _isLoading = false;

  DatabaseService _databaseService = new DatabaseService();

  _uploadQuestionData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      questionId = randomAlphaNumeric(16);

      Map<String, String> questionData =
      {
        "questionText": questionText,
        "questionImageUrl": questionImageUrl,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "correctAnswer": correctAnswer,
        "questionId": questionId
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
                onChanged: (val) {
                  questionText = val;
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return "Saisissez la question";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Image Url"
                ),
                onChanged: (val) {
                  questionImageUrl = val;
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return "Saisissez l'url d'une image";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Première option "
                ),
                onChanged: (val) {
                  option1 = val;
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return "Saisissez la 1ere options";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Deuxième option"
                ),
                onChanged: (val) {
                  option2 = val;
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return "Saisissez la 2eme options";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "troisième option"
                ),
                onChanged: (val) {
                  option3 = val;
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return "Saisissez la 3eme options";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Réponse correcte"
                ),
                onChanged: (val) {
                  correctAnswer = val;
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return "Saisissez la reponse correcte";
                  }
                },
              ),
              Spacer(),

              Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Button1(context, "Enregistrer", MediaQuery
                            .of(context)
                            .size
                            .width / 2 - 36, Colors.deepOrangeAccent)
                    ),
                    SizedBox(width: 24,),
                    GestureDetector(
                        onTap: () {
                          _uploadQuestionData();
                        },
                        child: Button1(
                            context, "Ajouter une Question", MediaQuery
                            .of(context)
                            .size
                            .width / 2 - 36, Colors.blueAccent)
                    ),
                  ]
              ),
              SizedBox(height: 50.0)
            ],
          ),
        ),
      ),
    );
  }
}
