# 🚀 Dermalyze Backend - Urgent Fixes & Tasks Guide

This document is a consolidated list of the required backend fixes to ensure the Flutter application works perfectly. Please implement these changes in your Express/Node.js backend.

---

## 1. 🐛 Urgent Bug: "Patient not found" (ID Mismatch)
**The Problem:**
When the Doctor attempts to update a patient's status via `PUT /api/patients/:id/status` (or schedule a follow-up), the backend returns a `404 Patient not found` error.
This happens because the Flutter app sends the **`User ID`** (the `_id` of the User document) as the parameter, but your backend controller expects the **`Patient ID`** (the `_id` of the Patient document) and uses `Patient.findById(req.params.id)`.

**The Fix:**
Update your controllers to search the `Patient` collection using the `user` reference field instead of the document's own `_id`.

```javascript
// Example Fix for: PUT /api/patients/:id/status
const updateStatus = async (req, res) => {
    try {
        // ✅ FIX: Use findOne with the user reference field
        const patient = await Patient.findOne({ user: req.params.id }); 
        
        if (!patient) return res.status(404).json({ message: "Patient not found" });
        
        // ... continue update logic ...
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
```
*Note: Apply this fix to ALL doctor routes that act on a patient (Status Update, Follow-up, Medications, Review).*

---

## 2. 🎤 Feature: Voice Messages Support
**The Problem:**
The app fails to send voice messages. The backend is not properly handling the `multipart/form-data` for audio files or saving the required fields.

**The Fix:**
1. **Middleware:** Ensure `POST /api/chat/send` uses `multer` to accept a field exactly named `file`.
2. **Storage:** Upload the received audio buffer to Cloudinary or AWS S3 to get a public URL.
3. **Database Schema:** Update the Chat Message schema to store:
   - `type`: String (Enum: `text`, `image`, `audio`, `file`)
   - `mediaUrl`: String (The Cloudinary/S3 URL)
   - `durationMs`: Number (The length of the audio in milliseconds)
4. **Race Condition Warning:** You MUST `await` the file upload and the database `save()` BEFORE returning the `201 OK` response. If you return the response too early, the frontend will pull the chat history and the voice message will be missing.
5. **Response:** Return the FULL saved message object in the response.

---

## 3. 💊 Feature: Missing Medication Data
**The Problem:**
The `/api/resources/medications` endpoint only returns `name`, `activeIngredient`, and `category`. The frontend UI has "N/A" placeholders because it expects more details.

**The Fix:**
Update the database records and the API response to include:
1. `description` (String): A brief overview of the medication.
2. `uses` (Array of Strings): A list of common uses (e.g., `["Ringworm", "Yeast infections"]`).

---

## 4. 🗑️ Feature: Delete Messages & Conversations
**The Problem:**
Users can now delete messages and clear chats on the app, but the backend endpoints are missing.

**The Fix:**
Please implement the following two endpoints:
1. **`DELETE /api/chat/messages/:messageId`**
   - Deletes a specific message.
   - *Requirement:* Ensure the authenticated user's ID matches the `senderId` of the message.
2. **`DELETE /api/chat/conversations/:receiverId`**
   - Clears the chat history between the logged-in user and the specified `receiverId`.

Return a standard HTTP 200 OK status on success for both endpoints.

---

## 5. 🏗️ Architecture: Standardize Route Naming & Status Codes
To prevent 404 errors on the frontend, please ensure your routes are standardized. We recommend:
- **Patient's own routes:** `/api/patient/me/...`
- **Doctor's routes (acting on a patient):** `/api/doctor/patients/:patientId/...`

**Status Codes:** 
Always return standard HTTP JSON error codes (`400`, `401`, `404`, `500`) instead of returning `200 OK` with an error message inside the body, and prevent Express from crashing and returning HTML pages.
