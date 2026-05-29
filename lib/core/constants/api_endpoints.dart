/// All API endpoints for Dermalyze backend
/// Base URL: https://dermalyze-backend-final-main-production.up.railway.app/api/
class ApiEndpoints {
  ApiEndpoints._();

  // ─── Auth ──────────────────────────────────────────────
  /// POST  { name, email, password, role, doctorCode? }
  static const String register = 'auth/register';

  /// POST  { email, password }  → { token, user }
  static const String login = 'auth/login';

  /// POST  { idToken }
  static const String verifyIdentity = 'auth/verify-identity';

  /// GET   /me  → returns logged in user profile
  static const String me = 'me';

  // ─── Doctor ────────────────────────────────────────────
  /// POST  { doctorCode }  — ربط مريض بطبيب
  static const String linkDoctor = 'link-doctor';

  /// GET   → list of patients linked to the logged-in doctor
  static const String doctorPatients = 'doctor/patients';

  /// GET   /doctor/patient/{id}/analyses
  static String doctorPatientAnalyses(String patientId) =>
      'doctor/patient/$patientId/analyses';

  /// GET   → doctor dashboard stats
  static const String doctorStats = 'doctor/stats';

  // ─── Analysis ──────────────────────────────────────────
  /// POST  /analysis/{patientId}  multipart/form-data (image)
  static String uploadAnalysis(String patientId) => 'analysis/$patientId';

  /// GET   /patient/{patientId}/analyses
  static String patientAnalyses(String patientId) =>
      'patient/$patientId/analyses';

  // ─── Clinical Resources ────────────────────────────────
  /// GET   /resources/medications?search=...
  static const String medications = 'resources/medications';

  /// GET   /medicines/all?page=1&limit=20
  static const String medicinesAll = 'medicines/all';

  /// GET   /medicines/search?q=...
  static const String medicinesSearch = 'medicines/search';

  /// GET   /resources/diseases?search=...
  static const String diseases = 'resources/diseases';

  // ─── Chat ──────────────────────────────────────────────
  /// GET   → list of conversations for the current user
  static const String conversations = 'chat/conversations';

  /// GET   /chat/messages/{receiverId}?page=1&limit=50
  static String chatMessages(String receiverId) =>
      'chat/messages/$receiverId?page=1&limit=50';

  /// POST  { receiverId, content }
  static const String sendMessage = 'chat/send';

  /// DELETE /chat/messages/{messageId}
  static String deleteMessage(String messageId) =>
      'chat/messages/$messageId';

  /// DELETE /chat/conversations/{receiverId}
  static String deleteConversation(String receiverId) =>
      'chat/conversations/$receiverId';

  // ─── Patients (Doctor actions) ─────────────────────────
  /// POST  — add a new patient (doctor only)
  static const String addPatient = 'patients';

  /// GET   /patients/{id}
  static String patientById(String id) => 'patients/$id';

  /// PUT   /patients/{id}/status  { status }
  static String updatePatientStatus(String id) => 'patients/$id/status';

  /// GET   /patient/{patientId}/medications
  static String patientMedications(String patientId) =>
      'patient/$patientId/medications';

  // ─── User Account ──────────────────────────────────────
  /// PUT   { emailEnabled, pushEnabled }
  static const String notificationPreferences =
      'user/notification-preferences';

  /// POST  — enable 2FA → returns { secret, qrCode }
  static const String enable2FA = 'user/2fa/enable';

  /// POST  { token }  — verify 2FA code
  static const String verify2FA = 'user/2fa/verify';

  /// POST  — disable 2FA
  static const String disable2FA = 'user/2fa/disable';

  /// DELETE — permanently delete the user account
  static const String deleteAccount = 'user/account';
}
