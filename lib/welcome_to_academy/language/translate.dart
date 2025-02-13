import 'package:academy/main.dart';
import 'ENG.dart';
import 'TH.dart';

Future<String>? futureLoadData;
Future<String> loadData() async {
  await Future.delayed(const Duration(seconds: 1)); // Simulate a network call
  return 'Data Loaded';
}

Future<void> allTranslate() async {
  if (selectedRadio == 1) {
    TH();
  } else if (selectedRadio == 2) {
    ENG();
  }
}


String Search = 'Search';
String NotFoundData = 'NOT FOUND DATA';
String timeout = 'Time Out';
String start = 'Start';
String learning = 'Learning';
String challenge = 'Challenge';
String catalog = 'Catalog';
String favorite = 'Favorite';
String coachCourse = 'Coach Course';
String language = 'Language';
String logout = 'Logout';
String end = 'End';
String time = 'Time';
String skip = 'Skip';
String next = 'Next';
String challengeSection = 'YOU ARE VIEWING CHALLENGE SECTION';
String question = 'QUESTION';
String correct = 'Correct';
String incorrect = 'Incorrect';
String noResult = 'No Result';
String summary = 'Summary';
String myChallenge = 'My Challenge';
String finishedChallenge = 'Finished Challenge';
String Top_Challenge = 'Top Challenge';
String examiner = 'Examiner';
String correctAnswer = 'Correct answer';
String timeUsed = 'Time used';
String startChallenge = 'Start Challenge';
String RequestCA = 'Request challenge again';
String timeStatus = 'TIME STATUS';
String examDuration = 'Exam Duration';
String name = 'Name';
String score = 'Score';
String academy = 'Academy';
String loading = 'Loading';
String AOB = 'Allable On Boarding';
String favoriteTS = 'Favorite';
String status = 'Status';
String student = 'student';
String video = 'Video';
String EnrollForm = 'Enroll form';
String HistoryRequest = 'History request';
String Cancel = 'Cancel';
String Enroll = 'Enroll';
String ERROR = 'ERROR!';
String Download = 'Download';
String exitApp = 'Press back again to exit the origami application.';
String WYL = "What you'll learn?";
String courseIncludes = 'This course includes';
String file = 'File';
String link = 'Link';
String event = 'Event';
String certificate = 'Certificate of completion';
String comments = 'Comments';
String post = 'Post';
String editDiscussion = 'Edit Discussion';
String edit = 'Edit';
String warning = 'Warning!';
String areYouDelete = 'Are you sure you want to delete?';
String delete = 'Delete';
String students = 'Students';
String courses = 'Courses';
String currentPosition = 'Current Position';
String youtubePlayer = 'Youtube Player';
String exitApp2 = 'Press back again to exit';
String elearning = 'E-Learning';
String forgotPwd = 'Forgot Pwd?';
String login = 'LOGIN';
String messageforgotPwd = 'Forgot your password?';
String messageRestPwd = 'Please enter your email address to request a password reset.';
String send = 'SEND';
String returnLogin = 'Return to login.';
String checkPwd = 'Please enter both email and password.';
String statusCodeError = 'Status Code Error!';
String DescriptionTS = 'Description';
String CurriculumTS = 'Curriculum';
String InstructorsTS = 'Instructors';
String CertificationTS = 'Certification';

