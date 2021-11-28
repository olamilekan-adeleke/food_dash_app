const { v4: uuidv4 } = require("uuid");
const admin = require("../../firebase_");
const sendNotificationToUser = require("../controllers/send_notification_to_user");
const saveDataToUserNotification = require("../controllers/save_data_to_user_notification_collection");
const saveDataToRiderNotification = require("../controllers/save_data_to_rider_notification_collection.");
const incrementCompletedOrderCount = require("../controllers/incrementTotalOrderAmountCount");
// functions/src/controllers/save_data_to_rider_notification_collection..js
const getRiderFee = require("../controllers/get_rider_fee");
const updateRiderWallet = require("../controllers/update_rider_wallet");


const onOrderStatusChangedFunction = async (snapshot, context) => {
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
};


module.exports = onOrderStatusChangedFunction;