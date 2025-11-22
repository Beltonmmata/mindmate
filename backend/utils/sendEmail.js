import nodemailer from "nodemailer";

export const sendEmail = async (to, subject, html) => {
  try {
    console.log("📧 Preparing to send email to:", to);

    const transporter = nodemailer.createTransport({
      host: "smtp.mailersend.net",
      port: 587,
      secure: false, // STARTTLS
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
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
