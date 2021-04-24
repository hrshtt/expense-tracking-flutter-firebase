const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.addPinAuth = functions
  .region("asia-south1")
  .https.onCall(async (data, context) => {
    const existingClaims = await admin
      .auth()
      .getUser(context.auth.uid)
      .then((user) => {
        return user.customClaims;
      });

    const pinAuth = await db
      .collection("finalAccessPins")
      .doc(context.auth.uid)
      .get()
      .then((snapshot) => {
        snapshot.data().pin;
        return snapshot.data().pin === data.pin;
      })
      .catch((err) => {
        functions.logger.error(err);
        // message = "Problem Accessing Database Pin";
        return false;
      });

    if (!("pinAuth" in existingClaims)) {
      await db
        .collection("user-claims")
        .doc(context.auth.uid)
        .set({
          pinAuth: pinAuth && !data.reset,
          counter: pinAuth ? 0 : 1,
          lastAuthChange: admin.firestore.Timestamp.now(),
        });

      await admin
        .auth()
        .setCustomUserClaims(context.auth.uid, {
          pinAuth: pinAuth && !data.reset,
          counter: pinAuth ? 0 : 1,
          lastAuthChange: admin.firestore.Timestamp.now(),
        })
        .then(() => {
          const metadataRef = admin
            .database()
            .ref("metadata/" + context.auth.uid);
          // Set the refresh time to the current UTC timestamp.
          // This will be captured on the client to force a token refresh.
          return metadataRef.set({ refreshTime: new Date().getTime() });
        });
      return { pinAuth: pinAuth && !data.reset, message: "Initializing Auth." };
    }

    if (existingClaims["counter"] >= 3) {
      const time_diff =
        Date.now() - existingClaims["lastAuthChange"]["_seconds"];

      if (time_diff >= 1800) {
        await db
          .collection("user-claims")
          .doc(context.auth.uid)
          .set({
            pinAuth: pinAuth,
            counter: pinAuth ? 0 : 1,
            lastAuthChange: admin.firestore.Timestamp.now(),
          });

        await admin
          .auth()
          .setCustomUserClaims(context.auth.uid, {
            pinAuth: pinAuth,
            counter: pinAuth ? 0 : 1,
            lastAuthChange: admin.firestore.Timestamp.now(),
          })
          .then(() => {
            const metadataRef = admin
              .database()
              .ref("metadata/" + context.auth.uid);
            // Set the refresh time to the current UTC timestamp.
            // This will be captured on the client to force a token refresh.
            return metadataRef.set({ refreshTime: new Date().getTime() });
          });
        return { pinAuth: pinAuth, message: "Resetting Auth State." };
      } else {
        return { pinAuth: false, message: "Wait for cooldown." };
      }
    } else {
      await db
        .collection("user-claims")
        .doc(context.auth.uid)
        .set({
          pinAuth: pinAuth && !data.reset,
          counter: pinAuth && !data.reset ? 0 : existingClaims["counter"] + 1,
          lastAuthChange: admin.firestore.Timestamp.now(),
        });

      await admin
        .auth()
        .setCustomUserClaims(context.auth.uid, {
          pinAuth: pinAuth && !data.reset,
          counter: pinAuth && !data.reset ? 0 : existingClaims["counter"] + 1,
          lastAuthChange: admin.firestore.Timestamp.now(),
        })
        .then(() => {
          const metadataRef = admin
            .database()
            .ref("metadata/" + context.auth.uid);
          // Set the refresh time to the current UTC timestamp.
          // This will be captured on the client to force a token refresh.
          return metadataRef.set({ refreshTime: new Date().getTime() });
        });
      return {
        pinAuth: pinAuth && !data.reset,
        message: pinAuth && !data.reset ? "Amazing, YOU DID IT!." : "KYS.",
      };
    }
  });

exports.scheduledUnauthPin = functions
  .region("asia-south1")
  .pubsub.schedule("every 30 minutes")
  .onRun(async (context) => {


    await admin
      .firestore()
      .collection("finalAccessPins")
      .get()
      .then((querySnapshot) => {
        querySnapshot.forEach(async (doc) => {

          await db.collection("user-claims").doc(doc.id).set({
            pinAuth: false,
            counter: 0,
            lastAuthChange: admin.firestore.Timestamp.now(),
          });

          await admin
            .auth()
            .setCustomUserClaims(doc.id, {
              pinAuth: false,
              counter: 0,
              lastAuthChange: admin.firestore.Timestamp.now(),
            })
            .then(() => {
              const metadataRef = admin.database().ref("metadata/" + doc.id);
              // Set the refresh time to the current UTC timestamp.
              // This will be captured on the client to force a token refresh.
              return metadataRef.set({ refreshTime: new Date().getTime() });
            })
            .catch((error) => {
              console.log(error);
            });
        });
      })
      .catch((err) => {
        functions.logger.error(err);
        throw new functions.https.HttpsError(
          "internal",
          "The User is not Authenticated"
        );
      });
    return null;
  });
