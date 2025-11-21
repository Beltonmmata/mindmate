import User from "../models/userModel.js";
import { StatusCodes } from "http-status-codes";
import { NotFoundError } from "../errors/index.js";
import bcrypt from "bcryptjs";

// 🧍 Get logged-in user profile
export const getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select("-password");
    if (!user) throw new NotFoundError("User not found");
    
    res.status(StatusCodes.OK).json({
      success: true,
      message: "User profile retrieved successfully",
      data: { user },
    });
  } catch (error) {
    throw error;
  }
};

// ✏️ Update logged-in user profile
export const updateUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) throw new NotFoundError("User not found");

    user.name = req.body.name || user.name;
    user.email = req.body.email || user.email;
    if (req.body.password) {
      user.password = await bcrypt.hash(req.body.password, 10);
    }

    const updatedUser = await user.save();
    const { password: _, ...safeUser } = updatedUser._doc;

    res.status(StatusCodes.OK).json({
      success: true,
      message: "Profile updated successfully",
      data: { user: safeUser },
    });
  } catch (error) {
    throw error;
  }
};

// 👥 Get all users (Admin only)
export const getAllUsers = async (req, res) => {
  try {
    const users = await User.find().select("-password");
    
    res.status(StatusCodes.OK).json({
      success: true,
      message: "Users retrieved successfully",
      data: { users, count: users.length },
    });
  } catch (error) {
    throw error;
  }
};

// ❌ Delete user (Admin only)
export const deleteUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) throw new NotFoundError("User not found");

    await user.deleteOne();
    
    res.status(StatusCodes.OK).json({
      success: true,
      message: "User deleted successfully",
      data: {},
    });
  } catch (error) {
    throw error;
  }
};
