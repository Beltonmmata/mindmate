import express from "express";
import {
  getAllTherapists,
  getTherapistById,
  updateTherapistProfile,
  approveTherapist,
} from "../controllers/therapistController.js";

import { isAuth, isAdmin, isTherapist } from "../middleware/authentication.js";

const router = express.Router();

// --------------------------------------------------
// PUBLIC ROUTES
// --------------------------------------------------
router.get("/", getAllTherapists);
router.get("/:id", getTherapistById);

// --------------------------------------------------
// THERAPIST-ONLY ROUTES
// --------------------------------------------------
router.put("/profile", isAuth, isTherapist, updateTherapistProfile);

// --------------------------------------------------
// ADMIN-ONLY ROUTES
// --------------------------------------------------
router.patch("/:id/approve", isAuth, isAdmin, approveTherapist);

export default router;
