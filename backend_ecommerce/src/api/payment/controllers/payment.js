// @ts-nocheck
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

module.exports = {
  async createIntent(ctx) {
    try {
      const { amount, currency = 'pkr' } = ctx.request.body;

      if (!amount || amount <= 0) {
        return ctx.badRequest('Invalid amount');
      }

      const paymentIntent = await stripe.paymentIntents.create({
        amount:   amount * 100,   // Stripe uses smallest currency unit (paisa)
        currency: currency,
        automatic_payment_methods: {
          enabled: true,
        },
      });

      ctx.body = {
        clientSecret:    paymentIntent.client_secret,
        paymentIntentId: paymentIntent.id,
      };
    } 
    catch (error) {
      ctx.badRequest(error.message);
    }
  },
};