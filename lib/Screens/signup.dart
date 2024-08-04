import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Netflix/Screens/homepage.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CustomTextForm extends StatefulWidget {
  CustomTextForm({
    super.key,
    required this.hinttext,
    this.mycontroller,
    this.isPassword = false,
    this.errorText,
  });

  final String hinttext;
  final TextEditingController? mycontroller;
  final bool isPassword;
  final String? errorText;

  @override
  _CustomTextFormState createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus || widget.mycontroller?.text.isNotEmpty == true) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        Container(
          color: _focusNode.hasFocus
              ? Color.fromRGBO(128, 128, 128, 0.6)
              : Color.fromRGBO(128, 128, 128, 0.4),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              Positioned(
                left: 15,
                top: _focusNode.hasFocus ||
                        widget.mycontroller?.text.isNotEmpty == true
                    ? 5
                    : 15,
                child: Transform.scale(
                  scale: _animation.value,
                  child: Text(
                    widget.hinttext,
                    style: TextStyle(
                      color:
                          _focusNode.hasFocus ? Colors.white : Colors.white54,
                      fontSize: _focusNode.hasFocus ||
                              widget.mycontroller?.text.isNotEmpty == true
                          ? 12
                          : 18,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: widget.mycontroller,
                focusNode: _focusNode,
                obscureText: widget.isPassword ? _obscureText : false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null,
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: widget.isPassword
                    ? TextInputType.text
                    : TextInputType.emailAddress,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const String _baseURL = 'http://netflixclone.mywebcommunity.org';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  void signUp(String email, String password) async {
    try {
      final response = await http
          .post(Uri.parse('$_baseURL/signUp.php'),
              headers: {'Content-Type': 'application/json'},
              body: convert.jsonEncode({
                'email': email,
                'password': password,
              }))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseBody = convert.jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful')),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ));
        } else if (responseBody['status'] == 'error' &&
            responseBody['message'] == 'User already registered') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User already registered')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Registration failed: ${responseBody['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } on http.ClientException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error. Please try again later.')),
      );
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request timed out. Please try again.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final List<String> footer = [
    "FAQ",
    "Terms of use",
    "Cookie Preferences",
    "Help Center",
    "Privacy",
    "Corporate Information",
  ];
  bool rememberMe = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: 500,
        backgroundColor: Colors.black,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Image.asset(
              width: 100,
              "images/netflix_logo.png",
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    child: Text(
                      "Sign Up",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    child: CustomTextForm(
                      mycontroller: controllerEmail,
                      hinttext: "Email",
                      errorText: _emailErrorText,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    child: CustomTextForm(
                      mycontroller: controllerPassword,
                      hinttext: "Password",
                      isPassword: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final email = controllerEmail.text;
                          final password = controllerPassword.text;
                          signUp(email, password);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                        checkColor: Colors.black,
                        fillColor: MaterialStateProperty.all(Colors.white),
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Need help?",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Row(
                    children: [
                      SizedBox(
                        child: Text(
                          "Already Have An Account? ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        child: Text(
                          "Sign In.  ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "This page is protected by Google reCAPTCHA to ensure you're not a bot. Learn more. ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  Column(
                    children: [
                      for (int i = 0; i < footer.length; i += 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    footer[i],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (i + 1 < footer.length)
                              Expanded(
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    footer[i + 1],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? get _emailErrorText {
    final email = controllerEmail.text;
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }
    final pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
