import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/services/app_function_services.dart';
import '../../documents/models/rider_docs_model.dart';

class RegistrationController extends ChangeNotifier {
  int currentStep = 0;
  List<int> completedSteps = [];
  List<int> startedSteps = [];
  bool stepperFinished = false;
  bool loading = false;

  bool obscure = true;
  bool confirmObscure = true;
  bool agree = false;
  bool docRes = false;
  int changed = 0;

  String? previousPhone;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final vNumberController = TextEditingController();
  final idProofUrlController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  String selectedIdProofType = 'Aadhaar'; // default

  final List<String> idProofTypes = ['Aadhaar', 'PAN'];

  void selectIdProofType(String type) {
    selectedIdProofType = type;
    notifyListeners();
  }

  String selectedShirtSize = 'M'; // Default size
  final List<String> shirtSizes = ['S', 'M', 'L', 'XL', 'XXL'];

  void selectShirtSize(String size) {
    selectedShirtSize = size;
    notifyListeners();
  }

  String selectedVehicleType = 'Petrol Motorcycle';

  final List<String> vehicleTypes = [
    'Petrol Motorcycle',
    'Bicycle',
    'Electric Scooty',
  ];

  void selectVehicleType(String vehicleType) {
    selectedVehicleType = vehicleType;
    notifyListeners();
  }

  String selectedJobType = 'Full-time';
  final List<String> jobTypes = ['Full-time', 'Part-time'];

  void selectJobType(String jobType) {
    selectedJobType = jobType;
    notifyListeners();
  }

  String selectedCity = 'Kolkata';
  String selectedStore = 'NewTown';

  final List<String> cityList = [
    'Kolkata',
    "Bangalore",
    "New Delhi",
    "Mumbai",
  ];
  final List<String> storeList = [
    'NewTown',
    "Dharmatala",
    "Salt Lake",
    "College Street",
  ];

// Add methods
  void selectCity(String city) {
    selectedCity = city;
    notifyListeners();
  }

//
  void selectStore(String store) {
    selectedStore = store;
    notifyListeners();
  }

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  void toggleConfirmObscure() {
    confirmObscure = !confirmObscure;
    notifyListeners();
  }

  void toggleAgree(bool? val) {
    agree = val ?? false;
    notifyListeners();
  }

  void updateChangedCount() {
    changed++;
    notifyListeners();
  }

  void startCurrentStep() {
    if (!startedSteps.contains(currentStep)) {
      startedSteps.add(currentStep);
      notifyListeners();
    }
  }

  void nextStep() {
    if (!startedSteps.contains(currentStep)) {
      startedSteps.add(currentStep);
    }

    if (!completedSteps.contains(currentStep)) {
      completedSteps.add(currentStep);
    }

    if (currentStep == 4) {
      stepperFinished = true;
    }

    currentStep++;
    notifyListeners();
  }

  void backStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void setStep(int step) {
    currentStep = step;
    notifyListeners();
  }

  void markCompleted(int step) {
    if (!completedSteps.contains(step)) {
      completedSteps.add(step);
      notifyListeners();
    }
  }

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setDocRes(bool val) {
    docRes = val;
    notifyListeners();
  }

  void setStepperFinished(bool val) {
    stepperFinished = val;
    notifyListeners();
  }

  Future<RiderDocsModel> fetchDocs(String phone) async {
    final docs = await AppFunctions.getDocs(phone);
    docRes = docs.aadharFront != null &&
        docs.aadharBack != null &&
        docs.pan != null &&
        docs.dlFront != null &&
        docs.dlBack != null &&
        docs.rcFront != null &&
        docs.rcBack != null;
    log(docRes.toString());
    notifyListeners();
    return docs;
  }

  void disposeAll() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    vNumberController.dispose();
    idProofUrlController.dispose();
    passController.dispose();
    confirmPassController.dispose();
  }
}
