import User from "../models/userModel.js";
import { redis } from "../config/redis.js";
import { generateToken } from "../utils/generateToken.js";
import { sendEmail } from "../utils/sendEmail.js";
import validator from "validator";
import crypto from "crypto";
import bcrypt from "bcryptjs";
import { StatusCodes } from "http-status-codes";

import { NotFoundError, BadRequestError } from "../errors/index.js";

// ================= REGISTER =================
export const registerUser = async (req, res) => {
  const { name, email, password, role } = req.body;

  if (!name || !email || !password)
    throw new BadRequestError("All fields are required");

  if (!validator.isEmail(email))
    throw new BadRequestError("Invalid email format");

  const existingUser = await User.findOne({ email });

  if (existingUser) {
    if (existingUser.isVerified) {
      throw new BadRequestError("Email already registered and verified");
    } else {
      // resend OTP if unverified
      const newOtp = Math.floor(100000 + Math.random() * 900000).toString();
      await redis.set(`otp:${email}`, String(newOtp), { ex: 600 });
      
      await sendEmail(
        email,
        "Verify your MindMate account",
        `<h2>Your new OTP is: ${newOtp}</h2><p>Valid for 10 minutes.</p>`
      );

      return res.status(StatusCodes.OK).json({
        success: true,
        message:
          "Email already registered but not verified. New OTP sent to your email.",
        data: {},
      });
    }
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  await User.create({
    name,
    email,
    password: hashedPassword,
    role,
    isVerified: false,
  });

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  await redis.set(`otp:${email}`, otp, { ex: 600 });


  await sendEmail(
    email,
    "Verify your MindMate account",
    `<h2>Your verification OTP is: ${otp}</h2><p>Valid for 10 minutes.</p>`
  );

  res.status(StatusCodes.CREATED).json({
    success: true,
    message:
      "User registered successfully. OTP sent to email for verification.",
    data: {},
  });
};

// ================= VERIFY EMAIL =================
export const verifyEmail = async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) throw new BadRequestError("Email and OTP are required");

  const storedOtp = await redis.get(`otp:${email}`);

  if (!storedOtp)
    throw new BadRequestError(
      "OTP expired or not found. Please request a new one."
    );

  if (String(storedOtp).trim() !== String(otp).trim())
    throw new BadRequestError("Invalid OTP. Please try again.");

  const user = await User.findOne({ email });
  if (!user) throw new NotFoundError("User not found");

  user.isVerified = true;
  await user.save();
  await redis.del(`otp:${email}`);

  // Auto-login after verification
  const token = generateToken(user._id);
  const { password: _, ...safeUser } = user._doc;

  res.status(StatusCodes.OK).json({
    success: true,
    message: "Email verified successfully. You are now logged in.",
    token,
    data: { user: safeUser },
  });
};

// ================= LOGIN =================
export const loginUser = async (req, res) => {
  const { email, password } = req.body;

  console.log("🔑 Login attempt for email:", email);

  // Step 1: Find user
  const user = await User.findOne({ email });
  if (!user) {
    console.log("❌ User not found in DB");
    throw new NotFoundError("User not found");
  }
  console.log("✅ User found:", user._id);

  // Step 2: Check password
  const isMatch = await user.matchPassword(password);
  if (!isMatch) {
    console.log("❌ Password does not match for user:", user._id);
    throw new BadRequestError("Invalid credentials");
  }
  console.log("✅ Password matches");

  // Step 3: Check email verification
  if (!user.isVerified) {
    console.log("⚠️ User email not verified:", user._id);
    throw new BadRequestError("Please verify your email first.");
  }
  console.log("✅ Email verified");

  // Step 4: Generate JWT token
  const token = generateToken(user._id);

  // Step 5: Return safe user data
  const { password: _, ...safeUser } = user._doc;

  console.log("🎉 Login successful for user:", user._id);

  res.status(StatusCodes.OK).json({
    success: true,
    message: "Login successful",
    token,
    data: { user: safeUser },
  });
};
// ================= FORGOT PASSWORD =================
export const forgotPassword = async (req, res) => {
  const { email } = req.body;

  if (!email) throw new BadRequestError("Email is required");

  const user = await User.findOne({ email });
  if (!user) throw new NotFoundError("User not found");

  if (!user.isVerified)
    throw new BadRequestError(
      "Please verify your email first before resetting password."
    );

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  await redis.set(`reset:${email}`, otp, { ex: 600 }); // store for 10 minutes

  await sendEmail(
    email,
    "MindMate Password Reset",
    `<h2>Your password reset OTP: ${otp}</h2><p>Valid for 10 minutes.</p>`
  );

  res.status(StatusCodes.OK).json({
    success: true,
    message: "Password reset OTP sent to your email.",
    data: {},
  });
};

// ================= RESET PASSWORD =================
export const resetPassword = async (req, res) => {
  const { email, otp, newPassword } = req.body;

  if (!email || !otp || !newPassword)
    throw new BadRequestError("Email, OTP, and new password are required");

  const storedOtp = await redis.get(`reset:${email}`);
  if (!storedOtp)
    throw new BadRequestError(
      "OTP expired or not found. Please request a new one."
    );

  if (String(storedOtp).trim() !== String(otp).trim())
    throw new BadRequestError("Invalid OTP. Please try again.");

  const user = await User.findOne({ email });
  if (!user) throw new NotFoundError("User not found");

  user.password = await bcrypt.hash(newPassword, 10);
  await user.save();

  await redis.del(`reset:${email}`);

  res.status(StatusCodes.OK).json({
    success: true,
    message:
      "Password reset successful. You can now log in with your new password.",
    data: {},
  });
};
