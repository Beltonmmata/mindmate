import mongoose from "mongoose";

const sessionSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "User ID is required"],
      index: true,
    },

    type: {
      type: String,
      enum: ["ai-chat", "chart-generation", "insight-analysis"],
      required: [true, "Session type is required"],
    },

    input: {
      type: String,
      required: [true, "Input is required"],
      maxlength: [5000, "Input cannot exceed 5000 characters"],
      trim: true,
    },

    output: {
      type: mongoose.Schema.Types.Mixed,
      required: [true, "Output is required"],
      // Can store: AI response text, chart data, or insights object
    },

    duration: {
      type: Number,
      default: 0,
      // Duration in milliseconds
    },

    model: {
      type: String,
      default: "mistralai/Mistral-7B-Instruct-v0.1",
      // AI model used for this session
    },

    status: {
      type: String,
      enum: ["success", "error", "pending"],
      default: "success",
    },

    errorMessage: {
      type: String,
      default: null,
    },

    sessionDate: {
      type: Date,
      default: () => new Date().setHours(0, 0, 0, 0),
      index: true,
    },
  },
  { timestamps: true }
);

// Compound index for efficient user-date queries
sessionSchema.index({ userId: 1, sessionDate: -1 });

// Index for session type queries
sessionSchema.index({ userId: 1, type: 1, createdAt: -1 });

export default mongoose.model("Session", sessionSchema);
