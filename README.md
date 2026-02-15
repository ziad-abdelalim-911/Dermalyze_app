# dermalyze

Dermalyze app

## MY File Structure

lib/
core/
constants/
api_endpoints.dart
app_colors.dart
app_string.dart
network/
api_service.dart
api_exception.dart
utils/
helpers.dart
validators.dart

features/
food/

data/
food_model.dart
food_details.drat

widgets/

cart/
view/
widgets/
root.dart
main.dart

lib/
├── main.dart
├── app.dart
│
├── core/
│ ├── constants/
│ │ ├── colors.dart # ألوان التطبيق
│ │ ├── strings.dart # النصوص الثابتة
│ │ ├── assets.dart # مسارات الصور
│ │
│ ├── theme/
│ │ ├── app_theme.dart # ThemeData
│ │ └── text_styles.dart # TextStyle
│ │
│ ├── widgets/
│ │ ├── custom_button.dart
│ │ ├── custom_text_field.dart
│ │ ├── loading_widget.dart
│ │ └── empty_state_widget.dart
│ │
│ └── helpers/
│ ├── navigation_helper.dart
│ ├── dialog_helper.dart
│ └── validator_helper.dart
│
├── auth/
│ ├── views/
│ │ ├── login_view.dart
│ │ ├── register_view.dart
│ │ └── forget_password_view.dart
│ │
│ ├── controllers/
│ │ └── auth_controller.dart
│ │
│ ├── models/
│ │ └── user_model.dart
│ │
│ └── services/
│ └── auth_service.dart
│
├── patient/
│ ├── views/
│ │ ├── patient_dashboard_view.dart
│ │ ├── profile_view.dart
│ │ └── edit_profile_view.dart
│ │
│ ├── controllers/
│ │ └── patient_controller.dart
│ │
│ ├── models/
│ │ └── patient_model.dart
│ │
│ └── services/
│ └── patient_service.dart
│
├── image_analysis/
│ ├── views/
│ │ ├── upload_image_view.dart
│ │ ├── progress_report_view.dart
│ │ └── image_history_view.dart
│ │
│ ├── controllers/
│ │ └── image_controller.dart
│ │
│ ├── models/
│ │ ├── medical_image_model.dart
│ │ └── progress_report_model.dart
│ │
│ └── services/
│ └── image_service.dart
│
├── chat/
│ ├── views/
│ │ ├── chat_view.dart
│ │ └── chat_list_view.dart
│ │
│ ├── controllers/
│ │ └── chat_controller.dart
│ │
│ ├── models/
│ │ └── chat_message_model.dart
│ │
│ └── services/
│ └── chat_service.dart
│
└── doctor/
├── views/
│ ├── doctor_dashboard_view.dart
│ ├── patient_details_view.dart
│ └── critical_patients_view.dart
│
├── controllers/
│ └── doctor_controller.dart
│
├── models/
│ └── doctor_model.dart
│
└── services/
└── doctor_service.dart