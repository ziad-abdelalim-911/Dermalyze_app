# Follow-up Timeline & AI Comparison Logic

This document explains how the backend AI model and database should handle patient skin disease photos over time (Initial vs Follow-up photos) to support the **Progress Timeline** in the mobile app.

## The Workflow Concept

1. **First Visit (Initial Photo):**
   - The doctor takes the first picture of the patient's skin condition.
   - The backend AI model analyzes it, saves the diagnosis/severity, and marks this as the **Initial** state.

2. **Second Visit (Follow-up 1):**
   - e.g. After 15 days, the doctor takes a second photo.
   - The backend AI model MUST compare this new photo with the **first photo (Initial)**.
   - It calculates if the skin has improved or deteriorated, and generates an `improvement_percentage` (e.g., `+13%`).

3. **Third Visit (Follow-up 2):**
   - The doctor takes a third photo.
   - The backend AI model MUST compare this new photo with the **second photo (Follow-up 1)**.
   - It calculates a new `improvement_percentage` (e.g., `+20%`).

## Required Database Structure

When saving a new analysis document for a patient, ensure the schema supports these fields:

```javascript
{
  patientId: ObjectId,       // Reference to the Patient
  doctorId: ObjectId,        // Reference to the Doctor
  imageUrl: String,          // The uploaded photo URL (Cloudinary/S3)
  severity: String,          // The severity determined by AI (e.g., "Low", "Medium", "High")
  createdAt: Date,           // Timestamp of the upload
  
  // --- Fields specifically needed for the Timeline ---
  stage: String,             // Chronological stage (Optional: "Initial", "Follow up 1", "Follow up 2"). The frontend can auto-calculate this if omitted, but providing it from the backend is cleaner.
  improvement: String        // The AI's comparison result against the previous photo (e.g., "+13% improvement", "-5% deterioration", or null if it's the Initial photo)
}
```

## How the AI Pipeline Should Work (Pseudocode)

When a doctor uploads a new photo to `/api/analysis/:patientId`:

```javascript
// 1. Fetch the patient's previous analyses, sorted by date descending (newest first)
const previousAnalyses = await Analysis.find({ patientId }).sort({ createdAt: -1 });

let improvementResult = null;
let stageLabel = "Initial";

if (previousAnalyses.length > 0) {
    // 2. This is a follow-up. Get the immediately preceding photo
    const lastAnalysis = previousAnalyses[0];
    
    // 3. Run AI Model Comparison
    improvementResult = await AI_Model.compareImages({
        oldImageUrl: lastAnalysis.imageUrl,
        newImageUrl: req.body.newImageUrl
    });
    // e.g., improvementResult = "+13% improvement"
    
    // 4. Set the Stage Label
    stageLabel = `Follow up ${previousAnalyses.length}`; 
}

// 5. Save the new analysis to the database
const newAnalysis = new Analysis({
    patientId,
    imageUrl: req.body.newImageUrl,
    severity: aiSeverityResult,
    stage: stageLabel,
    improvement: improvementResult,
    createdAt: new Date()
});

await newAnalysis.save();
```

## API Response Format

When the Flutter app calls `GET /api/patient/:id/analyses`, the backend should return the list of analyses. 
The frontend will map `stage` to the title, `severity` to the badge, `createdAt` to the date, and `improvement` to the green/red subtext.

**Expected Array Format:**
```json
[
  {
    "stage": "Follow up 2",
    "severity": "Medium",
    "createdAt": "2024-12-29T10:00:00Z",
    "improvement": "+20% improvement"
  },
  {
    "stage": "Follow up 1",
    "severity": "Medium",
    "createdAt": "2024-12-15T10:00:00Z",
    "improvement": "+13% improvement"
  },
  {
    "stage": "Initial",
    "severity": "Low",
    "createdAt": "2024-12-01T10:00:00Z",
    "improvement": null
  }
]
```

## Final Note for Backend Dev
Please ensure the AI model pipeline has access to the previous image's features or raw URL so it can perform the side-by-side comparison algorithm. If the AI model runs in Python (e.g., via Flask/FastAPI), pass both image URLs to the Python service.
