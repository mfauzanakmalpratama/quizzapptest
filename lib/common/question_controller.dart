import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quizzapptest/common/Questions.dart';
import 'package:quizzapptest/pages/score_page/score_page.dart';

// We use get package for our state management

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  // Lets animated our progress bar

  AnimationController _animationController;
  Animation _animation;
  // so that we can access our animation outside
  Animation get animation => _animation;

  PageController _pageController;
  PageController get pageController => _pageController;

  final List<Question> _questions = sample_data
      .map(
        (question) => Question(
        id: question['id'],
        question: question['question'],
        options: question['options'],
        answer: question['answer_index']),
  )
      .toList();
  List<Question> get questions => _questions;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  int _correctAns;
  int get correctAns => _correctAns;

  int _selectedAns;
  int get selectedAns => _selectedAns;

  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;


  @override
  void onInit() {
    _animationController =
        AnimationController(duration: const Duration(seconds: 60), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        // update like setState
        update();
      });


    _animationController.forward().whenComplete(nextQuestion);
    _pageController = PageController();
    super.onInit();
  }


  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _pageController.dispose();
  }

  void checkAns(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    _animationController.stop();
    update();

    Future.delayed(const Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      _animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      // Get package provide us simple way to naviigate another page
      Get.to(const ScoreScreen());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }
}