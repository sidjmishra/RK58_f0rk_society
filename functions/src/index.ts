import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const fcm = admin.messaging();
const db = admin.firestore();


export const sendToTopic = functions.firestore
  .document('PaidBribe/{bribeId}/all_data/{dataId}')
  .onCreate(async snapshot => {
    const bribe = snapshot.data();
    var i;

    const payload: admin.messaging.MessagingPayload = {
          notification: {
            title: 'New Report in Your Area!',
            body: `New Report at ${bribe.address1},${bribe.address2}`,
            icon: 'your-icon-url',
            sound: 'default',
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
          },
          data: {
            "Type" : "Background",
            "category": bribe.category.toString(),
            "address1": bribe.address1.toString(),
            "address2": bribe.address2.toString(),
            "date" : bribe.date.toString(),
            "state" : bribe.state.toString(),
            "pincode" : bribe.pincode.toString(),
            "status" : bribe.Status.toString(),
          },
        };

    console.log(bribe.pincode.toString());
    const querySnapshot = await db
       .collection('users')
       .where('pincode','==',bribe.pincode.toString()).get();
    var doc_id;
    var tokenData;
    var tok;
    if(querySnapshot != null){
    doc_id = await querySnapshot.docs.map(snap => snap.id);
        if(doc_id!=null){
            for(i=0;i< doc_id.length ;i++){
                tok = await db.collection('users').doc(`${doc_id[i]}`).get();
                if(tok !=null){
                    tokenData=tok.data();
                }
            if(tokenData != null){
                console.log(tokenData.fcmToken);
                    return fcm.sendToDevice(tokenData.fcmToken, payload);
                }
            }
        }
    }

    return null;
      });


 export const sendToDevicePaidBribe = functions.firestore
   .document('PaidBribe/{bribeId}/all_data/{dataId}')
   .onCreate(async snapshot => {


     const report = snapshot.data();
     const querySnapshot = await db
       .collection('users')
       .doc(report.uid).get();
       console.log(querySnapshot.data());
    var token;
    var tok;
    if(querySnapshot != null)
    {
    token = await querySnapshot.data();
    console.log(token);
    }
    if(token){
        tok = token.fcmToken;
        console.log(tok)
    }
     const payload: admin.messaging.MessagingPayload = {
       notification: {
         title: 'Report Submited!',
         body: `Report id: ${snapshot.id} on ${report.date}`,
         icon: 'your-icon-url',
         click_action: 'FLUTTER_NOTIFICATION_CLICK'
       },
       data: {
               "Type" : "Foreground",
             },
     };
     return fcm.sendToDevice(tok, payload);
   });

export const sendToDeviceNOC = functions.firestore
   .document('NOC/{nocId}/all_data/{dataId}')
   .onCreate(async snapshot => {


     const report = snapshot.data();
     const querySnapshot = await db
       .collection('users')
       .doc(report.uid).get();
       console.log(querySnapshot.data());
    var token;
    var tok;
    if(querySnapshot != null)
    {
    token = await querySnapshot.data();
    console.log(token);
    }
    if(token){
        tok = token.fcmToken;
        console.log(tok)
    }
     const payload: admin.messaging.MessagingPayload = {
       notification: {
         title: 'Report Submited!',
         body: `Report id: ${snapshot.id} on ${report.date}`,
         icon: 'your-icon-url',
         click_action: 'FLUTTER_NOTIFICATION_CLICK'
       },
       data: {
               "Type" : "Foreground",
             },
     };
     return fcm.sendToDevice(tok, payload);
   });

export const sendToDeviceAppointment = functions.firestore
   .document('Appointment/{nocId}/all_data/{dataId}')
   .onCreate(async snapshot => {


     const report = snapshot.data();
     console.log(report);
     const querySnapshot = await db
       .collection('users')
       .doc(report.uid).get();
       console.log(querySnapshot.data());
    var token;
    var tok;
    if(querySnapshot != null)
    {
    token = await querySnapshot.data();
    console.log(token);
    }
    if(token){
        tok = token.fcmToken;
        console.log(tok)
    }
     const payload: admin.messaging.MessagingPayload = {
       notification: {
         title: 'Appointment Request Submitted!',
         body: `Application id: ${snapshot.id} for application ${report.DetailsofAppointment} on ${report.DateofAppointment}`,
         icon: 'your-icon-url',
         click_action: 'FLUTTER_NOTIFICATION_CLICK'
       },
       data: {
               "Type" : "Foreground",
             },
     };
     return fcm.sendToDevice(tok, payload);
   });

