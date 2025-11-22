import { Resend } from "resend";

const resend = new Resend(process.env.RESEND_API_KEY);

export const sendEmail = async (to, subject, html) => {
  try {
    console.log("📧 Sending email to:", to);

    const response = await resend.emails.send({
      from: "MindMate <onboarding@resend.dev>", 
      to,
      subject,
      html,
    });

    console.log("✅ Email sent:", response);
    return true;
  } catch (error) {
    console.error("❌ Email send failed:", error);
    return false;
  }
};
