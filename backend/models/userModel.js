import mongoose from "mongoose";
import bcrypt from "bcryptjs";

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Please provide your name"],
      trim: true,
    },

    email: {
      type: String,
      required: [true, "Please provide your email"],
      unique: true,
      lowercase: true,
    },

    password: {
      type: String,
      required: [true, "Password is required"],
      minlength: [6, "Password must be at least 6 characters"],
    },

    role: {
      type: String,
      enum: ["user", "therapist", "admin"],
      default: "user",
    },
    gender:{
     type: String,
     enum: ["male","female"],
     
    },

    isVerified: { type: Boolean, default: false },

    specialization: { type: String, trim: true, default: null },
    bio: { type: String, trim: true, maxlength: 1000, default: null },
    sessionPrice: { type: Number, min: 0, default: null },
    experienceYears: { type: Number, min: 0, default: null },
    qualifications: { type: [String], default: [] },
    profilePicture: { type: String, default: null },
    availability: [
      {
        day: { type: String },
        timeSlots: [String],
      },
    ],
    isApproved: { type: Boolean, default: false },

    lastLogin: { type: Date },
    resetToken: { type: String },
    resetTokenExpiry: { type: Date },
  },
  { timestamps: true }
);

// 🔐 Compare password
userSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

export default mongoose.model("User", userSchema);
