import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thesis_app/page/login_selection.dart';
import 'package:thesis_app/page/register.dart';
import 'package:thesis_app/widget/toast_msg.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  
  @override
  LoginPageState createState() => LoginPageState();
}

TextEditingController emailController =  TextEditingController();
TextEditingController passController =  TextEditingController();
bool validEmail = false;
bool validPass = false;
final FirebaseAuth auth = FirebaseAuth.instance;
bool isLoading = false;
FToast flutterToast;

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterToast = FToast(context);

  }

  @override
  Widget build(BuildContext context) {

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
      else{
        msg = null;
        validPass = true;
      }

      return msg;
    }

    Widget loginTitle(){
      return Padding(
        padding: EdgeInsets.only(bottom: 20, left: 30, right: 30, top: 50),
        child: Container(
            width: double.infinity,
            child: Text('Login', style: TextStyle(fontSize: 36), textAlign: TextAlign.left,)
        ),
      );
    }

    Widget formEmailInput(){
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

    Widget formPasswordInput(){
      return Container(
        margin: EdgeInsets.only(bottom: 50),
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

    void loginValidate() async{
      setState(() {
        isLoading = true;
      });
      if (formKey.currentState.validate()) {
        if(validEmail == true && validPass == true){
          final user = await auth
              .signInWithEmailAndPassword(email: emailController.text, password: passController.text,)
              .catchError((e){
            setState(() {
              isLoading = false;
            });
            ToastMsg(msg: e.code.toString(), flutterToast: flutterToast).showToast();
          })
              .whenComplete((){
            setState(() {
              isLoading = false;
            });
          });
          if(user!= null){
            emailController.clear();
            passController.clear();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
          }

        }
      }
      else{
        setState(() {
          isLoading = false;
        });
      }
    }

    Widget loginButton(){
      return Container(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.blueAccent,
          child: InkWell(
              onTap: loginValidate,
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 20),
                child: Text('Let\'s Go!', style: TextStyle(color: Colors.white),),
              )
          ),
        ),
      );
    }

    Widget registerGuide(){
      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 60, left: 50, right: 50, bottom: 20),
        child: Center(child: Text('Don\'t have account yet?', style: TextStyle(fontSize: 16), textAlign: TextAlign.left,)),
      );
    }

    Widget registerButton(){
      return Container(
        alignment: Alignment.center,
        child: Material(
          color: Colors.redAccent,
          child: InkWell(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 20),
                child: Text('Here!', style: TextStyle(color: Colors.white),),
              )
          ),
        ),
      );
    }

    Widget showCircularProgress() {
      if (isLoading) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white10,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }

    Widget showForm(){
      return Container(
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                loginTitle(),
                formEmailInput(),
                formPasswordInput(),
                loginButton(),
                registerGuide(),
                registerButton(),
              ],
            ),
          ));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.black,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginSelectionPage()),
                );
              },
            ),
          ),
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              showForm(),
              showCircularProgress()
            ],
          ),
        ),

      ),
    );
  }

}
