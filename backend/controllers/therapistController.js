import User from "../models/userModel.js";
import { StatusCodes } from "http-status-codes";
import {
  BadRequestError,
  NotFoundError,
  UnauthorizedError,
} from "../errors/index.js";

/**
 * @desc Get all approved therapists (public route)
 * @route GET /api/therapists
 */
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
    count: therapists.length,
    therapists,
  });
};

/**
 * @desc Get therapist by ID (public route)
 * @route GET /api/therapists/:id
 */
export const getTherapistById = async (req, res) => {
  const therapist = await User.findOne({
    _id: req.params.id,
    role: "therapist",
    isApproved: true,
  }).select("-password");

  if (!therapist) {
    throw new NotFoundError("Therapist not found or not approved.");
  }

  res.status(StatusCodes.OK).json({ success: true, therapist });
};

/**
 * @desc Therapist updates their own profile
 * @route PUT /api/therapists/profile
 * @access Private (therapist only)
 */
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
    if (req.body[field] !== undefined) therapist[field] = req.body[field];
  });

  await therapist.save();

  res.status(StatusCodes.OK).json({
    success: true,
    message: "Profile updated successfully.",
    therapist,
  });
};

/**
 * @desc Admin approves or rejects therapist applications
 * @route PATCH /api/therapists/:id/approve
 * @access Private (admin only)
 */
export const approveTherapist = async (req, res) => {
  const therapist = await User.findById(req.params.id);

  if (!therapist || therapist.role !== "therapist") {
    throw new NotFoundError("Therapist not found.");
  }

  therapist.isApproved = req.body.isApproved ?? true;
  await therapist.save();

  res.status(StatusCodes.OK).json({
    success: true,
    message: `Therapist ${therapist.name} ${
      therapist.isApproved ? "approved" : "rejected"
    } successfully.`,
  });
};
