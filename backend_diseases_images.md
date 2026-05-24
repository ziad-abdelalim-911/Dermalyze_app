# Diseases Library: Image Fixes Required

This document outlines an issue with the `/api/resources/diseases` endpoint that is preventing images from loading correctly in the Flutter frontend.

## The Issue
Currently, the frontend is successfully receiving the list of diseases. However, the images are displaying as "broken" placeholders. Upon inspecting the JSON response, we found two issues with the `imageUrl` field:

1. **Fake/Dummy URLs**: Many diseases return URLs like `"https://example.com/images/acne.jpg"`. These URLs do not point to real images, causing network errors (`404`) in the app and triggering the broken image icon.
2. **Empty Strings**: Several diseases return `""` (an empty string) for the `imageUrl`.

*Example of current response:*
```json
{
  "id": 14,
  "name": "Acne Vulgaris",
  "imageUrl": "https://example.com/images/acne.jpg" // FAKE URL
},
{
  "id": 19,
  "name": "Acne & Rosacea",
  "imageUrl": "" // EMPTY STRING
}
```

## Required Backend Action
To fix this, the backend database needs to be updated with **real, publicly accessible image URLs** (for example, images hosted on Cloudinary, AWS S3, or Firebase Storage).

1. Please replace all `example.com` placeholder URLs with actual image links.
2. For diseases that do not have an image yet, leaving the field as `null` or `""` is perfectly fine (the frontend has been updated to handle empty strings gracefully and will show a default placeholder icon).

Once the database is populated with real URLs, the images will automatically start working in the app without any further changes required on the frontend!
