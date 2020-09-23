class QAModel {
  int index;
  String questionText;
  String correctAnswerOption;
  String submittedAnswerOption;
  List<Options> options;

  QAModel(
      {this.index,
      this.questionText,
      this.correctAnswerOption,
      this.submittedAnswerOption,
      this.options});

  QAModel.fromJson(Map<String, dynamic> json) {
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
