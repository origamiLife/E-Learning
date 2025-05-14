
import 'package:http/http.dart' as http;
import '../export.dart';
import 'evaluate/evaluate_module.dart';

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

class AcademyModel {
  final String academy_id;
  final String academy_type;
  final String academy_name;
  final String academy_cover;
  final String academy_cover_error;
  final String academy_categories;
  final String academy_favorite;
  final String academy_flag;
  final String academy_text;
  final List<AcademyCoachModel> academy_coach;

  AcademyModel({
    required this.academy_id,
    required this.academy_type,
    required this.academy_name,
    required this.academy_cover,
    required this.academy_cover_error,
    required this.academy_categories,
    required this.academy_favorite,
    required this.academy_flag,
    required this.academy_text,
    required this.academy_coach,
  });

  factory AcademyModel.fromJson(Map<String, dynamic> json) {
    return AcademyModel(
      academy_id: json['academy_id'] ?? '',
      academy_type: json['academy_type'] ?? '',
      academy_name: json['academy_name'] ?? '',
      academy_cover: json['academy_cover'] ?? '',
      academy_cover_error: json['academy_cover_error'] ?? '',
      academy_categories: json['academy_categories'] ?? '',
      academy_favorite: json['academy_favorite'] ?? '',
      academy_flag: json['academy_flag'] ?? '',
      academy_text: json['academy_text'] ?? '',
      academy_coach: (json['academy_coach'] as List?)
              ?.map((e) => AcademyCoachModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AcademyCoachModel {
  final String coach_name;
  final String coach_image;
  final String coach_image_error;

  AcademyCoachModel({
    required this.coach_name,
    required this.coach_image,
    required this.coach_image_error,
  });

  factory AcademyCoachModel.fromJson(Map<String, dynamic> json) {
    return AcademyCoachModel(
      coach_name: json['coach_name'] ?? '',
      coach_image: json['coach_image'] ?? '',
      coach_image_error: json['coach_image_error'] ?? '',
    );
  }
}

class PaginationModel {
  final int page;
  final int per_page;
  final int total_items;
  final int total_pages;

  PaginationModel({
    required this.page,
    required this.per_page,
    required this.total_items,
    required this.total_pages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 0,
      per_page: json['per_page'] ?? 0,
      total_items: json['total_items'] ?? 0,
      total_pages: json['total_pages'] ?? 0,
    );
  }
}

class CategoryData {
  final String category_id;
  final String category_name;

  CategoryData({
    required this.category_id,
    required this.category_name,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      category_id: json['category_id'] ?? '',
      category_name: json['category_name'] ?? '',
    );
  }
}

class LevelData {
  final Map<String, String> level_data;
  LevelData({required this.level_data});

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(level_data: Map<String, String>.from(json['level_data']));
  }
}

class GetEnrollModel {
  final String enroll_id;
  final String remark_request;
  final String date_request;
  final String last_modify;
  final String enroll_status;
  final String enroll_status_date;
  final String can_edit;
  final String can_delete;

  GetEnrollModel({
    required this.enroll_id,
    required this.remark_request,
    required this.date_request,
    required this.last_modify,
    required this.enroll_status,
    required this.enroll_status_date,
    required this.can_edit,
    required this.can_delete,
  });

  factory GetEnrollModel.fromJson(Map<String, dynamic> json) {
    return GetEnrollModel(
      enroll_id: json['enroll_id'].toString(),
      remark_request: json['remark_request'] ?? '',
      date_request: json['date_request'] ?? '',
      last_modify: json['last_modify'] ?? '',
      enroll_status: json['enroll_status'] ?? '',
      enroll_status_date: json['enroll_status_date'] ?? '',
      can_edit: json['can_edit'] ?? '',
      can_delete: json['can_delete'] ?? '',
    );
  }
}
