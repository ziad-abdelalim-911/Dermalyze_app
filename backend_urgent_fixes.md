# 🚨 Urgent Backend Fixes & Requirements

This document contains 3 critical issues that must be fixed in the backend to ensure the Flutter frontend functions correctly. The frontend code is already prepared and waiting for the correct data structure from the backend.

---

## 1. 🐞 Bug: "Update Status" is Not Saving in Database
**Endpoint:** `PUT /api/patients/:id/status` (or similar)

**The Problem:**
When the doctor updates a patient's status (e.g., to "Critical"), the backend returns `200 OK`, but it **does not actually update the database**. When the app fetches the patient list again, the patient still has their old status and doesn't move to the "Critical" section.
*This is likely because the backend is querying using the Doctor's User ID instead of the Patient ID, or it is using `findOneAndUpdate` without checking if the patient was actually found.*

**Required Fix:**
- Use the `patientId` from the URL parameters to find the patient.
- Ensure the `status` field in the database is actually overwritten.
- **Do not return `200 OK` if the patient is not found or the update fails.** Return `404 Not Found` instead.

**Example Logic:**
```javascript
const updatedPatient = await Patient.findByIdAndUpdate(
    req.params.id, 
    { status: req.body.status }, 
    { new: true } 
);
if (!updatedPatient) {
    return res.status(404).json({ error: "Patient not found" });
}
return res.status(200).json({ message: "Success" });
```

---

## 2. 🗓️ Bug: "Next Visit" is Missing in Patient Home Screen
**Endpoint:** `GET /api/patient/profile` (or wherever patient data is fetched) & `POST /api/doctor/patients/:id/appointments`

**The Problem:**
When the doctor schedules a follow-up appointment, the backend creates the appointment but **forgets to update the patient's profile**. As a result, when the patient logs in, their Home Screen shows `Next Visit: —`.

**Required Fix:**
- **When creating an appointment:** The backend must update a field called `nextAppointment` or `nextVisit` inside the **Patient Document**.
- **When fetching patient profile:** The `GET` request must return this `nextAppointment` field inside the JSON payload. The Flutter app is explicitly looking for `profile['nextAppointment']`.

**Example Logic (in Schedule Appointment API):**
```javascript
// After saving the new appointment:
const patient = await Patient.findById(patientId);
patient.nextAppointment = `${req.body.appointmentDate} at ${req.body.appointmentTime}`;
await patient.save();
```

---

## 3. 🔄 Architecture Fix: Missing Profile & Details Sync
**Endpoints:** `GET /api/doctor/profile` and `GET /api/doctor/patients/:id`

**The Problem:**
- The Doctor's profile screen is missing data (like Phone, Experience, etc.) because the app relies on cached login data. 
- The Patient Details screen lacks nested information because it relies on the general patients list endpoint.

**Required Fix:**
1. **Create/Fix Doctor Profile Endpoint (`GET /api/doctor/profile`):**
   This endpoint MUST return the FULL doctor object, including `phone`, `experience`, `specialization`, `licenseNumber`.
2. **Create/Fix Detailed Patient Endpoint (`GET /api/doctor/patients/:id`):**
   When the doctor opens a specific patient, this endpoint must return everything about that patient (full history, phone number, correct status, current symptoms).
3. **Return Updated Objects on `PUT` / `POST`:**
   Whenever the frontend sends a request to update something (like adding a review, or changing status), the backend should return the newly updated object in the `200 OK` response so the frontend can refresh the UI instantly without making another GET request.
