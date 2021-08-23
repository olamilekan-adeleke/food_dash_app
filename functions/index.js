/** @format */

const functions = require("firebase-functions");
const { v4: uuidv4 } = require("uuid");
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
      sendToCustomer
    );
    await sendNotificationToUser(
      "riders",
      "A New Order Was Just Made!. Login to accept order",
      sendToCustomer
    );

    // / update user noticfication
    await saveDataToUserNotification(userId, docId, dataToSave)
      .then(() => {
        console.info("succesfully: saved notification data");
      })
      .catch((error) => {
        console.info("error in execution: notification not saved");
        console.log(error);
        return { msg: "error in execution: notification not saved" };
      });

    // / add order to favourite
    items.forEach(async (element) => {
      const id = element.id;
      const dataTo = {
        likes_count: admin.firestore.FieldValue.increment(1),
      };

      await addDataToPopular(id, dataTo);
    });

    return Promise.resolve();
  });

exports.OnOrderStatusChange = functions.firestore
  .document("orders/{ordersID}")
  .onUpdate(async (snapshot, context) => {
    console.log(context);
    const data = snapshot.after.data();
    const orderStatus = data.order_status;

    const userId = data.user_details.uid;
    const orderId = data.id;
    const docId = uuidv4();
    const items = data.items;

    let body;

    const sendToCustomer = {
      data_to_send: "msg_from_the_cloud",
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      order_id: `${orderId}`,
    };

    if (orderStatus === "accepted") {
      body = "Your order has been accepted by a rider!";
    } else if (orderStatus === "processing") {
      body =
        "Resturant's has received your order and have started working " +
        " on it. \nRider is on his way to pick up your order!";
    } else if (orderStatus === "enroute") {
      body =
        "Your order has been pickup by the rider. Rider has " +
        "picked up your order and is now enroute to your location";
    } else if (orderStatus === "completed") {
      body = "Your order has been completed. Have a great meal!";
    }

    const dataToSave = {
      body: body,
      orderId: `${orderId}`,
      timestamp: admin.firestore.Timestamp.now(),
      userId: `${userId}`,
      id: `${docId}`,
      items: items,
    };

    // send out notifications
    await sendNotificationToUser(userId, body, sendToCustomer);

    // update user noticfication
    await saveDataToUserNotification(userId, docId, dataToSave)
      .then(() => {
        console.info("succesfully: saved notification data");
      })
      .catch((error) => {
        console.info("error in execution: notification not saved");
        console.log(error);
        return { msg: "error in execution: notification not saved" };
      });

    return Promise.resolve();
  });

exports.sendOutNotificationToEveryOne = functions.https.onRequest(
  async (req, res) => {
    const { heading, body } = req.body;

    const payloadSetting = {
      data_to_send: "msg_from_the_cloud",
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    };

    try {
      await sendNotificationToAll(heading, body, payloadSetting);
      res
        .status(200)
        .json({ status: "success", msg: "Notification Sent to all users" });
    } catch (error) {
      console.log(error);
      res.status(400).json({
        status: "fail",
        msg: " Error Occurred!, Notification  Not Sent to all users",
      });
    }
  }
);

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
    .collection("food_items")
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
      return { msg: "error in execution: notification not sent" };
    });
}

/**
 * Add two numbers.
 * @param {userId} userId id.
 * @param {heading} heading heading.
 * @param {data} data data.
 * @return {any} any.
 */
async function sendNotificationToAll(heading, body, data) {
  const payload = {
    notification: {
      title: heading,
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
    .sendToTopic("users", payload, options)
    .then(() => {
      console.info(
        "function executed succesfully: sent notification to all user"
      );
      // return {msg: "function executed succesfully"};
    })
    .catch((error) => {
      console.info("error in execution: notification not sent");
      console.log(error);
      return { msg: "error in execution: notification not sent" };
    });
}
