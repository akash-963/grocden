import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    if(_formKey.currentState!.validate()){
      try{
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text
        );
        Navigator.pushReplacementNamed(context, '/home');
      }  on FirebaseAuthException catch (e) {
        String errorMessage = 'An error occurred. Please try again later.';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email address.';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'User account is disabled.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Too many login attempts. Please try again later.';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 5),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred. Please try again later.'),
          duration: Duration(seconds: 5),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
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
                SizedBox(height: 10,),
                ElevatedButton(
                    onPressed: _login,
                    child: Text('Login')
                ),

                SizedBox(height: 10,),
                Row(
                    children: [
                      TextButton(
                        onPressed: (){
                          //implement forget password functionality
                        },
                        child: Text('Forget Password'),
                      ),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text('signup')
                      ),
                    ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}