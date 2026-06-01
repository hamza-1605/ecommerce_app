'use strict';

const { GoogleAuth } = require('google-auth-library');
const path = require('path');

// Path to your Firebase service account JSON file
const auth = new GoogleAuth({
    keyFile: path.join(__dirname, '../../../../../firebase-service-account.json'),
    scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
});

// @ts-ignore
async function sendNotification({ deviceToken, title, body }) {
    if (!deviceToken) {
        console.log('=== SKIP: no deviceToken ===');
        return;
    }

    try {
        const client = await auth.getClient();
        const accessToken = await client.getAccessToken();

        const projectId = process.env.FIREBASE_PROJECT_ID;

        const response = await fetch(`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
            {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${accessToken.token}`,
                },
                body: JSON.stringify({
                    message: {
                        token: deviceToken,
                        notification: { title, body },
                    },
                }),
            }
        );

        const result = await response.text();
        console.log('FCM v1 response:', response.status, result);
    }
    catch (e) {
        console.error('sendNotification error:', e);
    }
}



module.exports = {
    // ──────────── Order Placed → notify admin ───────────────────────────
    // @ts-ignore
    async afterCreate(event) {
        try {
            const { result } = event;
            // 👇 don't notify if order is created already cancelled
            if (result.orderStatus?.toLowerCase() === 'cancelled') return;

            // Get admin user (isAdmin: true)
            const admins = await strapi.db.query('plugin::users-permissions.user').findMany({
                where: { isAdmin: true },
            });

            for (const admin of admins) {
                await sendNotification({
                    deviceToken: admin.deviceToken,
                    title: '🛒 New Order Received',
                    body: `Order #${result.documentId.substring(0, 8).toUpperCase()} has been placed`,
                });
            }
        }
        catch (e) {
            console.error('afterCreate notification error:', e);
        }
    },

    // ──────────── Order Status Changed → notify user ────────────────────
    // @ts-ignore
    async afterUpdate(event) {
        try {
            const { result } = event;

            // Fetch full order with user populated
            const order = await strapi.db.query('api::order.order').findOne({
                where: { id: result.id },
                populate: ['user'],
            });

            const status = result.orderStatus;

            if (status === 'cancelled') {
                const admins = await strapi.db.query('plugin::users-permissions.user').findMany({
                    where: { is_admin: true },
                });

                for (const admin of admins) {
                    await sendNotification({
                        deviceToken: admin.deviceToken,
                        title: '❌ Order Cancelled by User',
                        body: `Order #${result.documentId.substring(0, 8).toUpperCase()} has been cancelled by the customer`,
                    });
                }
            }

            // 👇 notify user of status change
            const deviceToken = order?.user?.deviceToken;
            if (!deviceToken || !status) return;

            const messages = {
                processing: { title: '⏳ Order Processing', body: `Your order #${result.documentId.substring(0, 8).toUpperCase()} is being processed` },
                delivered: { title: '✅ Order Delivered', body: `Your order #${result.documentId.substring(0, 8).toUpperCase()} has been delivered!` },
                cancelled: { title: '❌ Order Cancelled', body: `Your order #${result.documentId.substring(0, 8).toUpperCase()} has been cancelled` },
            };

            // @ts-ignore
            const message = messages[status.toLowerCase()];
            if (!message) return;
            await sendNotification({ deviceToken, ...message });
        }
        catch (e) {
            console.error('afterUpdate notification error:', e);
        }
    },
};