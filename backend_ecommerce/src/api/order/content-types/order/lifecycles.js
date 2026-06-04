// @ts-nocheck
'use strict';

const { GoogleAuth } = require('google-auth-library');
const path = require('path');

// Path to your Firebase service account JSON file
const auth = new GoogleAuth({
    keyFile: path.join(__dirname, '../../../../../firebase-service-account.json'),
    scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
});

async function sendNotification({ deviceToken, title, body }) {
    try {
        const client = await auth.getClient();
        const accessToken = await client.getAccessToken();

        const projectId = process.env.FIREBASE_PROJECT_ID;

        const response = await fetch(
            `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
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
        console.error('sendNotification error:', e.message);
    }
}

async function saveNotification({ userId, title, message, orderId, type }) {
  try {
    await strapi.documents('api::notification.notification').create({
      data: {
        title,
        message,
        orderId,
        type,
        isRead: false,
        user: userId,
        publishedAt: new Date().toISOString(), // 👈 required for Strapi v5 to make it findable
      },
    });
  } catch (e) {
    console.error('saveNotification error:', e.message);
  }
}



const notifiedOrders = new Set(); // 👈 in-memory dedup
module.exports = {
    // ──────────── Order Placed → notify admin ───────────────────────────
    // @ts-ignore
    async afterCreate(event) {
        try {
            const { result } = event;
            if (result.createdAt !== result.updatedAt) return;
            
            // Duplicate Guard
            if (notifiedOrders.has(result.documentId)) return;


            notifiedOrders.add(result.documentId);
            setTimeout(() => notifiedOrders.delete(result.documentId), 10000);

            const admins = await strapi.db.query('plugin::users-permissions.user').findMany({
                where: { 
                    isAdmin: true,
                    deviceToken: { $notNull : true }
                },
            });

            for (const admin of admins) {
                await sendNotification({
                    deviceToken: admin.deviceToken,
                    title: '🛒 New Order Received',
                    body: `Order #${result.documentId.substring(0, 8).toUpperCase()} has been placed`,
                });

                // 👇 save notification for each admin
                await saveNotification({
                    userId:  admin.id,
                    title:   '🛒 New Order Received',
                    message:    `Order #${result.documentId.substring(0, 8).toUpperCase()} has been placed`,
                    orderId: result.documentId,
                    type:    'order_created',
                });
            }
        } 
        catch (e) {
            console.error('afterCreate notification error:', e.message);
        }
    },

    // ──────────── Order Status Changed → notify user ────────────────────
    async afterUpdate(event) {
        try {
            const { result, params } = event;
            const updatedFields = Object.keys(params.data || {});

            // 👇 only proceed if orderStatus was actually changed
            if (!updatedFields.includes('orderStatus')) return;

            const order = await strapi.db.query('api::order.order').findOne({
                where: { id: result.id },
                populate: ['user'],
            });

            const status = result.orderStatus?.toLowerCase();
            // notify admin only on cancellation by user
            if (status === 'cancelled') {
                const admins = await strapi.db.query('plugin::users-permissions.user').findMany({
                    where: { 
                        isAdmin: true,
                        deviceToken: { $notNull : true }
                    },
                });
                for (const admin of admins) {
                    await sendNotification({
                        deviceToken: admin.deviceToken,
                        title: '❌ Order Cancelled by User',
                        body: `Order #${result.documentId.substring(0, 8).toUpperCase()} was cancelled by the customer`,
                    });

                    // 👇 save for admin
                    await saveNotification({
                        userId:  admin.id,
                        title:   '❌ Order Cancelled by User',
                        message:    `Order #${result.documentId.substring(0, 8).toUpperCase()} was cancelled by the customer`,
                        orderId: result.documentId,
                        type:    'cancelled',
                    });
                }
            }

            // ── Notify user of status change ───────────────
            const userDeviceToken = order?.user?.deviceToken;
            const userId = order?.user?.id;

            const messages = {
                processing: { title: '⏳ Order Processing', body: `Your order #${result.documentId.substring(0, 8).toUpperCase()} is being processed` },
                delivered:  { title: '✅ Order Delivered',  body: `Your order #${result.documentId.substring(0, 8).toUpperCase()} has been delivered!` },
                cancelled:  { title: '❌ Order Cancelled',  body: `Your order #${result.documentId.substring(0, 8).toUpperCase()} has been cancelled` },
            };

            const message = messages[status];
            if (!message) return;

            if (userDeviceToken) {
                await sendNotification({ deviceToken: userDeviceToken, ...message });
            }

            // 👇 save for user regardless of whether they have a device token
            if (userId) {
                await saveNotification({
                    userId,
                    title:   message.title,
                    message: message.body,
                    orderId: result.documentId,
                    type:    'status_changed',
                });
            }

        } 
        catch (e) {
            console.error('afterUpdate notification error:', e.message);
        }
    },
};