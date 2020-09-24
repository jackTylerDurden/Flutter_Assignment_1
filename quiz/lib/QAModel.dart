class QuizModel {
  int score;
  List<QnA> qnA;

  QuizModel({this.score, this.qnA});

  QuizModel.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    if (json['QnA'] != null) {
      qnA = new List<QnA>();
      json['QnA'].forEach((v) {
        qnA.add(new QnA.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    if (this.qnA != null) {
      data['QnA'] = this.qnA.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QnA {
  int index;
  String questionText;
  String correctAnswerOption;
  String submittedAnswerOption;
  List<Options> options;

  QnA(
      {this.index,
      this.questionText,
      this.correctAnswerOption,
      this.submittedAnswerOption,
      this.options});

  QnA.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    questionText = json['questionText'];
    correctAnswerOption = json['correctAnswerOption'];
    submittedAnswerOption = json['submittedAnswerOption'];
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['questionText'] = this.questionText;
    data['correctAnswerOption'] = this.correctAnswerOption;
    data['submittedAnswerOption'] = this.submittedAnswerOption;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String index;
  String answerText;

  Options({this.index, this.answerText});

  Options.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    answerText = json['answerText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['answerText'] = this.answerText;
    return data;
  }
}
