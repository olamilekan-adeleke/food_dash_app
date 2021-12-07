const admin = require("../../firebase_");

const sendNotificationToAll = async (heading, body, data) => {
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
      functions.logger.log(
        "function executed succesfully: sent notification to all user"
      );
      // return {msg: "function executed succesfully"};
    })
    .catch((error) => {
      functions.logger.log("error in execution: notification not sent");
      functions.logger.error(error);
      // return { msg: "error in execution: notification not sent" };
    });
};


module.exports = sendNotificationToAll;