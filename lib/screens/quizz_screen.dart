import 'dart:async';

import 'package:flexi_timer/flexi_timer.dart';
import 'package:flutter/material.dart';
import 'package:quizz_app/data/questions_example.dart';
import 'package:quizz_app/screens/result_screen.dart';


class QuizzScreen extends StatefulWidget {
  const QuizzScreen({Key? key}) : super(key: key);

  @override
  _QuizzScreenState createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  // ignore: non_constant_identifier_names
  int question_pos = 0;
  int score = 0;
  bool btnPressed = false;
  PageController? _controller;
  String btnText = "Sonraki Soru";
  String btnText2 = "Önceki Soru";
  bool answered = false;
  @override
  void initState() {
    
    super.initState();
    _controller = PageController(initialPage: 0);
  }
 FlexiTimerController _timerController = FlexiTimerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xFF252c4a),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          
          FlexiTimer(
          
              controller: _timerController,
              duration: const Duration(seconds: 30),
              timerFormat: TimerTextFormat.Hms,
              onComplete: () {
                 Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(score),
                        ));
              },
              textStyle: const TextStyle(
                color: Colors.orange,
                fontSize: 20,
              ),
              isDiplayIcon: true,
              iconPosition: IconPosition.suffix,
              icon: const Icon(
                Icons.timer_rounded,
                color: Colors.green,
              ),
            ),],
        
        ),
      
      body: Padding(

          padding: const EdgeInsets.all(18.0),
          child: PageView.builder(
            controller: _controller!,
            onPageChanged: (page) {
              if (page == questions.length - 1) {
                setState(() {
                  btnText = "BİTİR";
                });
              }
              setState(() {
                answered = false;
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "SORU ${index + 1}/10",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.orange,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: SingleChildScrollView(
                        child: Text(
                          "${questions[index].question}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ),
                    const Text(" "),
                    for (int i = 0; i < questions[index].answers!.length; i++)
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        margin: const EdgeInsets.only(
                            bottom: 20.0, left: 12.0, right: 12.0),
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          fillColor: btnPressed
                              ? questions[index].answers!.values.toList()[i]
                                  ? Colors.green
                                  : Colors.red
                              : Colors.purple,
                          onPressed: !answered
                              ? () {
                                  if (questions[index]
                                      .answers!
                                      .values
                                      .toList()[i]) {
                                    score++;
                                    // ignore: avoid_print
                                    print("yes");
                                  } else {
                                    // ignore: avoid_print
                                    print("no");
                                  }
                                  setState(() {
                                    btnPressed = true;
                                    answered = true;
                                  });
                                }
                              : null,
                          child: Text(questions[index].answers!.keys.toList()[i],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              )),
                        ),
                      ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        if (_controller!.page?.toInt() == questions.length - 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen(score)));
                        } else {
                          _controller!.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInExpo);

                          setState(() {
                            btnPressed = false;
                          });
                        }
                      },
                      shape: const StadiumBorder(),
                      fillColor: Colors.orange,
                      padding: const EdgeInsets.all(18.0),
                      elevation: 0.0,
                      child: Text(
                        btnText,
                        style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        if(_controller!.page?.toInt()==questions[0]){
                          setState(() {
                            btnPressed=false;
                          });
                        }
                        else{
                          _controller?.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInExpo);
                        }
                       
                      },
                      shape: const StadiumBorder(),
                      fillColor: Colors.orange,
                      padding: const EdgeInsets.all(18.0),
                      elevation: 0.0,
                      child: Text(
                        btnText2,
                        style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: questions.length,
          )),
    );
  }
}
