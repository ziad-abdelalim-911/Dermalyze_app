# 🚀 Feature Guide: Update Patient Status Endpoint

This document provides a step-by-step guide to building the "Update Patient Status" feature from scratch. This endpoint allows doctors to change a patient's medical status (e.g., to "Stable", "Improving", or "Critical").

---

## 1. Endpoint Requirements

* **Method:** `PUT`
* **URL:** `/api/patients/:id/status` (or `/api/doctor/patients/:id/status` depending on your routing setup)
* **Description:** Updates the medical status of a specific patient.

### Request Parameters
* **URL Parameter:** `id` -> The **Patient's Database ID** (e.g., `_id` in MongoDB). 
  * *⚠️ Important: Make sure you use the Patient ID here, NOT the Doctor's User ID.*

### Request Body (JSON)
The frontend will send the new status as a string.
```json
{
  "status": "Critical" 
}
```
*(Valid values sent by the app: `"Improving"`, `"Stable"`, `"Critical"`)*

---

## 2. Business Logic Flow

When this endpoint is called, your backend should execute the following steps exactly in this order:

1. **Extract Data:** Get the `id` from `req.params` and the `status` from `req.body`.
2. **Database Update:** Attempt to update the patient document in the database using the provided `id`.
3. **Validation (Crucial Step):** 
   * Check if a document was actually found and modified.
   * If the patient **does not exist**, return a `404 Not Found` error. 
   * *⚠️ Do NOT return a `200 OK` if the update failed or the patient wasn't found.*
4. **Success Response:** If the database update was successful, return a `200 OK` along with the updated patient data.

---

## 3. Reference Implementation (Node.js / Express & MongoDB)

Here is a clean, production-ready example of how this endpoint should be written:

```javascript
app.put('/api/patients/:id/status', async (req, res) => {
    try {
        const patientId = req.params.id;
        const newStatus = req.body.status; 

        // 1. Basic validation
        if (!newStatus) {
            return res.status(400).json({ error: "Status field is required." });
        }

        // 2. Perform the update in the database
        // { new: true } ensures Mongoose returns the document AFTER the update
        const updatedPatient = await Patient.findByIdAndUpdate(
            patientId, 
            { status: newStatus }, 
            { new: true } 
        );

        // 3. Check if the patient was actually found
        if (!updatedPatient) {
            return res.status(404).json({ 
                error: "Patient not found. Please verify the Patient ID." 
            });
        }

        // 4. Return success ONLY if the database was updated
        return res.status(200).json({ 
            message: "Patient status updated successfully", 
            patient: updatedPatient 
        });

    } catch (error) {
        console.error("Error updating status:", error);
        
        // Handle Invalid ID formats (e.g., bad ObjectId in MongoDB)
        if (error.name === 'CastError') {
            return res.status(400).json({ error: "Invalid Patient ID format." });
        }

        // Return generic server error
        return res.status(500).json({ error: "Internal server error." });
    }
});
```

---

## 4. Expected Frontend Behavior After Implementation
Once this logic is implemented:
1. The Flutter frontend will send the `PUT` request when the doctor clicks "Update Status".
2. It expects a `200` status code on success.
3. Upon receiving the `200` response, the Flutter app will automatically fetch the updated patient list, and the patient will immediately move to the "Critical Cases" (or corresponding) section on the Home Screen.
