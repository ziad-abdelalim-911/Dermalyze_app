# 🗓️ Feature Fix: Missing "Next Visit" in Patient Profile

## 📌 Issue Overview
When the Patient logs into the app and views their Home Screen, the **"Next Visit"** section displays as empty (`—`). 

The Flutter frontend is already programmed to display the date and time of the next appointment, but it is currently receiving `null` or missing data from the backend when fetching the patient's profile.

---

## 🛠️ Root Cause
When the Doctor schedules a follow-up appointment for a patient using the `POST /api/doctor/patients/:id/appointments` endpoint, the backend creates the appointment successfully. However, the backend **does not update the patient's main document** with this new date. 

Because of this, when the Patient calls `GET /api/patient/profile` (or the equivalent endpoint to load their home screen data), the `nextAppointment` field is missing.

---

## ✅ Required Action for Backend Developer

To fix this, you need to link the Appointment scheduling with the Patient's profile data:

1. **Update the Patient Document on Scheduling:**
   When you successfully create a new appointment in the `POST` endpoint, make sure to update a field called `nextAppointment` (or `nextVisit`) inside the **Patient Document**.
   
2. **Return the Field in the Profile Response:**
   Ensure that the endpoint responsible for fetching the patient's profile (`GET /api/patient/profile`) returns this field inside the JSON object. 

**What the Flutter app expects to receive:**
```json
{
  "profile": {
    "name": "Ziad",
    "diagnosis": "Eczema",
    "nextAppointment": "2026-06-15 at 10:30 AM" // <-- This is the missing field
  }
}
```

### 💻 Example Logic (Node.js/Express)
Inside your `POST /appointments` controller, after saving the appointment, run an update on the patient:

```javascript
// 1. Save the new appointment
const newAppointment = new Appointment({ /* data */ });
await newAppointment.save();

// 2. IMPORTANT: Update the patient's document so the app can display it
await Patient.findByIdAndUpdate(patientId, {
    nextAppointment: `${req.body.appointmentDate} at ${req.body.appointmentTime}`
});
```

Once this field is returned by the backend, the Flutter app will automatically read it and display it on the patient's Home Screen without any frontend changes!
