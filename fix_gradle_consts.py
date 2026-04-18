import re

error_log = """
lib/core/theme/app_theme.dart:13:35: Error: Undefined name 'context'.
lib/core/theme/app_theme.dart:13:32: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:195:62: Error: Not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:195:59: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:255:65: Error: Not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:255:62: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:415:76: Error: Not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:415:73: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:445:70: Error: Not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:445:67: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:551:50: Error: Not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:551:47: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:640:61: Error: Not a constant expression.
lib/features/auth/view/home/doctor/screens/smart_history_screen.dart:640:58: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/doctor/screens/diseases_library_screen.dart:231:109: Error: Not a constant expression.
lib/features/auth/view/home/doctor/screens/diseases_library_screen.dart:231:106: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/doctor/screens/diseases_library_screen.dart:346:49: Error: Not a constant expression.
lib/features/auth/view/home/doctor/screens/diseases_library_screen.dart:346:46: Error: Method invocation is not a constant expression.
lib/features/settings/view/settings_screen.dart:671:54: Error: Not a constant expression.
lib/features/settings/view/settings_screen.dart:671:51: Error: Method invocation is not a constant expression.
lib/features/auth/view/login/Patient_SignUp.dart:137:82: Error: Not a constant expression.
lib/features/auth/view/login/Patient_SignUp.dart:137:79: Error: Method invocation is not a constant expression.
lib/features/auth/view/login/doctor_SignUp.dart:125:51: Error: Not a constant expression.
lib/features/auth/view/login/doctor_SignUp.dart:125:48: Error: Method invocation is not a constant expression.
lib/features/auth/view/login/doctor_SignUp.dart:326:59: Error: Not a constant expression.
lib/features/auth/view/login/doctor_SignUp.dart:326:56: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/screens/add_new_patient_screen.dart:206:39: Error: Not a constant expression.
lib/features/auth/view/patients/screens/add_new_patient_screen.dart:206:36: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/screens/ai_analysis_result_screen.dart:126:45: Error: Not a constant expression.
lib/features/auth/view/patients/screens/ai_analysis_result_screen.dart:126:42: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/screens/ai_analysis_result_screen.dart:265:41: Error: Not a constant expression.
lib/features/auth/view/patients/screens/ai_analysis_result_screen.dart:265:38: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/screens/ai_analysis_result_screen.dart:382:41: Error: Not a constant expression.
lib/features/auth/view/patients/screens/ai_analysis_result_screen.dart:382:38: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/screens/upload_analyze_screen.dart:64:43: Error: Not a constant expression. 
lib/features/auth/view/patients/screens/upload_analyze_screen.dart:64:40: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/screens/upload_analyze_screen.dart:172:43: Error: Not a constant expression.
lib/features/auth/view/patients/screens/upload_analyze_screen.dart:172:40: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/screens/upload_analyze_screen.dart:220:43: Error: Not a constant expression.
lib/features/auth/view/patients/screens/upload_analyze_screen.dart:220:40: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/screens/upload_analyze_screen.dart:349:31: Error: Not a constant expression.
lib/features/auth/view/patients/screens/upload_analyze_screen.dart:349:28: Error: Method invocation is not a constant expression.
lib/features/auth/view/login/login_view.dart:122:47: Error: Not a constant expression.
lib/features/auth/view/login/login_view.dart:122:44: Error: Method invocation is not a constant expression. 
lib/features/auth/view/forgot_password/forgot_password_view.dart:73:43: Error: Not a constant expression.   
lib/features/auth/view/forgot_password/forgot_password_view.dart:73:40: Error: Method invocation is not a constant expression.
lib/features/auth/view/forgot_password/forgot_password_view.dart:269:55: Error: Not a constant expression.  
lib/features/auth/view/forgot_password/forgot_password_view.dart:269:52: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/doctor/widgets/critical_patient_card.dart:154:47: Error: Not a constant expression.
lib/features/auth/view/home/doctor/widgets/critical_patient_card.dart:154:44: Error: Method invocation is not a constant expression.
lib/features/auth/view/profile_sceern/profile_view.dart:100:53: Error: Not a constant expression.
lib/features/auth/view/profile_sceern/profile_view.dart:100:50: Error: Method invocation is not a constant expression.
lib/features/auth/view/profile_sceern/profile_view.dart:371:51: Error: Not a constant expression.
lib/features/auth/view/profile_sceern/profile_view.dart:371:48: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/widgets/image_comparison_card.dart:82:55: Error: Not a constant expression. 
lib/features/auth/view/patients/widgets/image_comparison_card.dart:82:52: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/widgets/image_comparison_card.dart:142:55: Error: Not a constant expression.
lib/features/auth/view/patients/widgets/image_comparison_card.dart:142:52: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/widgets/slider_comparison_card.dart:110:51: Error: Not a constant expression.
lib/features/auth/view/patients/widgets/slider_comparison_card.dart:110:48: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/widgets/slider_comparison_card.dart:127:51: Error: Not a constant expression.
lib/features/auth/view/patients/widgets/slider_comparison_card.dart:127:48: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/widgets/slider_comparison_card.dart:156:49: Error: Not a constant expression.
lib/features/auth/view/patients/widgets/slider_comparison_card.dart:156:46: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/widgets/prescribed_medications_card.dart:77:63: Error: Not a constant expression.
lib/features/auth/view/patients/widgets/prescribed_medications_card.dart:77:60: Error: Method invocation is not a constant expression.
lib/features/auth/view/patients/widgets/ready_for_analysis_card.dart:80:41: Error: Not a constant expression.
lib/features/auth/view/patients/widgets/ready_for_analysis_card.dart:80:38: Error: Method invocation is not a constant expression.
lib/features/auth/view/forgot_password/verify_code_view.dart:96:43: Error: Not a constant expression.       
lib/features/auth/view/forgot_password/verify_code_view.dart:96:40: Error: Method invocation is not a constant expression.
lib/features/auth/view/forgot_password/verify_code_view.dart:276:55: Error: Not a constant expression.      
lib/features/auth/view/forgot_password/verify_code_view.dart:276:52: Error: Method invocation is not a constant expression.
lib/features/auth/view/ProgressReport_view/progress_header_card.dart:54:37: Error: Not a constant expression.
lib/features/auth/view/ProgressReport_view/progress_header_card.dart:54:34: Error: Method invocation is not a constant expression.
lib/features/auth/view/chat/view/chat_view.dart:142:65: Error: Not a constant expression.
lib/features/auth/view/chat/view/chat_view.dart:142:62: Error: Method invocation is not a constant expression.
lib/features/auth/view/chat/view/chat_view.dart:353:61: Error: Not a constant expression.
lib/features/auth/view/chat/view/chat_view.dart:353:58: Error: Method invocation is not a constant expression.
lib/features/auth/view/home/home_header.dart:53:41: Error: Not a constant expression.
lib/features/auth/view/home/home_header.dart:53:38: Error: Method invocation is not a constant expression.  
lib/features/auth/view/forgot_password/create_new_password_view.dart:118:43: Error: Not a constant expression.
lib/features/auth/view/forgot_password/create_new_password_view.dart:118:40: Error: Method invocation is not a constant expression.
lib/features/auth/view/forgot_password/create_new_password_view.dart:272:55: Error: Not a constant expression.
lib/features/auth/view/forgot_password/create_new_password_view.dart:272:52: Error: Method invocation is not a constant expression.
lib/features/settings/view/privacy_settings_view.dart:286:79: Error: Not a constant expression.
lib/features/settings/view/privacy_settings_view.dart:286:76: Error: Method invocation is not a constant expression.
"""

