# 📅 Feature Guide: Schedule Follow-up Appointment

This document explains the requirements for the "Schedule Follow-up" backend endpoint. This feature allows a doctor to set a future appointment for a specific patient.

---

## 1. Endpoint Requirements

* **Method:** `POST`
* **URL:** `/api/doctor/patients/:patientId/appointments` (or `/api/patients/:patientId/appointments` depending on your routing setup)
* **Description:** Creates a new follow-up appointment for the specified patient.

### Request Parameters
* **URL Parameter:** `patientId` -> The **Patient's Database ID** (e.g., `_id` in MongoDB). 
  * *⚠️ Ensure this is the unique identifier for the Patient document, NOT the Doctor's User ID.*

### Request Body (JSON)
The Flutter app will send the following data in the request body:
```json
{
  "patientName": "Ziad A7a",
  "diagnosis": "Eczema",
  "appointmentDate": "2026-06-15",
  "appointmentTime": "10:30 AM"
}
```

---

## 2. Business Logic Flow

When the frontend hits this endpoint, the backend must execute the following steps:

1. **Verify Patient Existence:** Look up the patient using the `patientId` from the URL parameters to ensure they exist.
2. **Data Validation:** Validate that `appointmentDate` and `appointmentTime` are provided and are in a valid format.
3. **Database Insertion:** 
   * Create a new `Appointment` document linking the `patientId` and the Doctor ID (from the authenticated token).
   * *Alternatively*, if your schema embeds appointments, push this new appointment into an `appointments` array inside the Patient document.
4. **Update `nextAppointment` field (Optional but Recommended):** Update the `nextAppointment` field in the `Patient` document so it can be quickly displayed on the Patient List card.
5. **Success Response:** Return a `201 Created` or `200 OK` status with the newly created appointment data.

---

## 3. Reference Implementation (Node.js / Express & MongoDB)

Here is a robust example assuming you have an `Appointment` model:

```javascript
app.post('/api/doctor/patients/:patientId/appointments', async (req, res) => {
    try {
        const { patientId } = req.params;
        const { patientName, diagnosis, appointmentDate, appointmentTime } = req.body;
        
        // Ensure the doctor is authenticated (assume req.user contains the doctor's data)
        const doctorId = req.user._id;

        // 1. Basic validation
        if (!appointmentDate || !appointmentTime) {
            return res.status(400).json({ error: "Appointment date and time are required." });
        }

        // 2. Check if the patient exists
        const patient = await Patient.findById(patientId);
        if (!patient) {
            return res.status(404).json({ error: "Patient not found." });
        }

        // 3. Create the new appointment
        const newAppointment = new Appointment({
            doctor: doctorId,
            patient: patientId,
            patientName: patientName || patient.name,
            diagnosis: diagnosis || patient.diagnosis,
            date: appointmentDate,
            time: appointmentTime,
            status: "Scheduled"
        });

        await newAppointment.save();

        // 4. (Optional) Update the patient's next appointment date for quick access
        patient.nextAppointment = `${appointmentDate} at ${appointmentTime}`;
        await patient.save();

        // 5. Return success
        return res.status(201).json({
            message: "Follow-up appointment scheduled successfully.",
            appointment: newAppointment
        });

    } catch (error) {
        console.error("Error scheduling appointment:", error);
        
        if (error.name === 'CastError') {
            return res.status(400).json({ error: "Invalid Patient ID format." });
        }
        
        return res.status(500).json({ error: "Internal server error." });
    }
});
```

---

## 4. Expected Frontend Behavior
1. When the doctor clicks "Schedule Follow-up" and submits the date and time, the Flutter app sends this `POST` request.
2. If the backend returns `200` or `201`, the app shows a green success snackbar (`Appointment scheduled successfully`).
3. If the backend returns an error (like `404 Patient not found`), the app displays a red error snackbar to the doctor.
