// utils/huggingFaceClient.js
import { HfInference } from "@huggingface/inference";

const hf = new HfInference(process.env.HF_API_KEY);

// MindMate system prompt
const SYSTEM_PROMPT = `You are MindMate AI, a friendly mental health assistant. Offer empathetic, positive guidance to help users manage anxiety, stress, and wellbeing. Never give medical prescriptions. Always respond calmly and respectfully.`;

// Mock AI responses when HF is unavailable
const MOCK_RESPONSES = [
  "That sounds like you're dealing with a lot right now. Try taking some deep breaths and focus on what you can control. Remember, it's okay to ask for help when you need it.",
  "Anxiety is a natural feeling, but remember it's temporary. Consider engaging in activities you enjoy or talking to someone you trust about how you're feeling.",
  "I hear you. Stress can be overwhelming. Have you tried taking a short walk, practicing meditation, or spending time in nature? These can help calm your mind.",
  "It's great that you're reaching out. Remember to be kind to yourself. Consider breaking down your worries into manageable steps.",
  "Thank you for sharing. Your feelings are valid. Try practicing self-care today - whether that's rest, exercise, or connecting with loved ones.",
];

/**
 * Call HuggingFace AI safely with retries and fallback mock responses
 * @param {string} userMessage - The user message
 * @param {string} model - HF model name (fallback to mock if unavailable)
 * @param {number} retries - Number of retry attempts (default 2)
 * @returns {Promise<string>} - AI response or mock response
 */
export const callHuggingFace = async (
  userMessage,
  model = "gpt2",
  retries = 2,
  mode = "text" // "text" (textGeneration) or "chat" (conversational)
) => {
  if (!userMessage?.trim()) throw new Error("User message cannot be empty");

  console.log(`📤 Calling HuggingFace with model: ${model}`);

  // Build prompt with system instruction
  const fullPrompt = `${SYSTEM_PROMPT}\n\nUser: ${userMessage}\n\nAssistant:`;

  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      console.log(`⏳ Attempt ${attempt}/${retries}... (mode=${mode})`);

      let aiMessage = null;

      if (mode === "chat") {
        // Use the conversational API when model/provider expects 'conversational'
        const response = await hf.chatCompletion({
          model,
          messages: [
            { role: "system", content: SYSTEM_PROMPT },
            { role: "user", content: userMessage },
          ],
          max_tokens: 512,
        });
        aiMessage = response.choices?.[0]?.message?.content?.trim();
      } else {
        // default: text generation
        const response = await hf.textGeneration({
          model,
          inputs: fullPrompt,
          parameters: {
            max_new_tokens: 256,
            temperature: 0.7,
            top_p: 0.95,
            do_sample: true,
            return_full_text: false,
          },
        });
        aiMessage = response?.generated_text?.trim();
      }

      if (!aiMessage) throw new Error("No response generated from AI");

      console.log(`✅ HuggingFace response received successfully (mode=${mode})`);
      return aiMessage;

    } catch (err) {
      console.error(`❌ HuggingFace AI Error (attempt ${attempt}/${retries}):`, {
        message: err.message,
        status: err.status,
        statusCode: err.statusCode,
        code: err.code,
      });

      if (attempt === retries) {
        console.warn(`⚠️ All HF attempts failed. Falling back to mock response.`);
        // Return a random mock response on final failure
        const mockResponse = MOCK_RESPONSES[Math.floor(Math.random() * MOCK_RESPONSES.length)];
        return mockResponse;
      }
      // Wait before retry with exponential backoff
      await new Promise(resolve => setTimeout(resolve, 1000 * attempt));
    }
  }
};
