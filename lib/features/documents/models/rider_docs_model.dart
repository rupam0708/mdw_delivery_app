import 'file_type_model.dart';

class RiderDocsModel {
  final FileTypeModel? aadharFront;
  final FileTypeModel? aadharBack;
  final FileTypeModel? pan;
  final FileTypeModel? dlFront;
  final FileTypeModel? dlBack;

  final FileTypeModel? rcFront;
  final FileTypeModel? rcBack;

  RiderDocsModel({
    required this.aadharFront,
    required this.aadharBack,
    required this.pan,
    required this.dlFront,
    required this.dlBack,
    required this.rcFront,
    required this.rcBack,
  });

  bool get isComplete =>
      aadharFront != null && aadharBack != null && pan != null;
}
