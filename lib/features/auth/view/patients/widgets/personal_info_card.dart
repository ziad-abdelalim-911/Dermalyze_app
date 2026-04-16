import 'package:dermalyze/features/shared/custom_date_textformfield.dart';
import 'package:flutter/material.dart';
import 'patient_form_field.dart';

class PersonalInfoCard extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController nationalIdController;
  final TextEditingController ageController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const PersonalInfoCard({
    super.key,
    required this.fullNameController,
    required this.nationalIdController,
    required this.ageController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ──
          const Row(
            children: [
              Icon(Icons.person_outline, color: Color(0xFF3AABB0), size: 20),
              SizedBox(width: 8),
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2E3B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Full Name ──
          PatientFormField(
            controller: fullNameController,
            label: 'Full Name',
            hint: 'John Smith',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 14),

          // ── National ID ──
          PatientFormField(
            controller: nationalIdController,
            label: 'National ID',
            hint: '1234567890123',
            prefixIcon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),

          // ── Age + Gender ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Age → CustomDateTextformfield
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Age',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2C4A5A),
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Color(0xFFE05252),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    CustomDateTextformfield(
                      controller: ageController,
                      hint: 'DD/MM/YYYY',
                      validatorText: 'Please select date of birth',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Gender → Dropdown
              Expanded(child: _buildGenderDropdown()),
            ],
          ),
          const SizedBox(height: 14),

          // ── Phone ──
          PatientFormField(
            controller: phoneController,
            label: 'Phone Number',
            hint: '01234567890',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),

          // ── Email ──
          PatientFormField(
            controller: emailController,
            label: 'Email',
            hint: 'patient@example.com',
            required: false,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),

          // ── Address ──
          PatientFormField(
            controller: addressController,
            label: 'Address',
            hint: 'Patient address',
            required: false,
            prefixIcon: Icons.location_on_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Gender',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C4A5A),
              ),
            ),
            SizedBox(width: 3),
            Text(
              '*',
              style: TextStyle(color: Color(0xFFE05252), fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedGender,
          hint: const Text(
            'Select',
            style: TextStyle(fontSize: 14, color: Color(0xFF8A9BAB)),
          ),
          items: ['Male', 'Female']
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: onGenderChanged,
          validator: (val) => val == null ? 'Required' : null,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E3B)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFCFE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFFD8E4EC), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFFD8E4EC), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF3A8FA8), width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFFE05252), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}