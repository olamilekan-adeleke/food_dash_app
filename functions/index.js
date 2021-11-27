const functions = require("firebase-functions");
const { v4: uuidv4 } = require("uuid");
const admin = require("./firebase_");

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

