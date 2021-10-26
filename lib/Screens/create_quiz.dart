import 'package:application_quiz/widgets/ChangeThemeButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:application_quiz/Service/database.dart';
import 'package:application_quiz/Screens/add_question.dart';
import 'package:application_quiz/Screens/quiz_list.dart';
import 'package:application_quiz/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {

  final _formKey = GlobalKey<FormState>();
  late String quizImageUrl, quizTitle, quizDescription, quizId;

  bool _isLoading = false;

  DatabaseService _databaseService = new DatabaseService();

  _createQuizOnline() async{
    if(_formKey.currentState!.validate()){

      setState(() {
        _isLoading = true;
      });

      quizId = randomAlphaNumeric(16);
      Map<String, String> quizData = {
        "quizId" : quizId,
        "quizImgUrl" : quizImageUrl,
        "quizTitle" : quizTitle,
        "quizDescription" : quizDescription
      };

      await _databaseService.addQuizData(quizData, quizId).then((value) => {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
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
                    hintText: "Url de l'image du quiz "
                ),
                onChanged: (val){
                  quizImageUrl = val;
                },
                validator: (val){
                  if (val != null && val.isEmpty) {
                    return "Saisissez une url de l'image";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Titre du quiz"
                ),
                onChanged: (val){
                  quizTitle = val;
                },
                validator: (val){
                  if (val != null && val.isEmpty) {
                    return "saisissez un titre pour le quiz";
                  }
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Description du quiz"
                ),
                onChanged: (val){
                  quizDescription = val;
                },
                validator: (val){
                  if (val != null && val.isEmpty) {
                    return "Saisissez une description du quiz";
                  }
                },
              ),
              Spacer(),

              GestureDetector(
                  onTap: (){
                    _createQuizOnline();
                  },
                  child: Button1(context, "Creer un Quiz", MediaQuery.of(context).size.width - 48, Colors.blue)
              ),
              SizedBox(height: 40.0)
            ],
          ),
        ),
      ),
    );
  }
}