# Urgent Backend Fix: "Patient not found" (ID Mismatch Error)

## 📌 Context
The Flutter application is encountering a `"Patient not found"` error (404) when the Doctor attempts to perform actions on a patient, specifically on the following endpoints:
- `PUT /api/patients/:id/status` (Update Status)
- `POST /api/patients/:id/appointments` (Schedule Follow-up)
- `POST /api/doctor/patients/:id/review` or `/api/patients/:id/review` (Save Doctor Note / Review)

## 🐛 The Root Cause
The Flutter app stores and sends the **`User ID`** (the `_id` returned from the `User` model upon login or fetched from the doctor's patient list).
However, the Express backend controllers for these routes are currently using `Patient.findById(req.params.id)`. Because the backend is expecting the document `_id` of the **`Patient` model**, but receives the `_id` of the **`User` model**, it fails to find the record and returns null.

## ✅ The Required Solution (For the Backend AI)
To fix this without breaking the current frontend architecture, you need to change how the backend queries the patient. Instead of searching by the Patient's own `_id`, you must search by the `User ID` reference (foreign key) inside the Patient model.

### 🛠️ Code Adjustment Example (Node.js / Express / Mongoose)

**Before (Current Buggy Code):**
```javascript
// Controller for PUT /api/patients/:id/status
const updateStatus = async (req, res) => {
    try {
        // ❌ BUG: req.params.id is a User ID, but findById expects a Patient ID
        const patient = await Patient.findById(req.params.id); 
        
        if (!patient) {
            return res.status(404).json({ message: "Patient not found" });
        }
        
        // ... update logic
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
```

**After (Fixed Code):**
```javascript
// Controller for PUT /api/patients/:id/status
const updateStatus = async (req, res) => {
    try {
        // ✅ FIX: Search using the 'user' or 'userId' reference field in the Patient schema
        const patient = await Patient.findOne({ user: req.params.id }); 
        
        if (!patient) {
            return res.status(404).json({ message: "Patient not found" });
        }
        
        // ... update logic
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
```

### ⚠️ Additional Instruction
Please search your backend codebase for **all controllers** that interact with a specific patient via URL parameters (`req.params.id` or `req.params.patientId`) and apply this `Patient.findOne({ user: ... })` fix to them, especially the **Appointments/Follow-up** and **Medications** controllers.
