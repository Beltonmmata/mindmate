import express from "express";
import { generateChartData } from "../controllers/chartAIController.js";
import { isAuth } from "../middleware/authentication.js";

const router = express.Router();

/**
 * POST /api/chart-ai/generate
 * Generate chart data and insights from user summary
 * Protected: requires authentication
 */
router.post("/generate", isAuth, generateChartData);

export default router;
