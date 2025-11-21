import Analytics from "../models/analyticsModel.js";
import Session from "../models/sessionModel.js";
import { StatusCodes } from "http-status-codes";
import { BadRequestError, NotFoundError } from "../errors/index.js";
import {
  generateInsights,
  calculateAverageMetrics,
  identifyTrends,
} from "../utils/insightsGenerator.js";

/**
 * @desc Get AI-generated insights for a user based on their analytics
 * @route GET /api/insights/user/:timeframe
 * @access Private (authenticated users only)
 * @param timeframe - "daily", "weekly", "monthly" (optional, defaults to "weekly")
 */
export const getUserInsights = async (req, res) => {
  const userId = req.user._id;
  const { timeframe = "weekly" } = req.query;

  // Validate timeframe
  const validTimeframes = ["daily", "weekly", "monthly"];
  if (!validTimeframes.includes(timeframe)) {
    throw new BadRequestError(
      `Invalid timeframe. Must be one of: ${validTimeframes.join(", ")}`
    );
  }

  try {
    // Calculate date range based on timeframe
    const now = new Date();
    let startDate = new Date();

    switch (timeframe) {
      case "daily":
        startDate.setDate(now.getDate() - 1);
        break;
      case "weekly":
        startDate.setDate(now.getDate() - 7);
        break;
      case "monthly":
        startDate.setMonth(now.getMonth() - 1);
        break;
    }

    // Fetch analytics for the user within the timeframe
    const analyticsData = await Analytics.find({
      userId,
      date: { $gte: startDate, $lte: now },
    }).sort({ date: -1 });

    if (!analyticsData || analyticsData.length === 0) {
      return res.status(StatusCodes.OK).json({
        success: true,
        message:
          "No analytics data available for this period. Keep tracking your wellness!",
        data: {
          userId,
          timeframe,
          analyticsCount: 0,
          averageMetrics: { anxiety: 0, stress: 0, mood: 0 },
          trends: { anxiety: "insufficient_data", stress: "insufficient_data", mood: "insufficient_data" },
          insights: "Start tracking your wellness to get personalized insights.",
        },
      });
    }

    // Calculate metrics
    const averageMetrics = calculateAverageMetrics(analyticsData);
    const trends = identifyTrends(analyticsData);

    // Generate AI insights
    const insights = await generateInsights(
      {
        timeframe,
        analyticsCount: analyticsData.length,
        averageMetrics,
        trends,
        rawData: analyticsData.map((a) => a.metrics),
      },
      timeframe
    );

    // Save session record
    await Session.create({
      userId,
      type: "insight-analysis",
      input: JSON.stringify({ timeframe, analyticsCount: analyticsData.length }),
      output: {
        averageMetrics,
        trends,
        insights,
      },
      model: "mistralai/Mistral-7B-Instruct-v0.1",
    });

    res.status(StatusCodes.OK).json({
      success: true,
      message: "Insights generated successfully",
      data: {
        userId,
        timeframe,
        analyticsCount: analyticsData.length,
        averageMetrics,
        trends,
        insights,
      },
    });
  } catch (error) {
    throw new BadRequestError(error.message || "Failed to generate insights");
  }
};

/**
 * @desc Get historical sessions for a user
 * @route GET /api/insights/sessions/:type
 * @access Private (authenticated users only)
 * @param type - "ai-chat", "chart-generation", "insight-analysis" (optional)
 */
export const getUserSessions = async (req, res) => {
  const userId = req.user._id;
  const { type } = req.params;
  const { limit = 10, page = 1 } = req.query;

  try {
    const pageNum = parseInt(page) || 1;
    const limitNum = parseInt(limit) || 10;
    const skip = (pageNum - 1) * limitNum;

    // Build filter
    const filter = { userId };
    if (type && type !== "all") {
      const validTypes = ["ai-chat", "chart-generation", "insight-analysis"];
      if (!validTypes.includes(type)) {
        throw new BadRequestError(
          `Invalid session type. Must be one of: ${validTypes.join(", ")}`
        );
      }
      filter.type = type;
    }

    // Fetch sessions
    const sessions = await Session.find(filter)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limitNum);

    const total = await Session.countDocuments(filter);

    if (!sessions || sessions.length === 0) {
      throw new NotFoundError(`No sessions found for type: ${type || "all"}`);
    }

    res.status(StatusCodes.OK).json({
      success: true,
      message: "Sessions retrieved successfully",
      data: {
        sessions,
        pagination: {
          total,
          page: pageNum,
          limit: limitNum,
          pages: Math.ceil(total / limitNum),
        },
      },
    });
  } catch (error) {
    throw error;
  }
};

/**
 * @desc Get wellness summary for dashboard
 * @route GET /api/insights/summary
 * @access Private (authenticated users only)
 */
export const getWellnessSummary = async (req, res) => {
  const userId = req.user._id;

  try {
    // Get latest analytics
    const latestAnalytics = await Analytics.findOne({ userId }).sort({
      date: -1,
    });

    // Get 7-day average
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const weekAnalytics = await Analytics.find({
      userId,
      date: { $gte: sevenDaysAgo },
    });

    const weekAverageMetrics = calculateAverageMetrics(weekAnalytics);

    // Get latest session
    const latestSession = await Session.findOne({ userId }).sort({
      createdAt: -1,
    });

    res.status(StatusCodes.OK).json({
      success: true,
      message: "Wellness summary retrieved successfully",
      data: {
        latest: latestAnalytics
          ? latestAnalytics.metrics
          : { anxiety: 0, stress: 0, mood: 0 },
        weekAverage: weekAverageMetrics,
        lastSession: latestSession,
        trackingDays: weekAnalytics.length,
      },
    });
  } catch (error) {
    throw new BadRequestError(error.message || "Failed to retrieve summary");
  }
};
