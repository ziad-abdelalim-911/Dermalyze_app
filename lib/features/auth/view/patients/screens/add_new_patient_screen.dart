import 'package:flutter/material.dart';
import '../data/add_patient_repository.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/medical_info_card.dart';
import '../widgets/next_steps_card.dart';

class AddNewPatientScreen extends StatefulWidget {
  const AddNewPatientScreen({super.key});

  @override
  State<AddNewPatientScreen> createState() => _AddNewPatientScreenState();
}

class _AddNewPatientScreenState extends State<AddNewPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false;
  final AddPatientRepository _repository = AddPatientRepository();

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalIdController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _diagnosisController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    PersonalInfoCard(
                      fullNameController: _fullNameController,
                      nationalIdController: _nationalIdController,
                      ageController: _ageController,
                      phoneController: _phoneController,
                      emailController: _emailController,
                      addressController: _addressController,
                      selectedGender: _selectedGender,
                      onGenderChanged: (val) =>
                          setState(() => _selectedGender = val),
                    ),
                    const SizedBox(height: 16),
                    MedicalInfoCard(
                      diagnosisController: _diagnosisController,
                      medicalHistoryController: _medicalHistoryController,
                    ),
                    const SizedBox(height: 16),
                    const NextStepsCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4A90E2), Color(0xff4ECDC4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Back to Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person_add_alt_1,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Add New Patient',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create a new patient file',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5BAED0), Color(0xFF3A8FA8)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3A8FA8).withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).cardColor,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.person_add_alt_1,
                    color: Colors.white,
                    size: 20,
                  ),
            label: Text(
              _isLoading ? 'Adding...' : 'Add Patient to System',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    // Calculate Age from DD/MM/YYYY
    int calculatedAge = 0;
    try {
      final parts = _ageController.text.trim().split('/');
      if (parts.length == 3) {
        final birthYear = int.parse(parts[2]);
        calculatedAge = DateTime.now().year - birthYear;
      }
    } catch (_) {}

    try {
      await _repository.addPatient(
        name: _fullNameController.text.trim(),
        age: calculatedAge,
        gender: _selectedGender ?? 'male',
        diagnosis: _diagnosisController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient added successfully!'),
            backgroundColor: Color(0xFF3A8FA8),
          ),
        );
        Navigator.pop(context, true); // true = refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
