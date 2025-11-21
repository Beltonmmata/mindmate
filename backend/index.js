import express from "express";
import dotenv from "dotenv";
import "express-async-errors";
import morgan from "morgan";
import helmet from "helmet";
import xss from "xss-clean";
import rateLimit from "express-rate-limit";
import compression from "compression";
import mongoose from "mongoose";
import cookieParser from "cookie-parser";
import http from "http";
import { Server } from "socket.io";

import authRoutes from "./routes/authRoutes.js";
import therapistRoutes from "./routes/therapistRoutes.js";
import aiChatRoutes from "./routes/aiChatRoutes.js";
import chartAIRoutes from "./routes/chartAIRoutes.js";
import insightsAnalyticsRoutes from "./routes/insightsAnalyticsRoutes.js";

import notFound from "./middleware/not-found.js";
import errorHandlerMiddleware from "./middleware/error-handler.js";

import { redis } from "./config/redis.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// ----- CORE MIDDLEWARES -----
app.use(express.json());
app.use(cookieParser());
// i'll update CORS when frontend is ready
// import cors from "cors";
// app.use(cors({ origin: ["http://localhost"], credentials: true }));

app.use(helmet());
app.use(xss());
app.use(morgan("dev"));
app.use(compression());
app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000, // 15 min
    max: 100,
    message: "Too many requests, please try again later.",
  })
);

// ----- ROUTES -----
app.get("/", (req, res) => {
  res.send(`
    <h1>🧠 MindMate Mental Wellness API</h1>
    <p>Status: <strong>Running</strong></p>
  `);
});

app.use("/api/auth", authRoutes);
app.use("/api/therapists", therapistRoutes);
app.use("/api/ai-chat", aiChatRoutes);
app.use("/api/chart-ai", chartAIRoutes);
app.use("/api/insights", insightsAnalyticsRoutes);

// ----- ERROR MIDDLEWARES -----
app.use(notFound);
app.use(errorHandlerMiddleware);

// ----- SERVER SETUP -----
const startServer = async () => {
  try {
    // MongoDB connection
    await mongoose.connect(process.env.MONGO_URI);
    console.log("✅ MongoDB connected");

    // Redis connection
    const pong = await redis.ping();
    console.log("✅ Redis connected:", pong);

    // Wrap Express with HTTP server for Socket.io
    const server = http.createServer(app);

    // ----- SOCKET.IO REALTIME CHAT -----
    const io = new Server(server, {
      cors: {
        origin: "*", // update later to frontend URL
        methods: ["GET", "POST"],
      },
    });

    io.on("connection", (socket) => {
      console.log("⚡ Socket connected:", socket.id);

      // Join a private room (userId or chatId)
      socket.on("join_room", (roomId) => {
        socket.join(roomId);
        console.log(`User ${socket.id} joined room ${roomId}`);
      });

      // Handle sending messages (user ↔ therapist or user ↔ AI)
      socket.on("send_message", async (data) => {
        // data = { senderId, receiverId, text }
        console.log("Message:", data);

        // Optionally save to MongoDB
        // await Message.create({ ...data, timestamp: new Date() });

        // Emit to the receiver’s room
        io.to(data.receiverId).emit("receive_message", data);

        // Example: AI integration hook
        if (data.receiverId === "ai") {
          const aiResponse = await generateAIResponse(data.text);
          io.to(data.senderId).emit("receive_message", {
            senderId: "ai",
            receiverId: data.senderId,
            text: aiResponse,
          });
        }
      });

      socket.on("disconnect", () => {
        console.log("⚡ Socket disconnected:", socket.id);
      });
    });

    // Start server
    server.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT} with realtime support`);
    });
  } catch (error) {
    console.error("❌ Server startup error:", error);
    process.exit(1);
  }
};



startServer();
