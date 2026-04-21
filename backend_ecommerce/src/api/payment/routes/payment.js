module.exports = {
    routes : [
        {
            method: 'POST',
            path: '/payment/create-intent',
            handler: 'payment.createIntent',
            config: {
                policies : [],
                middlewares: []
            }
        }
    ]
};