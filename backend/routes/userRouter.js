import express from "express";
import {
  getUserProfile,
  updateUserProfile,
  getAllUsers,
  deleteUser,
} from "../controllers/userController.js";
import { protect, adminOnly } from "../middlewares/authMiddleware.js";

const router = express.Router();

// 🧍 Get current user's profile
router.get("/profile", protect, getUserProfile);

// ✏️ Update current user's profile
router.put("/profile", protect, updateUserProfile);

// 👥 Get all users (Admin only)
router.get("/", protect, adminOnly, getAllUsers);

// ❌ Delete user (Admin only)
router.delete("/:id", protect, adminOnly, deleteUser);

export default router;
