const functions = require("firebase-functions");
const { v4: uuidv4 } = require("uuid");
const admin = require("./firebase_");
const sendNotificationToAllUserHttpFunction = require("./src/https/send_notification_to_all_user_http_funtion");
const onOrderStatusChangedFunction = require("./src/reactive/on_order_status_changed_function");
const OnNewOrderCreatedUpdateShopStat = require("./src/reactive/on_new_order_created_update_shop_stat_function");
const onNewOrderCreated = require("./src/reactive/on_new_order_created");

exports.OnNewOrderCreated = functions.firestore
  .document("/orders/{ordersID}")
  .onCreate(onNewOrderCreated);

exports.OnNewOrderCreatedUpdateShopStat = functions.firestore
  .document("/orders/{ordersID}")
  .onUpdate(OnNewOrderCreatedUpdateShopStat);

exports.OnOrderStatusChange = functions.firestore
  .document("orders/{ordersID}")
  .onUpdate(onOrderStatusChangedFunction);

exports.sendOutNotificationToEveryOne = functions.https.onRequest(
  sendNotificationToAllUserHttpFunction
);
