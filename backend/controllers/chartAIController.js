import { callHuggingFace } from "../utils/huggingFaceClient.js";
import { StatusCodes } from "http-status-codes";
import { BadRequestError } from "../errors/index.js";

/**
 * @desc Generate chart data and insights from user summary using AI
 * @route POST /api/chart-ai/generate
 * @access Private (authenticated users only)
 */
export const generateChartData = async (req, res) => {
  const { summary } = req.body;

  // Validate input
  if (!summary || summary.trim().length === 0) {
    throw new BadRequestError("Summary is required and cannot be empty");
  }

  if (summary.length > 5000) {
    throw new BadRequestError("Summary is too long (max 5000 characters)");
  }

  try {
    // Create a prompt for HuggingFace to generate structured JSON
    const prompt = `You are a mental wellness AI. Based on this user summary, generate a JSON response with ONLY this exact structure (no additional text):
{
  "metrics": { "anxiety": <number 0-100>, "stress": <number 0-100>, "mood": <number 0-100> },
  "recommendation": "<one sentence wellness recommendation>",
  "chartData": [{ "day": "Mon", "value": <number 0-100> }, { "day": "Tue", "value": <number 0-100> }, { "day": "Wed", "value": <number 0-100> }, { "day": "Thu", "value": <number 0-100> }, { "day": "Fri", "value": <number 0-100> }, { "day": "Sat", "value": <number 0-100> }, { "day": "Sun", "value": <number 0-100> }]
}

User Summary: "${summary}"

Response (JSON only):`;

    // Call HuggingFace API (use conversational/chat mode for this model)
    const aiResponse = await callHuggingFace(
      prompt,
      "meta-llama/Llama-3.1-8B-Instruct",
      2,
      "chat"
    );

    // Extract JSON from the response
    let parsedData = null;
    try {
      // Try to find JSON in the response
      const jsonMatch = aiResponse.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        parsedData = JSON.parse(jsonMatch[0]);
      } else {
        throw new Error("No JSON found in response");
      }
    } catch (parseError) {
      throw new BadRequestError("Failed to parse AI response as JSON. Please try again.");
    }

    // Validate the structure
    if (!parsedData.metrics || !parsedData.recommendation || !parsedData.chartData) {
      throw new BadRequestError("Invalid response structure from AI");
    }

    // Ensure metrics are numbers between 0-100
    parsedData.metrics.anxiety = Math.min(100, Math.max(0, parseInt(parsedData.metrics.anxiety) || 50));
    parsedData.metrics.stress = Math.min(100, Math.max(0, parseInt(parsedData.metrics.stress) || 50));
    parsedData.metrics.mood = Math.min(100, Math.max(0, parseInt(parsedData.metrics.mood) || 50));

    // Ensure chartData is valid
    if (!Array.isArray(parsedData.chartData)) {
      parsedData.chartData = [];
    }

    res.status(StatusCodes.OK).json({
      success: true,
      message: "Chart data generated successfully",
      data: {
        userId: req.user._id,
        timestamp: new Date(),
        chartData: parsedData,
      },
    });
  } catch (error) {
    if (error instanceof BadRequestError) {
      throw error;
    }
    throw new BadRequestError(error.message || "Failed to generate chart data");
  }
};
