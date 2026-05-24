# Medications Guide: Missing Data Fields

This document highlights missing fields in the `/api/resources/medications` endpoint that are causing "N/A" to appear on the frontend.

## The Issue
The Flutter app has a detailed modal for medications that expects to display the medication's `description` and `uses` (Common Uses). However, checking the backend response, it currently only sends three fields:
- `name`
- `activeIngredient`
- `category`

*Current API Response:*
```json
{
    "name": "2AZOLE Cream 20gm",
    "activeIngredient": "Unknown",
    "category": "Tinea (Ringworm), Candidiasis & Fungal Infections"
}
```

## Required Backend Action
To make the UI fully functional and remove the "N/A" placeholders, please update the medication objects in the database/API response to include:

1. **`description` (String)**: A brief overview or description of the medication.
2. **`uses` (Array of Strings)**: A list of common uses or indications for the drug.

*Expected API Response format:*
```json
{
    "name": "2AZOLE Cream 20gm",
    "activeIngredient": "Unknown",
    "category": "Tinea (Ringworm), Candidiasis & Fungal Infections",
    "description": "An antifungal cream used for topical treatment.",
    "uses": ["Ringworm", "Yeast infections", "Jock itch"]
}
```

**Note:** The frontend has already been updated to gracefully handle these missing fields. It will now also display the `activeIngredient` on the UI. Once the backend starts returning `description` and `uses`, the "N/A" placeholders will automatically be populated with the real data!
