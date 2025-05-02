import 'package:academy/welcome_to_academy/export.dart';

class ModelDropdownAcademy {
  String id;
  String name;
  ModelDropdownAcademy({
    required this.id,
    required this.name,
  });

  @override
  String toString() => name; // ต้อง return ชื่อที่ต้องการแสดงใน dropdown
}

class AcademyRespond {
  final String academy_id;
  final String academy_type;
  final String academy_subject;
  final String academy_image;
  final String academy_category;
  final String academy_date;
  final List<AcademyCoachData> academy_coach_data;
  final String favorite;
  // final int favorite;

  AcademyRespond({
    required this.academy_id,
    required this.academy_type,
    required this.academy_subject,
    required this.academy_image,
    required this.academy_category,
    required this.academy_date,
    required this.academy_coach_data,
    required this.favorite,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory AcademyRespond.fromJson(Map<String, dynamic> json) {
    return AcademyRespond(
      academy_id: json['academy_id'] ?? '',
      academy_type: json['academy_type'] ?? '',
      academy_subject: json['academy_subject'] ?? '',
      academy_image: json['academy_image'] ?? '',
      academy_category: json['academy_category'] ?? '',
      academy_date: json['academy_date'] ?? '',
      academy_coach_data: (json['academy_coach_data'] as List?)
              ?.map((statusJson) => AcademyCoachData.fromJson(statusJson))
              .toList() ??
          [],
      favorite: json['favorite']?.toString() ?? '',
      // favorite: json['favorite'] ?? 0,
    );
  }

  // การแปลง Object ของ Academy กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'academy_id': academy_id,
      'academy_type': academy_type,
      'academy_subject': academy_subject,
      'academy_image': academy_image,
      'academy_category': academy_category,
      'academy_date': academy_date,
      'academy_coach_data':
          academy_coach_data.map((item) => item.toJson()).toList(),
      'favorite': favorite,
    };
  }
}

class AcademyCoachData {
  final String name;
  final String avatar;

  AcademyCoachData({
    required this.name,
    required this.avatar,
  });

  // ฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ AcademyCoachData
  factory AcademyCoachData.fromJson(Map<String, dynamic> json) {
    return AcademyCoachData(
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  // การแปลง Object ของ AcademyCoachData กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
    };
  }
}

class Challenge {
  String challengeDescription;
  String challengeDuration;
  String challengeEnd;
  String challengeId;
  String challengeLogo;
  String challengeName;
  String challengePointValue;
  String challengeQuestionPart;
  String challengeRank;
  String challengeRule;
  String challengeStart;
  String challengeStatus;
  int correctAnswer;
  String endDate;
  String requestId;
  int specificQuestion;
  String startDate;
  String status;
  String timerFinish;
  String timerStart;

  Challenge({
    required this.challengeDescription,
    required this.challengeDuration,
    required this.challengeEnd,
    required this.challengeId,
    required this.challengeLogo,
    required this.challengeName,
    required this.challengePointValue,
    required this.challengeQuestionPart,
    required this.challengeRank,
    required this.challengeRule,
    required this.challengeStart,
    required this.challengeStatus,
    required this.correctAnswer,
    required this.endDate,
    required this.requestId,
    required this.specificQuestion,
    required this.startDate,
    required this.status,
    required this.timerFinish,
    required this.timerStart,
  });

  // การสร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Challenge
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      challengeDescription: json['challenge_description']??'',
      challengeDuration: json['challenge_duration']??'',
      challengeEnd: json['challenge_end']??'',
      challengeId: json['challenge_id']??'',
      challengeLogo: json['challenge_logo']??'',
      challengeName: json['challenge_name']??'',
      challengePointValue: json['challenge_point_value']??'',
      challengeQuestionPart: json['challenge_question_part']??'',
      challengeRank: json['challenge_rank']??'',
      challengeRule: json['challenge_rule']??'',
      challengeStart: json['challenge_start']??'',
      challengeStatus: json['challenge_status']??'',
      correctAnswer: json['correct_answer']??0,
      endDate: json['end_date']??'',
      requestId: json['request_id']??'',
      specificQuestion: json['specific_question']??0,
      startDate: json['start_date']??'',
      status: json['status']??'',
      timerFinish: json['timer_finish']??'',
      timerStart: json['timer_start']??'',
    );
  }

  // การแปลง Object ของ Challenge กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'challenge_description': challengeDescription,
      'challenge_duration': challengeDuration,
      'challenge_end': challengeEnd,
      'challenge_id': challengeId,
      'challenge_logo': challengeLogo,
      'challenge_name': challengeName,
      'challenge_point_value': challengePointValue,
      'challenge_question_part': challengeQuestionPart,
      'challenge_rank': challengeRank,
      'challenge_rule': challengeRule,
      'challenge_start': challengeStart,
      'challenge_status': challengeStatus,
      'correct_answer': correctAnswer,
      'end_date': endDate,
      'request_id': requestId,
      'specific_question': specificQuestion,
      'start_date': startDate,
      'status': status,
      'timer_finish': timerFinish,
      'timer_start': timerStart,
    };
  }
}