files_lines = {}
for line in error_log.splitlines():
    if "Error:" in line:
        parts = line.split(":")
        if len(parts) >= 3:
            file = parts[0].strip()
            # In cases like d:/..., there's a drive letter, so it might consume extra parts.
            # but here it's relative paths starting with lib/
            if file.startswith("lib"):
                try:
                    line_num = int(parts[1])
                    if file not in files_lines:
                        files_lines[file] = []
                    files_lines[file].append(line_num)
                except:
                    pass

import os
# Deduplicate lines
for f in files_lines:
    files_lines[f] = list(set(files_lines[f]))

    path = os.path.join("d:\\android studio projects\\dermalyze", f.replace("/", "\\"))
    if not os.path.exists(path):
        continue
    
    with open(path, 'r', encoding='utf-8') as file:
        content = file.readlines()
        
    for line_num in files_lines[f]:
        idx = line_num - 1
        # Search backwards a few lines for 'const' and remove it
        # Actually it's often better to just wipe 'const' on that line if it exists.
        # But for 'const Text', 'const Icon', the 'const' might be on the same line or above it.
        for i in range(idx, max(-1, idx-10), -1):
            if 'const ' in content[i]:
                content[i] = re.sub(r'\bconst\s+', '', content[i])
                break
                
    with open(path, 'w', encoding='utf-8') as file:
        file.writelines(content)
        
print("Const fixes applied to", len(files_lines), "files.")
