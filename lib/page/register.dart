import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thesis_app/page/home.dart';
import 'package:thesis_app/page/login.dart';
import 'package:thesis_app/widget/toast_msg.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super (key : key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

TextEditingController emailController = new TextEditingController();
TextEditingController passController = new TextEditingController();
TextEditingController confirmPassController = new TextEditingController();
bool validEmail = false;
bool validPass = false;
bool isLoading = false;
FToast flutterToast;
final FirebaseAuth _auth = FirebaseAuth.instance;

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterToast = FToast(context);
  }
  @override
  Widget build(BuildContext context) {

    final GlobalKey<FormState> formKeyRegister = GlobalKey<FormState>();

    void loginValidate() async{
      setState(() {
        isLoading = true;
      });
      if (formKeyRegister.currentState.validate()) {
        if(validEmail == true && validPass == true){
          final user = await _auth
              .createUserWithEmailAndPassword(email: emailController.text, password: passController.text,)
              .catchError((e){
            setState(() {
              isLoading = false;
            });
            ToastMsg(msg: e.code.toString(), flutterToast: flutterToast).showToast();
          }).whenComplete((){
            setState(() {
              isLoading = false;
            });
          });
          if(user!= null){
            final login = await _auth.signInWithEmailAndPassword(email: emailController.text, password: passController.text);
            if(login != null){
              emailController.clear();
              passController.clear();
              confirmPassController.clear();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
            }
          }

        }
      }
      else{
        setState(() {
          isLoading = false;
        });
      }
    }

    String emailValidator(String value){
      String msg ="";
      if(EmailValidator.validate(value) == false && value.isNotEmpty){
        msg = "Invalid email address";
        validEmail = false;
      }
      if(value.isEmpty){
        msg = "E\-mail can\'t be empty";
        validEmail = false;
      }
      if(EmailValidator.validate(value) == true && value.isNotEmpty){
        msg = null;
        validEmail = true;
      }
      return msg;
    }
    String passValidator(String value){
      String msg = "";
      if(passController.text.length < 6){
        msg = "Password atleast 6 characters";
        validPass = false;
      }
      else
        msg = null;
      return msg;
    }

    String confirmPassValidator(String value){
      String msg = "";
      if(value.isEmpty){
        msg = "Confirm Password can\'t be empty";
        validPass = false;
      }
      if(passController.text != confirmPassController.text){
        msg = "Password not match";
        validPass = false;
      }
      if(passController.text == confirmPassController.text && value.isNotEmpty){
        msg = null;
        validPass = true;
      }
      return msg;
    }

    Widget showCircularProgress() {
      if (isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }

    Widget _registerTitle(){
      return Padding(
        padding: EdgeInsets.only(bottom: 20, left: 30, right: 30, top: 50),
        child: Container(
            width: double.infinity,
            child: Text('Register', style: TextStyle(fontSize: 36), textAlign: TextAlign.left,)
        ),
      );
    }

    Widget _formEmailInput(){
      return Padding(
        padding: EdgeInsets.only(left: 30,right: 30),
        child: TextFormField(
          controller: emailController,
          autofocus: false,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'E-mail',
          ),
          validator: emailValidator,
        ),
      );
    }

    Widget _formPasswordInput(){
      return Padding(
        padding: EdgeInsets.only(left: 30,right: 30),
        child: TextFormField(
          controller: passController,
          autofocus: false,
          maxLines: 1,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
          ),
          validator: passValidator,
        ),
      );
    }

    Widget _formConfirmPasswordInput(){
      return Padding(
        padding: EdgeInsets.only(left: 30,right: 30),
        child: TextFormField(
          controller: confirmPassController,
          autofocus: false,
          maxLines: 1,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
          ),
          validator: confirmPassValidator,
        ),
      );
    }

    Widget _registerButton(){
      return Container(
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.redAccent,
          child: InkWell(
              onTap: loginValidate,
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 20),
                child: Text('Here!', style: TextStyle(color: Colors.white),),
              )
          ),
        ),
      );
    }

    Widget _showForm(){
      return new Container(
          child: new Form(
            key: formKeyRegister,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                _registerTitle(),
                _formEmailInput(),
                _formPasswordInput(),
                _formConfirmPasswordInput(),
                _registerButton(),

              ],
            ),
          )
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.black,),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ),
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              _showForm(),
              showCircularProgress()
            ],
          ),
        ),

      ),
    );
  }
}
