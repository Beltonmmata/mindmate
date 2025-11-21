import mongoose from "mongoose";

const analyticsSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "User ID is required"],
    },

    date: {
      type: Date,
      required: [true, "Date is required"],
      default: () => new Date().setHours(0, 0, 0, 0),
      index: true,
    },

    metrics: {
      anxiety: {
        type: Number,
        min: [0, "Anxiety score must be at least 0"],
        max: [100, "Anxiety score cannot exceed 100"],
        required: [true, "Anxiety metric is required"],
      },
      stress: {
        type: Number,
        min: [0, "Stress score must be at least 0"],
        max: [100, "Stress score cannot exceed 100"],
        required: [true, "Stress metric is required"],
      },
      mood: {
        type: Number,
        min: [0, "Mood score must be at least 0"],
        max: [100, "Mood score cannot exceed 100"],
        required: [true, "Mood metric is required"],
      },
    },

    insights: {
      type: String,
      maxlength: [2000, "Insights cannot exceed 2000 characters"],
      default: null,
    },
  },
  { timestamps: true }
);

// Compound index for efficient user-date queries
analyticsSchema.index({ userId: 1, date: -1 });

export default mongoose.model("Analytics", analyticsSchema);
