import User from "../models/userModel.js";
import {
  BadRequestError,
  NotFoundError,
  UnauthorizedError,
} from "../errors/index.js";
import { StatusCodes } from "http-status-codes";

// -----------------------------------------
// @desc    Get ALL approved therapists (Public)
// @route   GET /api/therapists
// @access  Public
// -----------------------------------------
export const getAllTherapists = async (req, res) => {
  const therapists = await User.find({
    role: "therapist",
    isApproved: true,
  }).select("-password -resetToken -resetTokenExpiry");

  if (!therapists || therapists.length === 0) {
    throw new NotFoundError("No approved therapists found.");
  }

  res.status(StatusCodes.OK).json({
    success: true,
    message: "Therapists retrieved successfully",
    data: { therapists, count: therapists.length },
  });
};

// -----------------------------------------
// @desc    Get therapist by ID (Public)
// @route   GET /api/therapists/:id
// @access  Public
// -----------------------------------------
export const getTherapistById = async (req, res) => {
  const therapist = await User.findOne({
    _id: req.params.id,
    role: "therapist",
    isApproved: true,
  }).select("-password -resetToken -resetTokenExpiry");

  if (!therapist) {
    throw new NotFoundError("Therapist not found or not approved.");
  }

  res.status(StatusCodes.OK).json({
    success: true,
    message: "Therapist retrieved successfully",
    data: { therapist },
  });
};

// -----------------------------------------
// @desc    Therapist updates THEIR OWN profile
// @route   PUT /api/therapists/profile
// @access  Private (Therapist only)
// -----------------------------------------
export const updateTherapistProfile = async (req, res) => {
  const therapist = await User.findById(req.user._id);

  if (!therapist || therapist.role !== "therapist") {
    throw new UnauthorizedError("Access denied — therapist only.");
  }

  const fields = [
    "name",
    "specialization",
    "bio",
    "sessionPrice",
    "experienceYears",
    "qualifications",
    "availability",
    "profilePicture",
  ];

  fields.forEach((field) => {
    if (req.body[field] !== undefined) {
      therapist[field] = req.body[field];
    }
  });

  await therapist.save();

  res.status(StatusCodes.OK).json({
    success: true,
    message: "Therapist profile updated successfully",
    data: { therapist },
  });
};

// -----------------------------------------
// @desc    ADMIN approves or rejects a therapist
// @route   PATCH /api/therapists/:id/approve
// @access  Private (Admin only)
// -----------------------------------------
export const approveTherapist = async (req, res) => {
  const therapist = await User.findById(req.params.id);

  if (!therapist || therapist.role !== "therapist") {
    throw new NotFoundError("Therapist not found.");
  }

  therapist.isApproved = req.body.isApproved ?? true;
  await therapist.save();

  res.status(StatusCodes.OK).json({
    success: true,
    message: `Therapist ${therapist.name} has been ${
      therapist.isApproved ? "approved" : "rejected"
    }.`,
    data: { therapist },
  });
};
