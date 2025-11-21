import { callHuggingFace } from "../utils/huggingFaceClient.js";
import { StatusCodes } from "http-status-codes";
import { BadRequestError } from "../errors/index.js";

/**
 * @desc Send message to MindMate AI and get response
 * @route POST /api/ai-chat/message
 * @access Private (authenticated users)
 */
export const sendMessage = async (req, res) => {
  const { userMessage, model } = req.body;

  // Validate input
  if (!userMessage || userMessage.trim().length === 0) {
    throw new BadRequestError("User message is required and cannot be empty");
  }

  if (userMessage.length > 2000) {
    throw new BadRequestError("Message is too long (max 2000 characters)");
  }

  try {
    // Always use gpt2 for now - it's the only model guaranteed to work
    // TODO: Switch to a better model once HF inference providers are more stable
    const selectedModel = "gpt2";
    console.log(`🤖 AI Chat: using model ${selectedModel} (ignoring client-provided model)`);
    
    const aiResponse = await callHuggingFace(userMessage, selectedModel);

    res.status(StatusCodes.OK).json({
      success: true,
      message: "Message sent successfully",
      data: {
        userMessage,
        aiResponse,
        userId: req.user._id,
        model: selectedModel,
        timestamp: new Date(),
      },
    });
  } catch (error) {
    console.error("❌ AI Controller Error:", error.message);
    throw new BadRequestError(error.message || "Failed to get AI response");
  }
};
