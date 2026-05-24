# Chat: Delete Conversation API Implementation Guide

This document outlines the requirements for the backend to support the "Delete Conversation" feature in the Chat.

## The Feature
Users can now delete an entire chat conversation from their messages list (via long-press) or from inside the chat screen (via the 3-dots menu). When triggered, the app sends a request to the backend to delete the conversation history between the current user and the specified receiver.

## Required Endpoint

### `DELETE /api/chat/conversations/:receiverId`

**Description:**
Deletes all messages between the currently authenticated user and the user identified by `:receiverId`.

**Headers:**
- `Authorization: Bearer <token>`

**Path Parameters:**
- `receiverId` (string): The ID of the other user in the conversation.

**Expected Behavior:**
1. The backend should identify the current user from the authentication token (`senderId`).
2. It should find all messages where `(senderId == currentUserId AND receiverId == receiverId)` OR `(senderId == receiverId AND receiverId == currentUserId)`.
3. It should delete or soft-delete these messages from the database.
4. Return a `200 OK` status with a success message.

**Expected Response (200 OK):**
```json
{
  "success": true,
  "message": "Conversation deleted successfully."
}
```

**Expected Error Responses:**
- `401 Unauthorized` - If token is missing or invalid.
- `404 Not Found` - If no conversation exists.
- `500 Internal Server Error` - If a database error occurs.

Please implement this endpoint so the frontend's Delete Conversation feature functions properly.
