# 💊 Feature Guide: Prescribe Medication

This document explains the requirements for the "Prescribe Medication" feature. This feature allows a doctor to prescribe new medications to a patient, and for the patient to view their active and completed medications.

To ensure the Flutter app works seamlessly, please implement the following two endpoints:

---

## 1. POST /api/patients/:patientId/medications
**Purpose:** Allows the doctor to add a new medication to the patient's record.

**Request Body (JSON):**
The Flutter app will send the following fields when the doctor fills out the form:
```json
{
  "name": "Panadol Extra",
  "dosage": "500mg",
  "frequency": "Twice a day",
  "notes": "Take after meals" 
}
```
*(Note: `notes` is optional. You might also want to accept or auto-generate `duration`, `instructions`, `startDate`, and `endDate`).*

**Expected Response (201 Created):**
```json
{
  "success": true,
  "message": "Medication added successfully",
  "medication": {
    "id": "64abcdef...",
    "name": "Panadol Extra",
    "dosage": "500mg",
    "frequency": "Twice a day",
    "notes": "Take after meals",
    "status": "active",
    "startDate": "2026-05-25"
  }
}
```

> [!IMPORTANT]
> If you are using Socket.IO, please emit a `profile_updated` event to the patient so the app refreshes their medication list in real-time!

---

## 2. GET /api/patients/:patientId/medications
**Purpose:** Fetches all medications (active and completed) for a specific patient. This is used by both the Doctor's view and the Patient's "My Medications" screen.

**Expected Response (200 OK):**
The Flutter app expects an array of medication objects wrapped in a `medications` key (or a direct array). The keys should ideally match the following so the UI displays them perfectly:

```json
{
  "medications": [
    {
      "_id": "64abcdef...",
      "name": "Panadol Extra",
      "dosage": "500mg",             // or "dose"
      "frequency": "Twice a day",
      "duration": "7 Days",          // Optional
      "instructions": "After meals", // or "whenToTake"
      "notes": "Avoid cold water",   // or "warning"
      "status": "active",            // "active" or "completed"
      "startDate": "2026-05-25",     // or "createdAt"
      "endDate": "2026-06-01"        // Optional
    }
  ]
}
```

> [!TIP]
> The Flutter app automatically checks the `status` field. If `status` is `"completed"` or `"done"`, it moves the medication to the "Completed Medications" section. Otherwise, it stays in "Active Medications".
