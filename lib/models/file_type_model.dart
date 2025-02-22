import 'dart:convert';

enum FileTypeEnum { image, pdf, unknown }

class FileTypeModel {
  final String path;
  final FileTypeEnum type;

  // Constructor initializes both path and type
  FileTypeModel({required this.path}) : type = _getFileType(path);

  // This method determines the file type based on the file extension
  static FileTypeEnum _getFileType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(ext)) {
      return FileTypeEnum.image;
    } else if (ext == 'pdf') {
      return FileTypeEnum.pdf;
    } else {
      return FileTypeEnum.unknown;
    }
  }

  // Convert FileTypeModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': type.toString().split('.').last, // Convert enum to string
    };
  }

  // Convert FileTypeModel to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Convert JSON map to FileTypeModel
  static FileTypeModel fromJson(Map<String, dynamic> json) {
    final path = json['path'];
    // final typeString = json['type'];

    // Convert the type string back to the enum
    // final type = FileTypeEnum.values.firstWhere(
    //     (e) => e.toString().split('.').last == typeString,
    //     orElse: () => FileTypeEnum.unknown);

    return FileTypeModel(
        path: path); // Create the object and automatically set the type
  }

  // Custom string representation of the object
  @override
  String toString() {
    return 'FileTypeModel(path: $path, type: $type)';
  }
}
