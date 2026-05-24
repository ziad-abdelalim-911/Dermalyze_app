import 'dart:io';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:dermalyze/features/auth/view/patients/data/analysis_repository.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/ai_analysis_progress_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/ready_for_analysis_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/uploaded_image_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum UploadState { initial, uploaded, analyzing }

class UploadAnalyzeScreen extends StatefulWidget {
  final String patientId;
  final String? patientName;
  final String? diagnosis;

  const UploadAnalyzeScreen({
    super.key,
    required this.patientId,
    this.patientName,
    this.diagnosis,
  });

  @override
  State<UploadAnalyzeScreen> createState() => _UploadAnalyzeScreenState();
}

class _UploadAnalyzeScreenState extends State<UploadAnalyzeScreen> {
  UploadState _state = UploadState.initial;
  File? _imageFile;
  String? _errorMessage;
  final _picker = ImagePicker();
  final _repository = AnalysisRepository();
  List<dynamic> _previousAnalyses = [];
  bool _isLoadingAnalyses = false;

  @override
  void initState() {
    super.initState();
    _loadPreviousAnalyses();
  }

  Future<void> _loadPreviousAnalyses() async {
    setState(() => _isLoadingAnalyses = true);
    try {
      final list = await _repository.getPatientAnalyses(widget.patientId);
      setState(() {
        _previousAnalyses = list;
        _isLoadingAnalyses = false;
      });
    } catch (_) {
      setState(() => _isLoadingAnalyses = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Header ──
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient2,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Upload & Analyze',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'AI-Powered Skin Analysis',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Content ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 30),
                    child: _state == UploadState.initial
                        ? _buildInitialContent()
                        : _buildUploadedContent(),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Button ──
          if (_state == UploadState.uploaded) _buildAnalyzeButton(),
        ],
      ),
    );
  }

  // ── State: Initial ──
  Widget _buildInitialContent() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
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
              Text(
                'Choose Upload Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.dynamicTextColorPrimary,
                ),
              ),
              const SizedBox(height: 16),
              // Take Photo
              GestureDetector(
                onTap: () => _pickImage(ImageSource.camera),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.Turqouoise, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.Turqouoise,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Theme.of(context).cardColor,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Take Photo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.dynamicTextColorPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Use device camera',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.dynamicTextColorSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Upload Image
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFB57BEE),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9B40E0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.upload_outlined,
                          color: Theme.of(context).cardColor,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.dynamicTextColorPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'From device gallery',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.dynamicTextColorSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Guidelines
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.isDarkMode
                  ? Colors.white24
                  : const Color(0xFFBFDBFE),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.SkyBlue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Image Guidelines',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.dynamicTextColorPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildGuidelineItem('Ensure good lighting conditions'),
              _buildGuidelineItem('Keep the affected area in focus'),
              _buildGuidelineItem('Use a plain background if possible'),
              _buildGuidelineItem(
                'Maintain consistent distance from previous scans',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── State: Uploaded / Analyzing ──
  Widget _buildUploadedContent() {
    return Column(
      children: [
        UploadedImageCard(
          imageFile: _imageFile,
          onReupload: () => setState(() {
            _state = UploadState.initial;
            _imageFile = null;
          }),
        ),
        const SizedBox(height: 16),
        ReadyForAnalysisCard(
          patientName: widget.patientName ?? 'Patient',
          diagnosis: widget.diagnosis ?? 'Pending',
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade700, fontSize: 13),
            ),
          ),
        ],
        if (_state == UploadState.analyzing) ...[
          const SizedBox(height: 16),
          const AiAnalysisProgressCard(),
        ],
      ],
    );
  }

  // ── Analyze Button ──
  Widget _buildAnalyzeButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      color: context.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF0F4F8),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient2,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton.icon(
            onPressed: () => _runAnalysis(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Analyze with AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
          _state = UploadState.uploaded;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  Future<void> _runAnalysis() async {
    if (_imageFile == null) return;
    setState(() {
      _state = UploadState.analyzing;
      _errorMessage = null;
    });
    try {
      final result = await _repository.analyzeImage(
        patientId: widget.patientId,
        imageFile: _imageFile!,
        onProgress: (sent, total) {}, // progress tracked internally
      );
      
      final previousScan = _previousAnalyses.isNotEmpty ? _previousAnalyses.first : null;
      
      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.aiAnalysisResult,
          arguments: {
            ...result,
            'currentImageFile': _imageFile,
            'previousScan': previousScan,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = UploadState.uploaded;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Widget _buildGuidelineItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.Turqouoise,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: context.dynamicTextColorSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
