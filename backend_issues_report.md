# Dermalyze Backend API Issues & Recommendations

This document outlines all the inconsistencies, bugs, and architectural issues currently present in the Dermalyze Node.js/Express Backend. Please review these points and adjust the backend logic and routing to ensure seamless integration with the Flutter application.

---

## 1. ID Mismatch between `User` and `Patient` Models
**Issue:** 
The frontend currently stores the `_id` of the `User` document received from `POST /api/auth/login`. However, several endpoints (e.g., fetching medications or updating status) seem to expect the `_id` of the `Patient` document, leading to `"Patient not found"` errors.
**Required Action:**
- **Option A (Recommended):** Modify the backend controllers to accept the `User ID` (e.g., `req.params.patientId` is treated as a User ID) and automatically look up the corresponding `Patient` document using `Patient.findOne({ user: req.params.patientId })`.
- **Option B:** If the backend strictly requires the `Patient ID` in the URL params, the `POST /api/auth/login` and `POST /api/auth/register` endpoints MUST return the `patientId` alongside the user data in the response payload.

## 2. Inconsistent API Route Naming (Singular vs Plural & Prefixing)
**Issue:**
The API routes lack a unified RESTful standard. The Flutter app had to constantly guess whether to use `patient` or `patients`, and whether doctor-initiated actions require a `/doctor/` prefix.
Examples of confusion:
- Medications: `/api/patient/:id/medications` vs `/api/patients/:id/medications`
- Status Update: `/api/patients/:id/status` vs `/api/doctor/patients/:id/status`
- Analysis: `/api/analysis/:id` vs `/api/doctor/patients/:id/analysis`
**Required Action:**
Standardize the routes. A recommended RESTful structure is:
- **Patient's own routes:** `/api/patients/me/medications`, `/api/patients/me/analysis`
- **Doctor's routes (acting on a patient):** `/api/doctors/patients/:patientId/status`, `/api/doctors/patients/:patientId/medications`

## 3. Standardize HTTP Error Status Codes
**Issue:**
Sometimes when an operation fails (like sending a chat message or uploading a file), the backend returns a `200 OK` status with an error message in the JSON body (e.g., `{ "error": "Failed to upload" }`), or it crashes and returns an HTML page instead of JSON.
**Required Action:**
- ALWAYS use standard HTTP error codes (`400 Bad Request`, `401 Unauthorized`, `404 Not Found`, `500 Internal Server Error`).
- Ensure that `404 Not Found` responses for missing records return a JSON format like `{ "message": "Patient not found" }` rather than letting Express return default HTML. This ensures `Dio` (the Flutter HTTP client) can parse the error correctly.

## 4. Chat & Media Upload Latency (Race Conditions)
**Issue:**
When sending an image or voice message via `POST /api/chat/send` (using `multipart/form-data`), the frontend uploads the file. However, if the frontend immediately polls `GET /api/chat/messages/:receiverId`, the newly sent message is sometimes missing from the response, causing it to disappear briefly from the UI.
**Required Action:**
Ensure database writes for chat messages are atomic and fully persisted before returning the `201 Created` or `200 OK` response to the `POST /api/chat/send` request.

## 5. Doctor Registration Payload Documentation
**Issue:**
The `POST /api/auth/register` endpoint for Doctors requires ID cards and a selfie (`multipart/form-data`), but it was throwing `400` errors for missing files.
**Required Action:**
Clearly document or ensure that the backend explicitly expects these exact `FormData` field names for file uploads:
- `idCardFront` (File)
- `idCardBack` (File)
- `selfie` (File)
Make sure the backend handles these fields robustly and returns descriptive JSON validation errors if any are missing.

## 6. Token Expiration & Refresh Mechanism
**Issue:**
Tokens seem to expire very quickly, causing the frontend to log users out frequently with a `401 Unauthorized` error.
**Required Action:**
- If possible, extend the JWT expiration time (e.g., to 7 days or 30 days) to improve the user experience.
- Implement a **Refresh Token** endpoint (`POST /api/auth/refresh`) so the frontend can silently fetch a new access token without forcing the user to re-enter their credentials every time their session expires.

## 7. Deeply Nested & Inconsistent Response Structures
**Issue:**
The API responses often return deeply nested arrays that make parsing difficult on the frontend. For example, `GET /api/chat/conversations` returns data nested inside `response.conversations.data.chats`, while `GET /api/doctor/patients` returns data inside `response.patients.data`. 
**Required Action:**
Flatten and standardize the response format. A simple `{ "data": [...] }` or `{ "message": "Success", "data": [...] }` at the root level is much better and cleaner than deep nesting.

## 8. File Upload Implementations (Multer/Cloudinary)
**Issue:**
When using `POST /api/chat/send` to send images/documents, the frontend must use `multipart/form-data`. In the past, there were issues parsing these files on the backend.
**Required Action:**
Ensure that any endpoint expecting a file (like `/chat/send`, `/analysis/:id`, and `/auth/register` for doctors) has a proper middleware (e.g., `multer`) configured to parse the file, upload it to a storage bucket (like Cloudinary or AWS S3), and correctly save the resulting URL in the database before returning the response.

---
**Note to the AI / Backend Developer:** 
Please align the backend with these recommendations and provide a single, updated `Postman Collection` or `Swagger` JSON mapping the EXACT endpoints (with correct prefixes and pluralization) so the Flutter application can map them without 404 errors.
