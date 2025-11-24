import User from "../models/userModel.js";

// -----------------------------------------
// @desc    Get logged-in user's profile
// @route   GET /api/users/profile
// @access  Private
// -----------------------------------------
export const getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select("-password");

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// -----------------------------------------
// @desc    Update logged-in user's profile (NO PASSWORD UPDATES HERE)
// @route   PUT /api/users/profile
// @access  Private
// -----------------------------------------
export const updateUserProfile = async (req, res) => {
  
    const user = await User.findById(req.user._id);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Prevent password changes here
    if (req.body.password) {
      return res.status(400).json({
        message: "Password cannot be updated here. Use /auth/change-password",
      });
    }

    user.name = req.body.name || user.name;
    user.email = req.body.email || user.email;

    const updated = await user.save();

    res.status(200).json({
      message: "Profile updated successfully",
      user: {
        id: updated._id,
        name: updated.name,
        email: updated.email,
      },
    });
 
};

// -----------------------------------------
// @desc    Get all users (admin only)
// @route   GET /api/users
// @access  Admin
// -----------------------------------------
export const getAllUsers = async (req, res) => {  
    const users = await User.find().select("-password");
    res.status(200).json(users);
  
};

// -----------------------------------------
// @desc    Delete a user (admin only)
// @route   DELETE /api/users/:id
// @access  Admin
// -----------------------------------------
export const deleteUser = async (req, res) => {
  
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    await user.deleteOne();

    res.status(200).json({ message: "User removed successfully" });
  
};

// -----------------------------------------
// @desc    Delete a  user own account 
// @route   DELETE /api/users/me
// @access  Admin
// -----------------------------------------
export const deleteMyAccount = async (req, res) => {
  const user = await User.findById(req.user.id);

  if (!user) {
    throw new NotFoundError("User not found");
  }

  await user.deleteOne();

  res.status(200).json({
    success: true,
    message: "Your account has been deleted successfully",
  });
};



// -----------------------------------------
// @desc    Update profile picture
// @route   PATCH /api/users/profile-picture
// @access  Private
// -----------------------------------------
export const updateProfilePicture = async (req, res) => {
  if (!req.file) {
    throw new BadRequestError("No image file provided");
  }

  const user = await User.findById(req.user._id);

  if (!user) {
    throw new NotFoundError("User not found");
  }

  user.profilePicture = req.file.path;
  await user.save();

  res.status(200).json({
    success: true,
    message: "Profile picture updated successfully",
    profilePicture: user.profilePicture,
  });
};
