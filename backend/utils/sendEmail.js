import nodemailer from "nodemailer";

export const sendEmail = async ({ to, subject, text, html }) => {
  try {
    console.log("📧 Preparing to send email to:", to);

    const transporter = nodemailer.createTransport({
      host: "smtp.gmail.com",
      port: 465,
      secure: true, // MUST be true for port 465
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS, // APP PASSWORD, not Gmail password
      },
      tls: {
        rejectUnauthorized: false, // helps avoid cert issues on Render
      },
    });

    const mailOptions = {
      from: `"MindMate Support" <${process.env.EMAIL_USER}>`,
      to,
      subject,
      text,
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
