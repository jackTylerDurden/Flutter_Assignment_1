import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'QAModel.dart';

class Quiz extends StatelessWidget {
  int count = 0;
  int currentCount = 0;
  int selectedOption = 0;
  QAModel currentQuestion;
  Text currentQuestionText;

  Future<String> _loadAssets() async {
    return await rootBundle.loadString('assets/questions.json');
  }

  @override
  Widget build(context) {
    return FutureBuilder<String>(
        future: _loadAssets(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return _renderQuiz(snapshot.data);
          } else {
            return Text('error');
          }
        });
  }

  _handleRadioValueChange1(value) {
    print('value-------->>>' + value.answerText);
    print('value-------->>>' + value.index);
    currentQuestion.submittedAnswerOption = value.index;
  }

  goNext() {
    currentCount++;
    print('value-------->>>' + currentCount.toString());
  }

  List<Widget> createRadioOptions() {
    List<Widget> options = [];
    int i = 0;
    options.add(Text(currentQuestion.questionText,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        )));
    options.add(Divider(
      height: 20,
      color: Colors.lightBlue,
    ));
    for (var option in currentQuestion.options) {
      options.add(
        RadioListTile(
          value: option,
          groupValue: "a",
          title: Text(option.answerText),
          onChanged: _handleRadioValueChange1,
          selected: false,
        ),
      );
    }
    return options;
  }

  Widget _renderQuiz(data) {
    final qaList = jsonDecode(data);
    count = qaList.length;
    final _qa = qaList[currentCount];
    currentQuestion = QAModel.fromJson(_qa);

    return new MaterialApp(
        home: new Scaffold(
      appBar: AppBar(
        title: new Text('Quiz'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: new Container(
          padding: EdgeInsets.all(8.0),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: createRadioOptions())),
      floatingActionButton:
          FloatingActionButton.extended(onPressed: goNext, label: Text("Next")),
    ));
  }
}
