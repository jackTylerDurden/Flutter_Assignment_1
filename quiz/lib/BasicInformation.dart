import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Quiz.dart';

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

// Create a Form widget.
class BasicInfoForm extends StatefulWidget {
  final BasicInfoFormState basicInfoFormState = new BasicInfoFormState();
  @override
  BasicInfoFormState createState() {
    return basicInfoFormState;
  }

  void submitForm(BuildContext context) {
    if (basicInfoFormState._formKey.currentState.validate()) {
      basicInfoFormState._formKey.currentState.save();
      Navigator.pushNamed(context, '/quiz');
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
  String questions;

  @override
  void initState() {
    _loadModel();
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _firstNameController,
            key: Key('firstName'),
            decoration: new InputDecoration(labelText: 'First (given) name'),
            validator: validateValues,
            onSaved: (String value) {
              _saveModel('firstName', value);
            },
          ),
          TextFormField(
              key: Key('lastName'),
              controller: _lastNameController,
              decoration: new InputDecoration(labelText: 'Last (family) name'),
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
              })
        ],
      ),
    );
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
