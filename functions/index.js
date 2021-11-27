const functions = require("firebase-functions");
const { v4: uuidv4 } = require("uuid");
const admin = require("./firebase_");
const sendNotificationToAllUserHttpFunction = require("./src/https/send_notification_to_all_user_http_funtion");
const onOrderStatusChangedFunction = require("./src/reactive/on_order_status_changed_function");
const OnNewOrderCreatedUpdateShopStat = require("./src/reactive/on_new_order_created_update_shop_stat_function");

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
  .onUpdate(OnNewOrderCreatedUpdateShopStat);

exports.OnOrderStatusChange = functions.firestore
  .document("orders/{ordersID}")
  .onUpdate(onOrderStatusChangedFunction);

exports.sendOutNotificationToEveryOne = functions.https.onRequest(
  sendNotificationToAllUserHttpFunction
);
