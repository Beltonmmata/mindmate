import express from "express";
import dotenv from "dotenv";
import "express-async-errors";
//import cors from "cors";
import morgan from "morgan";
import helmet from "helmet";
import xss from "xss-clean";
import rateLimit from "express-rate-limit";
import compression from "compression";
import mongoose from "mongoose";
import cookieParser from "cookie-parser";

import authRoutes from "./routes/authRoutes.js";
import therapistRoutes from "./routes/therapistRoutes.js";

import notFound from "./middleware/not-found.js";
import errorHandlerMiddleware from "./middleware/error-handler.js";

import { redis } from "./config/redis.js";

// Load env variables early
dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// ----- CORE MIDDLEWARES -----
app.use(express.json());
app.use(cookieParser());
//i have avoided cors untill i finish development porocess
// app.use(
//   cors({
//     origin: ["http://localhost:5173"], // update with your frontend
//     credentials: true,
//   })
// );
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

// ----- ERROR MIDDLEWARES -----
app.use(notFound);
app.use(errorHandlerMiddleware);

// ----- SERVER START -----
const startServer = async () => {
  try {
    // MongoDB connection
    await mongoose.connect(process.env.MONGO_URI);
    console.log("✅ MongoDB connected");

    // Redis connection
    //console.log("🔍 Redis URL:", process.env.UPSTASH_REDIS_REST_URL);
    //await redis.connect();
    // Test Redis connection (Upstash is stateless)
    const pong = await redis.ping();
    console.log("✅ Redis connected:", pong);
    console.log("✅ Redis connected");

    // Start express server
    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
    });
  } catch (error) {
    console.error("❌ Server startup error:", error);
    process.exit(1);
  }
};

startServer();
