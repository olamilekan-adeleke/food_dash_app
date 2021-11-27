const admin = require("../../firebase_");
const sendNotificationToUser = require("../controllers/send_notification_to_user");

const OnNewOrderCreatedUpdateShopStat = async (snapshot, context) => {
  if (snapshot.after.data() === snapshot.before.data()) {
    return Promise.resolve();
  }

  console.log(context);

  const data = snapshot.after.data();
  const userId = data.user_details.uid;
  const orderId = data.id;
  const items = data.items;
  const itemFee = data.items_fee;
  const type = data.type;

  const sendData = {
    data_to_send: "msg_from_the_cloud",
    click_action: "FLUTTER_NOTIFICATION_CLICK",
    order_id: `${orderId}`,
  };
  const notificationUser = "Order has been Comfrimed by you!!";

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
      await sendNotificationToUser(
        FastFoodId,
        `Now Order of ${element.fast_food_name} has just been made!`,
        sendData
      );
    });
  } else if (type === "market") {
    // ? to do this, first go add the fast food name and fast food id the documnet/order data
  }

  return Promise.resolve();
};

module.exports = OnNewOrderCreatedUpdateShopStat;
