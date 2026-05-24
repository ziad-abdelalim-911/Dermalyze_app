# 🛠️ Architecture & Data Sync Issue: Missing Data in Profile and Patient Details

## 📌 Overview of the Problem
The Flutter frontend is currently experiencing issues where data "does not reflect" (مش بيسمع) or appears blank in two critical areas of the application:
1. **Doctor Profile Screen:** Fields like Phone, Experience, and sometimes Specialization appear blank (`—`).
2. **Patient Details Screen:** Some patient information (like phone number, symptoms, or updated status) does not appear correctly or does not update after being changed.

---

## 🔍 Root Causes & Professional Solutions

### 1. Doctor Profile Issue
**The Cause:**
Currently, the Flutter app reads the doctor's profile data from a local cache (`TokenStorage`) that was saved during Login or Signup. If the backend does not include all profile fields (Phone, Experience, etc.) in the Login response, or if the doctor updates their profile from another device, the app has no way to know because it never fetches fresh data.

**The Professional Solution (Backend Action):**
* **Create a Dedicated Profile Endpoint:** 
  Implement `GET /api/doctor/profile` (or `GET /api/users/me`).
  This endpoint must return the **full, up-to-date** doctor object from the database (Name, Email, Phone, Specialization, License Number, Experience, etc.).
* **Update Login/Signup Responses:**
  Ensure that when a doctor logs in or signs up, the backend returns the complete user object inside the JSON response, not just the token and name.

### 2. Patient Details Sync Issue
**The Cause:**
When navigating to the Patient Details screen, the app displays what it received from the general `GET /api/doctor/patients` list. If the backend's list endpoint does not populate all nested fields (like phone, current symptoms, full medical history), or if data was recently updated (like Status), the app shows old or missing data.

**The Professional Solution (Backend Action):**
* **Implement a Specific Patient Endpoint:** 
  Create `GET /api/doctor/patients/:id`.
  This endpoint should retrieve the **detailed view** of a single patient, including all arrays and populated references (e.g., full history, phone number, notes, accurate status).
* **Return Updated Objects on `PUT` requests:**
  As mentioned in previous reports, whenever a `PUT` or `POST` request is made to update a patient's status or add an appointment, the backend must return the **newly updated patient object** in the response. This allows the frontend to immediately update the UI without making another `GET` request.

---

## 💻 Example of the Expected Workflow (Best Practice)

**For Doctor Profile:**
```json
// GET /api/doctor/profile
// Response: 200 OK
{
  "doctor": {
    "id": "60d5ecb8b392...",
    "name": "Dr. Ziad",
    "email": "ziadabdo596@gmail.com",
    "phone": "+201000000000",
    "specialization": "Dermatology",
    "licenseNumber": "DOC-4YHSCO",
    "experience": "5 Years"
  }
}
```

**For Patient Details:**
```json
// GET /api/doctor/patients/60d5ecb8b...
// Response: 200 OK
{
  "patient": {
    "id": "...",
    "name": "Ziad A7a",
    "diagnosis": "Eczema",
    "status": "Critical", // MUST BE ACCURATE
    "phone": "01000000000",
    "currentSymptoms": "Severe itching",
    "lastVisit": "2026-05-20T10:00:00Z",
    "recoveryProgress": 20
  }
}
```

By providing these dedicated endpoints and ensuring payloads are complete, the frontend will always display real-time, synchronized data without forcing the user to log out and log back in.
