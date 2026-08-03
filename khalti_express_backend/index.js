const express = require("express");
const cors = require("cors");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

const KHALTI_BASE_URL =
  process.env.KHALTI_BASE_URL || "https://dev.khalti.com/api/v2";
const KHALTI_SECRET_KEY = process.env.KHALTI_SECRET_KEY;

if (!KHALTI_SECRET_KEY) {
  console.warn(
    "WARNING: KHALTI_SECRET_KEY is not set. Set it in your .env file.",
  );
}

app.get("/", (req, res) => {
  res.json({status: "ok", message: "Khalti backend is running"});
});

app.post("/khalti/initiate", async (req, res) => {
  try {
    const {amount, purchase_order_id, purchase_order_name, customer_info} =
      req.body;

    if (!amount || !purchase_order_id || !purchase_order_name) {
      return res.status(400).json({error: "Missing required fields"});
    }

    const response = await fetch(`${KHALTI_BASE_URL}/epayment/initiate/`, {
      method: "POST",
      headers: {
        "Authorization": `Key ${KHALTI_SECRET_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        return_url: "https://yourapp.com/payment/callback",
        website_url: "https://yourapp.com",
        amount,
        purchase_order_id,
        purchase_order_name,
        customer_info,
      }),
    });

    const data = await response.json();
    if (!response.ok) return res.status(response.status).json(data);
    return res.status(200).json(data);
  } catch (err) {
    console.error("initiate error:", err);
    return res.status(500).json({error: err.message});
  }
});

app.post("/khalti/verify", async (req, res) => {
  try {
    const {pidx} = req.body;
    if (!pidx) return res.status(400).json({error: "pidx is required"});

    const response = await fetch(`${KHALTI_BASE_URL}/epayment/lookup/`, {
      method: "POST",
      headers: {
        "Authorization": `Key ${KHALTI_SECRET_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({pidx}),
    });

    const data = await response.json();
    if (!response.ok) return res.status(response.status).json(data);
    return res.status(200).json(data);
  } catch (err) {
    console.error("verify error:", err);
    return res.status(500).json({error: err.message});
  }
});

app.listen(PORT, () => {
  console.log(`Khalti backend listening on port ${PORT}`);
});