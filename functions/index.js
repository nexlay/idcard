const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.notificationFavorites=functions.firestore.document("idcard_users/{idcard_usersId}/favorites/{favoritesId}")
    .onCreate((change, context) => {

        const newDoc = change.data();
        const userToken = newDoc.token;



        const notificationContent = {
            notification: {
                title: 'You have a new request!',
                body: 'To check open the app.',
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };
return admin.messaging().sendToDevice(userToken, notificationContent)
            .then(function (result) {
                console.log('Notification sent!');
                console.log(result.results[0].error);
                console.log(result.results[1].error);
                return null;
            })
            .catch(function (error) {
                console.log('Notification sent failed',error);
                return null;
           });
    });

