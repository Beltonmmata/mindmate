import nodemailer from "nodemailer";

export const sendEmail = async (to, subject, html) => {
  try {
    console.log("📧 Preparing to send email to:", to);

    const transporter = nodemailer.createTransport({
      host: "smtp.gmail.com",
      port: 465,
      secure: true, // true for port 465
      auth: {
        user: process.env.EMAIL_USER, // Gmail app password user
        pass: process.env.EMAIL_PASS, // MUST be Gmail App Password
      },
      tls: {
        rejectUnauthorized: false, // avoids SSL cert issues on Render
      },
    });

    const mailOptions = {
      from: `"MindMate Support" <${process.env.EMAIL_USER}>`,
      to,
      subject,
      html,
    };

    const info = await transporter.sendMail(mailOptions);
    console.log("✅ Email sent successfully:", info.messageId);

    return true;
  } catch (error) {
    console.error("❌ Email sending failed:", error);
    return false;
  }
};
