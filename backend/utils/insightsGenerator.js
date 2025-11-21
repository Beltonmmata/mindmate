import { callHuggingFace } from "./huggingFaceClient.js";

/**
 * Generate AI-powered insights from user analytics data
 * @param {Object} analyticsData - User's metrics over time
 * @param {string} timeframe - "daily", "weekly", or "monthly"
 * @returns {Promise<string>} - Generated insights text
 */
export const generateInsights = async (analyticsData, timeframe = "weekly") => {
  if (!analyticsData || Object.keys(analyticsData).length === 0) {
    throw new Error("Analytics data is required");
  }

  const prompt = `You are a mental wellness AI analyst. Analyze this user's wellness data and provide concise, actionable insights.

Analytics Data (${timeframe}):
${JSON.stringify(analyticsData, null, 2)}

Provide a brief analysis (2-3 sentences) with:
1. Key trend observation
2. One specific recommendation

Keep it compassionate and non-clinical.`;

  try {
    const insights = await callHuggingFace(
      prompt,
      "mistralai/Mistral-7B-Instruct-v0.1"
    );

    return insights || "Unable to generate insights at this time.";
  } catch (error) {
    throw new Error(`Failed to generate insights: ${error.message}`);
  }
};

/**
 * Calculate average metrics from analytics array
 * @param {Array} analyticsArray - Array of analytics objects with metrics
 * @returns {Object} - Average anxiety, stress, and mood scores
 */
export const calculateAverageMetrics = (analyticsArray) => {
  if (!Array.isArray(analyticsArray) || analyticsArray.length === 0) {
    return { anxiety: 0, stress: 0, mood: 0 };
  }

  const sum = analyticsArray.reduce(
    (acc, analytics) => ({
      anxiety: acc.anxiety + (analytics.metrics?.anxiety || 0),
      stress: acc.stress + (analytics.metrics?.stress || 0),
      mood: acc.mood + (analytics.metrics?.mood || 0),
    }),
    { anxiety: 0, stress: 0, mood: 0 }
  );

  const count = analyticsArray.length;

  return {
    anxiety: Math.round(sum.anxiety / count),
    stress: Math.round(sum.stress / count),
    mood: Math.round(sum.mood / count),
  };
};

/**
 * Identify trends in metrics
 * @param {Array} analyticsArray - Array of analytics objects
 * @returns {Object} - Trend information for each metric
 */
export const identifyTrends = (analyticsArray) => {
  if (!Array.isArray(analyticsArray) || analyticsArray.length < 2) {
    return {
      anxiety: "insufficient_data",
      stress: "insufficient_data",
      mood: "insufficient_data",
    };
  }

  const sortedByDate = [...analyticsArray].sort(
    (a, b) => new Date(a.date) - new Date(b.date)
  );

  const firstHalf = sortedByDate.slice(0, Math.floor(sortedByDate.length / 2));
  const secondHalf = sortedByDate.slice(Math.floor(sortedByDate.length / 2));

  const avgFirstHalf = calculateAverageMetrics(firstHalf);
  const avgSecondHalf = calculateAverageMetrics(secondHalf);

  const calculateTrend = (metric) => {
    const diff = avgSecondHalf[metric] - avgFirstHalf[metric];
    if (diff > 5) return "increasing";
    if (diff < -5) return "decreasing";
    return "stable";
  };

  return {
    anxiety: calculateTrend("anxiety"),
    stress: calculateTrend("stress"),
    mood: calculateTrend("mood"),
  };
};
