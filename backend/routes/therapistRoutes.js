import express from "express";
import {
  getAllTherapists,
  getTherapistById,
  updateTherapistProfile,
  approveTherapist,
} from "../controllers/therapistController.js";
import { isAuth, isAdmin } from "../middleware/authentication.js";

const router = express.Router();

// 🔹 Public routes
router.get("/", getAllTherapists);
router.get("/:id", getTherapistById);

// 🔹 Therapist-only route
router.put("/profile", isAuth, updateTherapistProfile);

// 🔹 Admin-only route
router.patch("/:id/approve", isAuth, isAdmin, approveTherapist);

export default router;
