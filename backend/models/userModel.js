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

    isVerified: { type: Boolean, default: false },

    // 🔹 Therapist-only fields
    specialization: {
      type: String,
      trim: true,
      default: null,
    },
    bio: {
      type: String,
      trim: true,
      maxlength: 1000,
      default: null,
    },
    sessionPrice: {
      type: Number,
      min: 0,
      default: null,
    },
    experienceYears: {
      type: Number,
      min: 0,
      default: null,
    },
    qualifications: {
      type: [String],
      default: [],
    },
    profilePicture: {
      type: String, // URL to Cloudinary or S3
      default: null,
    },
    availability: {
      type: [
        {
          day: { type: String },
          timeSlots: [String],
        },
      ],
      default: [],
    },
    isApproved: {
      type: Boolean,
      default: false, // Admin must approve therapists before they appear in listings
    },

    // 🔹 Common meta
    lastLogin: { type: Date },
    resetToken: { type: String },
    resetTokenExpiry: { type: Date },
  },
  { timestamps: true }
);

//
// 🧠 Pre-save hook to hash password
//
userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

//
// 🔐 Compare password method
//
userSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

//
// 🧾 Helper: check if user is therapist & approved
//
userSchema.methods.isVerifiedTherapist = function () {
  return this.role === "therapist" && this.isApproved === true;
};

export default mongoose.model("User", userSchema);
