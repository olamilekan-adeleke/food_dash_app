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
    const itemFee = data.items_fee;
    const type = data.type;

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

    // update like count
    if (type === "food") {
      // / add order to favourite
      items.forEach(async (element) => {
        const id = element.id;
        const dataTo = {
          likes_count: admin.firestore.FieldValue.increment(1),
        };

        await addDataToPopular(id, dataTo);
      });
    }

    // update total count order count for that day
    await incrementTotalOrderCount();

    // update item fee
    await incrementTotalOrderAmountCount(itemFee);

    return Promise.resolve();
  });

exports.OnNewOrderCreatedUpdateShopStat = functions.firestore
  .document("/orders/{ordersID}")
  .onUpdate(async (snapshot, context) => {
    if (snapshot.after.data() === snapshot.before.data()) {
      return Promise.resolve();
    }

    console.log(context);

    const data = snapshot.after.data();
    const userId = data.user_details.uid;
    const orderId = data.id;
    const docId = uuidv4();
    const items = data.items;
    const itemFee = data.items_fee;
    const type = data.type;

    if (data.order_status !== "enroute") {
      return Promise.resolve();
    }

    if (type === "food") {
      // trying to update shop owner stat
      // / add order to favourite
      items.forEach(async (element) => {
        const FastFoodId = element.fast_food_id;
        const foodAmount = element.price;

        const dataTo = {
          wallet_balance: admin.firestore.FieldValue.increment(foodAmount),
        };

        await updateShopWallet(FastFoodId, dataTo);
        await updateShopTotalNumberOfSales(FastFoodId, foodAmount);
      });
    } else if (type === "market") {
      // ? to do this, first go add the fast food name and fast food id the documnet/order data
    }

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
    const riderId = data.rider_details.uid;
    const deliveryFee = data.delivery_fee;

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
    }
    // else if (orderStatus === "completed") {
    // body = "Your order has been completed. Login To confrim order!";
    // }
    else if (data.pay_status === "confrim") {
      const notificationUser = "Order has been Comfrimed by you!!";
      const notificationRider =
        "User Comfrimed order received! \nYou Will receive your pay soon.";

      const dataToSaveUser = {
        body: notificationUser,
        orderId: `${orderId}`,
        timestamp: admin.firestore.Timestamp.now(),
        userId: `${userId}`,
        id: `${docId}`,
        items: items,
      };

      const dataToSaveRider = {
        body: notificationUser,
        orderId: `${orderId}`,
        timestamp: admin.firestore.Timestamp.now(),
        userId: `${userId}`,
        id: `${docId}`,
        items: items,
      };

      // send notification to user
      await sendNotificationToUser(userId, notificationUser, sendToCustomer);

      // send notification to rider
      await sendNotificationToUser(riderId, notificationRider, sendToCustomer);

      // save notification to user
      await saveDataToUserNotification(userId, docId, dataToSaveUser)
        .then(() => {
          console.info("succesfully: saved notification data");
        })
        .catch((error) => {
          console.info("error in execution: notification not saved");
          console.log(error);
          return { msg: "error in execution: notification not saved" };
        });

      // save notification to rider
      await saveDataToRiderNotification(userId, docId, dataToSaveRider)
        .then(() => {
          console.info("succesfully: saved notification data");
        })
        .catch((error) => {
          console.info("error in execution: notification not saved");
          console.log(error);
          return { msg: "error in execution: notification not saved" };
        });

      // update completed order
      await incrementCompletedOrderCount();

      // pay rider
      const snapshot = await getRiderFee();
      const percentageFee = snapshot.data().percentage;
      const fee = (100 * percentageFee) / deliveryFee;

      await updateRiderWallet(riderId, fee);

      const nnotificationRider = `Account Credited! \nYou received a credit of NGN ${fee} `;

      await sendNotificationToUser(riderId, nnotificationRider, sendToCustomer);

      return Promise.resolve();
    } else if (data.pay_status === "cancel") {
      const notificationUser = "You marked order has Canceled!";
      const notificationRider = "User has marked order has Canceled!";

      const dataToSaveUser = {
        body: notificationUser,
        orderId: `${orderId}`,
        timestamp: admin.firestore.Timestamp.now(),
        userId: `${userId}`,
        id: `${docId}`,
        items: items,
      };

      const dataToSaveRider = {
        body: notificationUser,
        orderId: `${orderId}`,
        timestamp: admin.firestore.Timestamp.now(),
        userId: `${userId}`,
        id: `${docId}`,
        items: items,
      };

      // send notification to user
      await sendNotificationToUser(userId, notificationUser, sendToCustomer);

      // send notification to rider
      await sendNotificationToUser(riderId, notificationRider, sendToCustomer);

      // save notification to user
      await saveDataToUserNotification(userId, docId, dataToSaveUser)
        .then(() => {
          console.info("succesfully: saved notification data");
        })
        .catch((error) => {
          console.info("error in execution: notification not saved");
          console.log(error);
          return { msg: "error in execution: notification not saved" };
        });

      // save notification to rider
      await saveDataToRiderNotification(userId, docId, dataToSaveRider)
        .then(() => {
          console.info("succesfully: saved notification data");
        })
        .catch((error) => {
          console.info("error in execution: notification not saved");
          console.log(error);
          return { msg: "error in execution: notification not saved" };
        });

      return Promise.resolve();
    } else if (data.pay_status === "pending") {
      const notificationUser =
        "Rider has marked order has completed! please login to confrim";

      const dataToSave = {
        body: "Rider has marked order has completed!",
        orderId: `${orderId}`,
        timestamp: admin.firestore.Timestamp.now(),
        userId: `${userId}`,
        id: `${docId}`,
        items: items,
      };

      // send notification to user
      await sendNotificationToUser(userId, notificationUser, sendToCustomer);

      // save notification to user
      await saveDataToRiderNotification(userId, docId, dataToSave)
        .then(() => {
          console.info("succesfully: saved notification data");
        })
        .catch((error) => {
          console.info("error in execution: notification not saved");
          console.log(error);
          return { msg: "error in execution: notification not saved" };
        });

      return Promise.resolve();
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
 */
async function getRiderFee() {
  return await admin.firestore().collection("constants").doc("rider_fee").get();
}

/**
 * Add two numbers.
 * @param {riderId} userId id.
 * @param {amount} amount.
 * @return {any} any.
 */
async function updateRiderWallet(riderId, amount) {
  return await admin
    .firestore()
    .collection("rider")
    .doc(riderId)
    .update({ wallet_balance: admin.firestore.FieldValue.increment(amount) });
}

/**
 * Add two numbers.
 * @param {userId} userId id.
 * @param {docid} docId id.
 * @param {data} data data.
 * @return {any} any.
 */
async function saveDataToRiderNotification(riderId, docId, data) {
  return await admin
    .firestore()
    .collection("rider")
    .doc(riderId)
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
 * save data to firestore
 *  @param {string} path the path.
 * @param {string} data The data.
 */
async function incrementTotalOrderCount() {
  const d = new Date();

  const day = d.getDate(); // Day		[dd]	(1 - 31)
  const month = d.getMonth() + 1; // Month	[mm]	(1 - 12)
  const year = d.getFullYear(); // Year		[yyyy]

  return await admin
    .firestore()
    .collection("constants")
    .doc("metrics")
    .collection(`${year.toString()}`)
    .doc(`${month.toString()}`)
    .collection("days")
    .doc(`${day.toString()}`)
    .set(
      {
        total_order: admin.firestore.FieldValue.increment(1),
      },
      { merge: true }
    );
}

/**
 * save data to firestore
 *  @param {string} path the path.
 * @param {string} data The data.
 */
async function incrementCompletedOrderCount() {
  const d = new Date();

  const day = d.getDate(); // Day		[dd]	(1 - 31)
  const month = d.getMonth() + 1; // Month	[mm]	(1 - 12)
  const year = d.getFullYear(); // Year		[yyyy]

  return await admin
    .firestore()
    .collection("constants")
    .doc("metrics")
    .collection(`${year.toString()}`)
    .doc(`${month.toString()}`)
    .collection("days")
    .doc(`${day.toString()}`)
    .set(
      {
        total_completed_order: admin.firestore.FieldValue.increment(1),
      },
      { merge: true }
    );
}

/**
 * save data to firestore
 *  @param {string} path the path.
 * @param {string} data The data.
 */
async function incrementTotalOrderAmountCount(amount) {
  const d = new Date();

  const day = d.getDate(); // Day		[dd]	(1 - 31)
  const month = d.getMonth() + 1; // Month	[mm]	(1 - 12)
  const year = d.getFullYear(); // Year		[yyyy]

  return await admin
    .firestore()
    .collection("constants")
    .doc("metrics")
    .collection(`${year.toString()}`)
    .doc(`${month.toString()}`)
    .collection("days")
    .doc(`${day.toString()}`)
    .set(
      {
        total_amount: admin.firestore.FieldValue.increment(amount),
      },
      { merge: true }
    );
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

async function updateShopWallet(docId, data) {
  return await admin
    .firestore()
    .collection("restaurants")
    .doc(docId)
    .update(data);
}

async function updateShopTotalNumberOfSales(docId, amount) {
  const d = new Date();

  const day = d.getDate();
  const month = d.getMonth() + 1; // Since getMonth() returns month from 0-11 not 1-12
  const year = d.getFullYear();
  var _day = d.getDay();
  const weekOfMonth = Math.ceil((day - 1 - _day) / 7) + 1;

  return await admin
    .firestore()
    .collection("restaurants")
    .doc(docId)
    .collection("stat")
    .doc(year.toString())
    .collection("per_month_stat")
    .doc(month.toString())
    .set(
      {
        month_total_sales: admin.firestore.FieldValue.increment(1),
        [`week_${weekOfMonth}_total_sales`]:
          admin.firestore.FieldValue.increment(1),
        [`day_${day}_total_sales`]: admin.firestore.FieldValue.increment(1),

        // for amount sold
        month_total_amount: admin.firestore.FieldValue.increment(amount),
        [`week_${weekOfMonth}_total_amount`]:
          admin.firestore.FieldValue.increment(amount),
        [`day_${day}_total_amount`]:
          admin.firestore.FieldValue.increment(amount),
      },
      { merge: true }
    );
  // .update(data);
}
