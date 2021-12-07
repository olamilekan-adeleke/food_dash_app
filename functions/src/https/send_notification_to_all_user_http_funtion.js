const sendNotificationToAll = require('../controllers/send_notification_all');
const functions = require("firebase-functions");

const sendNotificationToAllUserHttpFunction = async (req, res) => {
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
      functions.logger.error(error);
      res.status(400).json({
        status: "fail",
        msg: " Error Occurred!, Notification  Not Sent to all users",
      });
    }
}

module.exports = sendNotificationToAllUserHttpFunction;