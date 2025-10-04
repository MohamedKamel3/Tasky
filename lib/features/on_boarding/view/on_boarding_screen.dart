import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:to_do_app/core/constants/colors.dart';
import 'package:to_do_app/features/auth/presentation/view/login_screen.dart';
import 'package:to_do_app/features/on_boarding/data/models/on_boarding_model.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});
  static const routName = 'OnBoardingScreen';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController();
  var pageList = onBoardingList();
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  onPageChanged: (value) {
                    currentIndex = value;
                    setState(() {});
                  },
                  physics: BouncingScrollPhysics(),
                  controller: pageController,
                  itemCount: pageList.length,
                  itemBuilder: (context, index) {
                    return CustomAnimatedWidget(
                      delayInMilliseconds: (index + 1) * 100,
                      index: index,
                      child: Image.asset(pageList[index].image),
                    );
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: pageController,
                count: pageList.length,
                effect: ExpandingDotsEffect(
                  spacing: 10,
                  dotWidth: 15,
                  dotHeight: 10,
                  dotColor: Colors.grey,
                  activeDotColor: primaryColor1,
                ),
              ),
              SizedBox(height: 30),
              CustomAnimatedWidget(
                delayInMilliseconds: (currentIndex + 1) * 200,
                index: currentIndex,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        pageList[currentIndex].title,
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        pageList[currentIndex].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: MaterialButton(
        height: 50,
        color: primaryColor1,
        padding: EdgeInsets.all(10),
        onPressed: () {
          if (currentIndex == pageList.length - 1) {
            Navigator.pushReplacementNamed(context, LoginScreen.routName);
          } else {
            pageController.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Text(
          currentIndex == pageList.length - 1 ? 'Get Started' : 'Next',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomAnimatedWidget extends StatelessWidget {
  CustomAnimatedWidget({
    super.key,
    required this.child,
    required this.delayInMilliseconds,
    required this.index,
  });
  Widget child;
  int delayInMilliseconds;
  int index;

  @override
  Widget build(BuildContext context) {
    if (index == 1) {
      return FadeInDown(
        duration: Duration(milliseconds: delayInMilliseconds),
        child: child,
      );
    } else {
      return FadeInUp(
        duration: Duration(milliseconds: delayInMilliseconds),
        child: child,
      );
    }
  }
}
