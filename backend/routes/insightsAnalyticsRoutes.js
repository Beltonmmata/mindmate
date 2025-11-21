import express from "express";
import {
  getUserInsights,
  getUserSessions,
  getWellnessSummary,
} from "../controllers/insightsAnalyticsController.js";
import { isAuth } from "../middleware/authentication.js";

const router = express.Router();

/**
 * GET /api/insights/:timeframe
 * Get AI-generated insights for a user
 * Timeframe: "daily", "weekly", "monthly"
 * Protected: requires authentication
 */
router.get("/:timeframe?", isAuth, getUserInsights);

/**
 * GET /api/insights/sessions/:type
 * Get historical sessions for a user
 * Type: "ai-chat", "chart-generation", "insight-analysis"
 * Protected: requires authentication
 */
router.get("/sessions/:type", isAuth, getUserSessions);

/**
 * GET /api/insights/summary
 * Get wellness summary for dashboard
 * Protected: requires authentication
 */
router.get("/dashboard/summary", isAuth, getWellnessSummary);

export default router;
