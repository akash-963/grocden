import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget{
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<void> _login() async {
//     if(_formKey.currentState!.validate()){
//       try{
//         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//             email: _emailController.text,
//             password: _passwordController.text
//         );
//
//         // set shared preferences userId
//         final user = FirebaseAuth.instance.currentUser;
//         final userId = user?.uid;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString("userId",userId!);
//         print(userId);
//
//         // Navigate to home tab on login
//         Navigator.pushReplacementNamed(context, '/home');
//
//       }  on FirebaseAuthException catch (e) {
//
//         // Errors on Authentication Exception
//         String errorMessage = 'An error occurred. Please try again later.';
//         if (e.code == 'user-not-found') {
//           errorMessage = 'No user found with this email.';
//         } else if (e.code == 'wrong-password') {
//           errorMessage = 'Incorrect password.';
//         } else if (e.code == 'invalid-email') {
//           errorMessage = 'Invalid email address.';
//         } else if (e.code == 'user-disabled') {
//           errorMessage = 'User account is disabled.';
//         } else if (e.code == 'too-many-requests') {
//           errorMessage = 'Too many login attempts. Please try again later.';
//         }
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(errorMessage),
//           duration: Duration(seconds: 5),
//         ));
//       } catch (e) {
//
//         // other errors
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('An error occurred. Please try again later.'),
//           duration: Duration(seconds: 5),
//         ));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return Stack(
//         children: <Widget>[
//           ColorFiltered(
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.85), // 75% transparency
//               BlendMode.srcATop,
//             ),
//             child: Image.asset(
//               "assets/images/background.jpeg",
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               title: Text('Login Page'),
//             ),
//             body: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     //mainAxisSize: MainAxisSize.max,
//                     children: [
//                       TextFormField(
//                         cursorColor: Colors.white,
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                             hintText: 'Enter Email',
//                             labelText: 'Email',
//
//                         ),
//                         validator: (value){
//                           if (value!.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           // add more email validation logic
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 10,),
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                             hintText: 'Enter Password',
//                             labelText: 'Password'
//                         ),
//                         validator: (value){
//                           if (value!.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           // add more password validation logic
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 10,),
//                       ElevatedButton(
//                           onPressed: _login,
//                           child: Text('Login')
//                       ),
//
//                       SizedBox(height: 10,),
//                       Row(
//                           children: [
//                             TextButton(
//                               onPressed: (){
//                                 //implement forget password functionality
//                               },
//                               child: Text('Forget Password'),
//                             ),
//                             Spacer(),
//                             ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.pushNamed(context, '/signup');
//                                 },
//                                 child: Text('signup')
//                             ),
//                           ]
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ]
//     );
//   }
// }























class LoginPageClass extends StatefulWidget {
  const LoginPageClass({super.key});

  @override
  State<LoginPageClass> createState() => _LoginPageClassState();
}

class _LoginPageClassState extends State<LoginPageClass> {
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

        // set shared preferences userId
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userId",userId!);
        print(userId);

        // Navigate to home tab on login
        Navigator.pushReplacementNamed(context, '/home');

      }  on FirebaseAuthException catch (e) {

        // Errors on Authentication Exception
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

        // other errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred. Please try again later.'),
          duration: Duration(seconds: 5),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          //mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFa1ff00),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter Email',
                                labelText: 'Email',
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
                            SizedBox(height: 16,),
                            ElevatedButton(
                                onPressed: _login,
                                style: ButtonStyle(

                                ),
                                child: SizedBox(
                                    height: 48,
                                    width: 100,
                                    child: Center(
                                        child: Text('Login')
                                    )
                                )
                            ),

                            Spacer(),
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
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