export const sendToDeviceDelayInAction = functions.firestore
   .document('Delay%20in%20Actions/{nocId}/all_data/{dataId}')
   .onCreate(async snapshot => {


     const report = snapshot.data();
     const querySnapshot = await db
       .collection('users')
       .doc(report.uid).get();
       console.log(querySnapshot.data());
    var token;
    var tok;
    if(querySnapshot != null)
    {
    token = await querySnapshot.data();
    console.log(token);
    }
    if(token){
        tok = token.fcmToken;
        console.log(tok)
    }
     const payload: admin.messaging.MessagingPayload = {
       notification: {
         title: 'Appointment Request Submitted!',
         body: `Application id: ${snapshot.id} for report on delay of action of ${report.ApplicationType} application on ${report.DateofIssuingApplication}`,
         icon: 'your-icon-url',
         click_action: 'FLUTTER_NOTIFICATION_CLICK'
       },
       data: {
               "Type" : "Foreground",
             },
     };
     return fcm.sendToDevice(tok, payload);
   });

   export const sendToDeviceUnusualBehaviour = functions.firestore
      .document('UnusualBehaviour/{bribeId}/all_data/{dataId}')
      .onCreate(async snapshot => {


        const report = snapshot.data();
        const querySnapshot = await db
          .collection('users')
          .doc(report.uid).get();
          console.log(querySnapshot.data());
       var token;
       var tok;
       if(querySnapshot != null)
       {
       token = await querySnapshot.data();
       console.log(token);
       }
       if(token){
           tok = token.fcmToken;
           console.log(tok)
       }
        const payload: admin.messaging.MessagingPayload = {
          notification: {
            title: 'Report Submitted!',
            body: `Report id: ${snapshot.id} on ${report.date}`,
            icon: 'your-icon-url',
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
          },
          data: {
                  "Type" : "Foreground",
                },
        };
        return fcm.sendToDevice(tok, payload);
      });


export const sendToDeviceFIR_NCR = functions.firestore
   .document('FIR_NCR/{firId}/all_data/{dataId}')
   .onCreate(async snapshot => {


     const report = snapshot.data();
     const querySnapshot = await db
       .collection('users')
       .doc(report.uid).get();
       console.log(querySnapshot.data());
    var token;
    var tok;
    if(querySnapshot != null)
    {
    token = await querySnapshot.data();
    console.log(token);
    }
    if(token){
        tok = token.fcmToken;
        console.log(tok)
    }
     const payload: admin.messaging.MessagingPayload = {
       notification: {
         title: 'Report Submitted Awaiting Confirmation!',
         body: `Report id: ${snapshot.id} on ${report.date}`,
         icon: 'your-icon-url',
         click_action: 'FLUTTER_NOTIFICATION_CLICK'
       },
       data: {
               "Type" : "Foreground",
             },
     };
     return fcm.sendToDevice(tok, payload);
   });

export const sendToDeviceJail = functions.firestore
   .document('Jail%20Management/{firId}/all_data/{dataId}')
   .onCreate(async snapshot => {


     const report = snapshot.data();
     const querySnapshot = await db
       .collection('users')
       .doc(report.uid).get();
       console.log(querySnapshot.data());
    var token;
    var tok;
    if(querySnapshot != null)
    {
    token = await querySnapshot.data();
    console.log(token);
    }
    if(token){
        tok = token.fcmToken;
        console.log(tok)
    }
     const payload: admin.messaging.MessagingPayload = {
       notification: {
         title: 'Report Submitted Awaiting Confirmation!',
         body: `Report id: ${snapshot.id} for incident of ${report.IssueCategory} on ${report.DateofIncident}`,
         icon: 'your-icon-url',
         click_action: 'FLUTTER_NOTIFICATION_CLICK'
       },
       data: {
               "Type" : "Foreground",
             },
     };
     return fcm.sendToDevice(tok, payload);
   });


export const sendToDeviceHotReport = functions.firestore
   .document('Hot%20Report/{firId}/all_data/{dataId}')
   .onCreate(async snapshot => {


     const report = snapshot.data();
     const querySnapshot = await db
       .collection('users')
       .doc(report.uid).get();
       console.log(querySnapshot.data());
    var token;
    var tok;
    if(querySnapshot != null)
    {
    token = await querySnapshot.data();
    console.log(token);
    }
    if(token){
        tok = token.fcmToken;
        console.log(tok)
    }
     const payload: admin.messaging.MessagingPayload = {
       notification: {
         title: 'Report Submitted!',
         body: `Report id: ${snapshot.id} for ${report.purpose} on ${report.date}`,
         icon: 'your-icon-url',
         click_action: 'FLUTTER_NOTIFICATION_CLICK'
       },
       data: {
               "Type" : "Foreground",
             },
     };
     return fcm.sendToDevice(tok, payload);
   });
