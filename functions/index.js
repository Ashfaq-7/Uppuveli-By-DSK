const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const stripe = require("stripe")(functions.config().stripe.secret);

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  // total must be in cents (example: $227.00 => 22700)
  const amount = data.amount;

  if (!amount || amount < 50) {
    throw new functions.https.HttpsError("invalid-argument", "Invalid amount");
  }

  const paymentIntent = await stripe.paymentIntents.create({
    amount,
    currency: "usd",
    automatic_payment_methods: { enabled: true },
  });

  return { clientSecret: paymentIntent.client_secret };
});
