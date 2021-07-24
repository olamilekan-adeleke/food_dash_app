/** @format */

const functions = require("firebase-functions");
const {v4: uuidv4} = require("uuid");
const admin = require("firebase-admin");
admin.initializeApp();

exports.OnNewOrderCreated = functions.firestore
    .document("/orders/{ordersID}")
    .onCreate(async (snapshot, context) => {
      console.log(context);
      const data = snapshot.data();
      const userId = data.user_details.uid;
      const orderId = data.id;
      const docId = uuidv4();
      const items = data.items;

      const sendToCustomer = {
        data_to_send: "msg_from_the_cloud",
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        order_id: `${orderId}`,
      };

      const dataToSave = {
        body: "Your Order Was Succseffuly Made!",
        orderId: `${orderId}`,
        timestamp: admin.firestore.Timestamp.now(),
        userId: `${userId}`,
        id: `${docId}`,
        items: items,
      };

      // / send out notifications
      await sendNotificationToUser(
          userId,
          "Your Order Was Succseffuly Made!",
          sendToCustomer,
      );
      await sendNotificationToUser(
          "riders",
          "A New Order Was Just Made!. Login to accept order",
          sendToCustomer,
      );

      // / update user noticfication
      await saveDataToUserNotification(userId, docId, dataToSave)
          .then(() => {
            console.info("succesfully: saved notification data");
          })
          .catch((error) => {
            console.info("error in execution: notification not saved");
            console.log(error);
            return {msg: "error in execution: notification not saved"};
          });

      // / add order to favourite
      items.array.forEach(async (element) => {
        const id = element.id;
        const dataTo = {
          category: element.category,
          description: element.description,
          fast_food_name: element.fast_food_name,
          id: element.id,
          name: element.name,
          count: admin.firestore.FieldValue.increment(1),
        };

        await addDataToPopular(id, dataTo);
      });

      return null;
    });

/**
 * Add two numbers.
 * @param {userId} userId id.
 * @param {docid} docId id.
 * @param {data} data data.
 * @return {any} any.
 */
async function saveDataToUserNotification(userId, docId, data) {
  return await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .collection("notifications")
      .doc(`${docId}`)
      .set(data);
}

/**
 * Add two numbers.
 * @param {docid} docId id.
 * @param {data} data data.
 * @return {any} any.
 */
async function addDataToPopular(docId, data) {
  return await admin
      .firestore()
      .collection("popular_food")
      .doc(docId)
      .update(data);
}

/**
 * Add two numbers.
 * @param {userId} userId id.
 * @param {body} body body.
 * @param {data} data data.
 * @return {any} any.
 */
async function sendNotificationToUser(userId, body, data) {
  const payload = {
    notification: {
      title: "You got a new message!",
      body: `${body}`,
    },
    data: data,
  };

  const options = {
    priority: "high",
    timeToLive: 60 * 60 * 24,
  };

  return admin
      .messaging()
      .sendToTopic(`${userId}`, payload, options)
      .then(() => {
        console.info("function executed succesfully: sent notification");
      // return {msg: "function executed succesfully"};
      })
      .catch((error) => {
        console.info("error in execution: notification not sent");
        console.log(error);
        return {msg: "error in execution: notification not sent"};
      });
}
