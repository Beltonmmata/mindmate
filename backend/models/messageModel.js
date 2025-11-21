import mongoose from "mongoose";

const messageSchema = new mongoose.Schema(
  {
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "Sender ID is required"],
    },

    receiverId: {
      type: String,
      required: [true, "Receiver ID is required"],
      // Can be a user ID or "ai" for AI messages
    },

    text: {
      type: String,
      required: [true, "Message text is required"],
      maxlength: [5000, "Message cannot exceed 5000 characters"],
      trim: true,
    },

    aiGenerated: {
      type: Boolean,
      default: false,
      // True if this is a response from HuggingFace AI
    },

    timestamp: {
      type: Date,
      default: Date.now,
      index: true,
    },
  },
  { timestamps: true }
);

// Index for efficient querying by sender and receiver
messageSchema.index({ senderId: 1, receiverId: 1, timestamp: -1 });

export default mongoose.model("Message", messageSchema);
