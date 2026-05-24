# Voice Message Fix - Backend Implementation Guide

This document outlines the precise requirements and expected fixes for the backend regarding the Voice Message feature in the Chat.

## The Problem
When the Flutter app records and sends a voice message, it is failing. The backend is either rejecting the request, crashing, or failing to save the audio file properly and returning an incomplete response.

## How the Frontend Sends the Voice Message
The Flutter frontend uses a `multipart/form-data` request.

**Endpoint:** `POST /api/chat/send`  
**Method:** `POST`  
**Content-Type:** `multipart/form-data`

### Form-Data Fields Sent by Frontend:
1. `receiverId` *(String)*: The ID of the user receiving the message.
2. `content` *(String)*: Empty string `""` for voice messages.
3. `type` *(String)*: Exactly `"audio"`.
4. `durationMs` *(Integer)*: The length of the audio recording in milliseconds (e.g., `3500`).
5. `file` *(File)*: The actual audio file (usually a `.m4a` format). **Note that the field key is exactly `file`**.

---

## What Needs to be Fixed on the Backend

### 1. `multer` Middleware Configuration
The endpoint must have `multer` configured to accept the `file` field.
```javascript
// Example Express Route
router.post('/send', upload.single('file'), chatController.sendMessage);
```

### 2. File Upload & Storage
The backend must take `req.file`, upload it to a cloud storage provider (like Cloudinary or AWS S3), and get the public URL (e.g., `mediaUrl`).

### 3. Database Schema Updates
The chat message schema in MongoDB (or PostgreSQL) MUST support and save the following:
- `type` (Enum: text, image, audio, file)
- `mediaUrl` (String: the Cloudinary/S3 URL of the uploaded audio)
- `durationMs` (Number: the duration of the audio in ms)

### 4. Wait for DB Persistence (Race Condition)
Ensure the file upload and the database `save()` operations are fully `await`ed **before** returning the HTTP `200` or `201` response.
If the backend returns a response before the database write finishes, the frontend will immediately pull the chat history and the voice message will be missing from the UI.

### 5. Return the Complete Message Object
The response JSON MUST include the newly created message object containing the `mediaUrl` and `durationMs` so the frontend knows the upload succeeded.
**Expected Response Example:**
```json
{
  "message": "Message sent successfully",
  "data": {
    "_id": "64abcdef...",
    "senderId": "...",
    "receiverId": "...",
    "content": "",
    "type": "audio",
    "mediaUrl": "https://cloudinary.com/.../voice_123.m4a",
    "durationMs": 3500,
    "timestamp": "2023-10-15T12:00:00Z"
  }
}
```

## Summary Checklist for Backend Developer
- [ ] Ensure `POST /api/chat/send` accepts `multipart/form-data`.
- [ ] Add `upload.single('file')` to the route.
- [ ] Ensure the DB schema has `mediaUrl` and `durationMs`.
- [ ] Upload the audio buffer to cloud storage and get the URL.
- [ ] Save all fields to DB using `await`.
- [ ] Return the full saved object in the response.
