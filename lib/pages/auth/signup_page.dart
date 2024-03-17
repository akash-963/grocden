import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPageClass extends StatefulWidget{
  @override
  State<SignupPageClass> createState() => _SignupPageClassState();
}

class _SignupPageClassState extends State<SignupPageClass> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signup() async {
    if(_formkey.currentState!.validate()){
      try {
        await _auth
            .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text
        );

        // set shared preferences userId
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userId",userId!);
        print(userId);

        Navigator.pushReplacementNamed(context, '/locality');
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'An error occurred. Please try again later.';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for this email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email address.';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 5),
        ));

      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          duration: Duration(seconds: 5),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Stack(
        children: <Widget>[
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Color(0xFFb7fa62), // 75% transparency
              BlendMode.srcATop,
            ),
            child: Image.asset(
              "assets/images/background.jpeg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                  children: [
                    Opacity(
                      opacity: 0.80,
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fitWidth,
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.70,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Container(
                            child: Center(
                              child: Form(
                                key: _formkey,
                                child: Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        "SignUp",
                                        style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFa1ff00),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                            hintText: 'Enter Email',
                                            labelText: 'Email'
                                        ),
                                        validator: (value){
                                          if (value!.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          // add more email validation logic
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10,),
                                      TextFormField(
                                        obscureText: true,
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                            hintText: 'Enter Password',
                                            labelText: 'Password'
                                        ),
                                        validator: (value){
                                          if (value!.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          // add more password validation logic
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 16,),

                                      ElevatedButton(
                                          onPressed: _signup,
                                          child: SizedBox(
                                              height: 48,
                                              width: 100,
                                              child: Center(
                                                  child: Text(
                                                    'Sign Up',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                              )
                                          )
                                      ),

                                      Spacer(),
                                      Row(
                                        children: [
                                          Spacer(),
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pushNamed(context, '/login');
                                            },
                                            child: Text('Already have an account? Login'),
                                          ),
                                        ],
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ]
    );
  }
}