import 'package:Netflix/Screens/signin.dart';
import 'package:Netflix/Screens/signup.dart';
import 'package:flutter/material.dart';

class getStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/background.jpg',
            fit: BoxFit.fill,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3)
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "images/netflixicon.png",
                          height: 60,
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text('PRIVACY'),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return SignIn();
                                  },
                                ));
                              },
                              child: Text('LOG IN'),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          'Unlimited\nmovies, TV\nshows & more',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Netflix"),
                        ),
                        SizedBox(height: 16),
                        Text(
                          textAlign: TextAlign.center,
                          'Watch anywhere. Cancel anytime.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return SignUp();
                              },
                            ));
                          },
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            backgroundColor: Colors.red,
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              4,
                              (index) => Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          index == 0 ? Colors.red : Colors.grey,
                                    ),
                                  )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
