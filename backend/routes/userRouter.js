import express from "express";
import {
  getUserProfile,
  updateUserProfile,
  getAllUsers,
  deleteUser,
  updateProfilePicture,
  deleteMyAccount
} from "../controllers/userController.js";

import { isAuth, isAdmin } from "../middleware/authentication.js";
import  upload  from "../middleware/uploadMiddleware.js";

const router = express.Router();

// --------------------------------------------------
// USER SELF ROUTES
// --------------------------------------------------

// Get current user's profile
router.get("/profile", isAuth, getUserProfile);

// Update current user's profile
router.patch("/profile", isAuth, updateUserProfile);

// Update profile picture
router.patch(
  "/profile-picture",
  isAuth,
  upload.single("image"),
  updateProfilePicture
);

//user delete there own account
router.delete("/me", isAuth, deleteMyAccount);

// --------------------------------------------------
// ADMIN ROUTES
// --------------------------------------------------

// Get all users
router.get("/", isAuth, isAdmin, getAllUsers);



// Delete a user
router.delete("/:id", isAuth, isAdmin, deleteUser);




export default router;
