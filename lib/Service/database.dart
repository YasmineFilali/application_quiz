import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore ref = FirebaseFirestore.instance;
class DatabaseService{

  getQuizData() async{
    return await ref.collection("Quiz").snapshots();
  }

  getQuestionData(String quizId) async{
    return await ref.collection("Quiz").doc(quizId).collection("QNA").get();
  }

  Future<void> addQuestionData(Map<String, String> questionData, String quizId, String questionId) async{
    await ref.collection("Quiz").doc(quizId).collection("QNA").doc(questionId).set(questionData).catchError((e){
      print(e.toString());});
  }

  Future<void> addQuizData(Map<String, String> quizData, String quizId) async{
    await ref.collection("Quiz").doc(quizId).set(quizData).catchError((e){print(e.toString());});
  }

  deleteQuizData(String quizId) async {
    await FirebaseFirestore.instance.collection("Quiz").doc(quizId).delete().catchError((e){
      print(e.toString());
    });
  }

  deleteQuestionData(String quizId, String questionId) async {
    await FirebaseFirestore.instance.collection("Quiz").doc(quizId).collection("QNA").doc(questionId).delete().catchError((e){
      print(e.toString());
    });
  }
}