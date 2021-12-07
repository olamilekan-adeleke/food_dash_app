const admin = require("../../firebase_");

const sendNotificationToUser = async (userId, body, data) => {
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
      functions.logger.log("function executed succesfully: sent notification");
      // console.info("function executed succesfully: sent notification");
      // return {msg: "function executed succesfully"};
    })
    .catch((error) => {
      functions.logger.error("error in execution: notification not sent");
      functions.logger.error(error);
      // console.info("error in execution: notification not sent");
      // console.log(error);
      // return { msg: "error in execution: notification not sent" };
    });
};

module.exports = sendNotificationToUser;
