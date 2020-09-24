import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'QAModel.dart';

class Quiz extends StatelessWidget {
  int count = 0;
  int currentCount = 0;
  int selectedOption = 0;

  Future<String> _loadAssets() async {
    return await rootBundle.loadString('assets/questions.json');
  }

  @override
  Widget build(context) {
    return FutureBuilder<String>(
        future: _loadAssets(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return _renderQuiz(snapshot.data, context);
          } else {
            return Text('error');
          }
        });
  }

  Widget _renderQuiz(data, context) {
    QuizState quizState = new QuizState(data);
    quizState.data = data;
    return new MaterialApp(
        home: new Scaffold(
      appBar: AppBar(
        title: new Text('Quiz'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: quizState,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            quizState.goNext(context);
          },
          label: Text("Next")),
    ));
  }

  fetchLabel(quizstate, context) {
    return "Next";
  }
}

class QuizState extends StatefulWidget {
  String data;
  QuizState(data) {
    this.data = data;
  }
  _QuizState quizstate = new _QuizState();
  @override
  _QuizState createState() {
    return quizstate;
  }

  void goNext(BuildContext context) {
    if (quizstate.currentCount < quizstate.count) {
      quizstate.updateQuestion(context);
    }
  }
}

class _QuizState extends State<QuizState> {
  int count = 0;
  int currentCount = 0;
  int score = 0;
  Map quizModel;
  List<dynamic> qaList;
  QnA currentQuestion;
  var selectedRadio;
  String buttonLabel;

  _handleRadioValueChange1(value) {
    setState(() {
      selectedRadio = value;
    });
  }

  updateQuestion(parentContext) {
    setState(() {
      final question = QnA.fromJson(qaList[currentCount]);
      question.submittedAnswerOption = selectedRadio;
      if (selectedRadio == question.correctAnswerOption) {
        score++;
      }
      selectedRadio = null;
      if (currentCount < count - 1)
        currentCount++;
      else {
        print('score from quiz route----->>>' + score.toString());
        Navigator.of(parentContext).pop(score);
      }
    });
  }

  createQuestion() {
    List<Widget> options = [];
    final question = QnA.fromJson(qaList[currentCount]);
    options.add(Text(question.questionText,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        )));
    options.add(Divider(
      height: 20,
      color: Colors.lightBlue,
    ));
    for (var option in question.options) {
      options.add(
        RadioListTile(
            value: option.index,
            groupValue: selectedRadio,
            title: Text(option.answerText),
            onChanged: (val) {
              _handleRadioValueChange1(val);
            }),
      );
    }
    return options;
  }

  @override
  void initState() {
    count = 0;
    currentCount = 0;
    selectedRadio = 0;
    score = 0;
    quizModel = jsonDecode(widget.data);
    qaList = quizModel['QnA'];
    count = qaList.length;
    final _qa = qaList[currentCount];
    currentQuestion = QnA.fromJson(_qa);
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.all(8.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: createQuestion()));
  }
}
