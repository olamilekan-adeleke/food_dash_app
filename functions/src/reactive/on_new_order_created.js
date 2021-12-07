const { v4: uuidv4 } = require("uuid");
const admin = require("../../firebase_");
const functions = require("firebase-functions");
const sendNotificationToUser = require("../controllers/send_notification_to_user");
const saveDataToUserNotification = require("../controllers/save_data_to_user_notification_collection");
const addDataToPopular = require("../controllers/add_data_to_popular");
const incrementTotalOrderCount = require("../controllers/increment_total_order_count");
const incrementTotalOrderAmountCount = require("../controllers/increment_completed_order_count");

const onNewOrderCreated = async (snapshot, context) => {
  functions.logger.log(context);
  const data = snapshot.data();
  const userId = data.user_details.uid;
  const orderId = data.id;
  const docId = uuidv4();
  const items = data.items;
  const itemFee = data.items_fee;
  const type = data.type;

  try {
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
        functions.logger.log("succesfully: saved notification data");
      })
      .catch((error) => {
        functions.logger.error("error in execution: notification not saved");

        functions.logger.error(error);
        // return { msg: "error in execution: notification not saved" };
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
  } catch (error) {
    functions.logger.error("error in execution: onNewOrderCreated");
    functions.logger.error(error);
  }
};

module.exports = onNewOrderCreated;
