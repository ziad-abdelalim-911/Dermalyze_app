# Chat: Delete Message API Implementation Guide

This document outlines the requirements for the backend to support the "Delete Message" feature in the Chat.

## The Feature
Users can now long-press their own messages in the app to delete them. The app immediately hides the message from the UI and sends a `DELETE` request to the backend.

## Endpoint Details
**Endpoint:** `DELETE /api/chat/messages/:messageId`  
**Method:** `DELETE`  
**Path Parameters:**
- `messageId` (String): The `_id` of the message to be deleted.

## Expected Backend Behavior
1. **Authentication:** Ensure the user requesting the deletion is authenticated.
2. **Authorization:** Validate that the `senderId` of the message matches the ID of the authenticated user (users can only delete their own messages).
3. **Database Action:** 
   - You can permanently delete the document from the database.
   - Alternatively, you can perform a "soft delete" (e.g., set `isDeleted: true` and `content: "This message was deleted"`). If you do this, ensure the `GET /api/chat/messages/:receiverId` endpoint filters out deleted messages or formats them appropriately.
4. **Cloud Storage Cleanup (Optional but Recommended):** If the deleted message is an image, document, or voice note, it is highly recommended to delete the file from the cloud storage (e.g., Cloudinary/AWS S3) using the stored `mediaUrl` to save space.

## Expected Response
Return a standard HTTP 200 OK status on success.
```json
{
  "message": "Message deleted successfully"
}
```

If the message is not found or the user is not authorized, return appropriate error codes (e.g., `404 Not Found` or `403 Forbidden`).
