import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BasicInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Basic Information';
    final proceedToQuizMessage = 'Proceed to Quiz';
    BasicInfoForm basicInfoForm = new BasicInfoForm();
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: basicInfoForm,
        floatingActionButton: FloatingActionButton.extended(
            label: Text(proceedToQuizMessage),
            onPressed: () {
              basicInfoForm.submitForm(context);
            },
            icon: Icon(Icons.arrow_right),
            backgroundColor: Colors.lightBlue),
      ),
    );
  }
}

class BasicInfoForm extends StatefulWidget {
  final BasicInfoFormState basicInfoFormState = new BasicInfoFormState();
  @override
  BasicInfoFormState createState() {
    return basicInfoFormState;
  }

  Future<void> submitForm(BuildContext context) async {
    if (basicInfoFormState._formKey.currentState.validate()) {
      basicInfoFormState._formKey.currentState.save();
      var res = await Navigator.pushNamed(context, '/quiz');
      basicInfoFormState.updateScore(res);
    }
  }
}

class BasicInfoFormState extends State<BasicInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController =
      new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _nickNameController = new TextEditingController();
  final TextEditingController _ageController = new TextEditingController();
  final errorMessage = 'Please enter some value';
  int score;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/score.text');
  }

  updateScore(scoreVal) {
    setState(() {
      score = scoreVal;
      writeScore(score);
    });
  }

  writeScore(score) async {
    final file = await _localFile;
    return file.writeAsString('$score');
  }

  readScore() async {
    try {
      final file = await _localFile;
      String scoreStr = await file.readAsString();
      setState(() {
        score = int.parse(scoreStr);
      });
      return int.parse(scoreStr);
    } catch (e) {
      return 0;
    }
  }

  @override
  void initState() {
    _loadModel();
    readScore();
    // _loadAssets();
    return super.initState();
  }

  _loadModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = (prefs.getString('firstName') ?? '');
      _lastNameController.text = (prefs.getString('lastName') ?? '');
      _nickNameController.text = (prefs.getString('nickName') ?? '');
      _ageController.text = (prefs.getInt('age').toString() ?? '0');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.all(8.0),
        child:
            new Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          new Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _firstNameController,
                  key: Key('firstName'),
                  decoration:
                      new InputDecoration(labelText: 'First (given) name'),
                  validator: validateValues,
                  onSaved: (String value) {
                    _saveModel('firstName', value);
                  },
                ),
                TextFormField(
                    key: Key('lastName'),
                    controller: _lastNameController,
                    decoration:
                        new InputDecoration(labelText: 'Last (family) name'),
                    validator: validateValues,
                    onSaved: (String value) {
                      _saveModel('lastName', value);
                    }),
                TextFormField(
                    key: Key('nickName'),
                    controller: _nickNameController,
                    decoration: new InputDecoration(labelText: 'Nickname'),
                    validator: validateValues,
                    onSaved: (String value) {
                      _saveModel('nickName', value);
                    }),
                TextFormField(
                    key: Key('age'),
                    controller: _ageController,
                    decoration: new InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: validateValues,
                    onSaved: (String value) {
                      _saveModel('age', int.parse(value));
                    }),
                Text("\n\nScore : " + score.toString(),
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ))
              ],
            ),
          )
        ]));
  }

  String validateValues(value) {
    if (value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  _saveModel(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switch (value.runtimeType.toString()) {
        case 'int':
          prefs.setInt(key, value);
          break;
        case 'double':
          prefs.setDouble(key, value);
          break;
        case 'bool':
          prefs.setBool(key, value);
          break;
        default:
          prefs.setString(key, value);
          break;
      }
    });
  }
}
