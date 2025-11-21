import express from "express";
import { sendMessage } from "../controllers/aiChatController.js";
import { isAuth } from "../middleware/authentication.js";

const router = express.Router();

/**
 * POST /api/ai-chat/message
 * Send a message to AI and get a response
 * Protected: requires authentication
 */
router.post("/message", isAuth, sendMessage);

export default router;
