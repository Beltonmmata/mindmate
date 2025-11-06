import jwt from "jsonwebtoken";
import User from "../models/user.js";
import { UnauthenticatedError, UnauthorizedError } from "../errors/index.js";

/**
 * Authentication middleware
 * - Verifies JWT from either Authorization header or cookie
 * - Attaches user data (without password) to req.user
 */
export const isAuth = async (req, res, next) => {
  try {
    let token = null;

    // 1️⃣ Check Authorization header (mobile apps and APIs)
    if (req.headers.authorization?.startsWith("Bearer ")) {
      token = req.headers.authorization.split(" ")[1];
    }

    // 2️⃣ Fallback: Check cookies (for web clients)
    if (!token && req.cookies?.token) {
      token = req.cookies.token;
    }

    // 3️⃣ No token provided
    if (!token) {
      throw new UnauthenticatedError("Not authorized — token missing.");
    }

    // 4️⃣ Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // 5️⃣ Fetch user
    const user = await User.findById(decoded.id).select("-password");
    if (!user) throw new UnauthenticatedError("User not found.");

    // 6️⃣ Attach user to request
    req.user = user;
    console.log("✅ Authenticated user:", user.email);

    next();
  } catch (error) {
    next(new UnauthenticatedError("Invalid or expired token."));
  }
};

/**
 * Admin-only route protection
 */
export const isAdmin = (req, res, next) => {
  if (!req.user || !req.user.isAdmin) {
    throw new UnauthorizedError("Access denied — admins only.");
  }
  next();
};
