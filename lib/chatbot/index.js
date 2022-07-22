// See https://github.com/dialogflow/dialogflow-fulfillment-nodejs
// for Dialogflow fulfillment library docs, samples, and to report issues
'use strict';
 
const functions = require('firebase-functions');
const {WebhookClient} = require('dialogflow-fulfillment');
const {Card, Suggestion} = require('dialogflow-fulfillment');

const admin = require('firebase-admin');
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: 'https://consel-me-6938bfirebaseio.com',
});
const db = admin.firestore();

var username = "John";
var psychologyName;
var condition;
 
process.env.DEBUG = 'dialogflow:debug'; // enables lib debugging statements
 
exports.dialogflowFirebaseFulfillment = functions.https.onRequest((request, response) => {
  const agent = new WebhookClient({ request, response });
  console.log('Dialogflow Request headers: ' + JSON.stringify(request.headers));
  console.log('Dialogflow Request body: ' + JSON.stringify(request.body));
  
  
  function welcome(agent) {
    agent.add(`Hi ${username} do you want to do the health screening test, to start the test please type 'do test'`);
  }
  
    function getName(agent){
  	username = agent.parameters.name;
    agent.add(`Your name is ${username}`);
  }
  
  
   function healthScreenig() {
    agent.add("Do you feel lost in interest towards any activities?");
  }
  
    function  question2a() {
    agent.add("Do you have trouble in sleeping?");
  }
  
   function  question2b() {
    agent.add("Do you have trouble in sleeping?");
  }

  function  question3a() {
    agent.add("Do you have trouble concentrating or thinking about anything other than the present worry?");
  }
  
   function  question3b() {
    agent.add("Do you have trouble concentrating or thinking about anything other than the present worry?");
  }

  function  question3c() {
    agent.add("Do you have trouble concentrating or thinking about anything other than the present worry?");
  }
  
   function  question3d() {
    agent.add("Do you have trouble concentrating or thinking about anything other than the present worry?");
  }

  function  question4a() {

    psychologyName = "Ram Charan";
    condition = 'Mental Disorder';

    db.collection('result').add({name:username,psychologyName:psychologyName,condition:condition});
    agent.add("Based on the test, seems to be like you are suffering from Mental Disorder. My advice, Dr Ram Charan is the most suitable psychologist on dealing your case.");
  }
  
   function  question4b() {
    agent.add("Based on the test result, seems to be like you are doing fine.");
  }

  function  question4c() {
    agent.add("Based on the test result, seems to be like you are doing fine.");
  }
  
   function  question4d() {
    psychologyName = "Ram Charan";
    condition = 'Mental Disorder';
    db.collection('result').add({name:username,psychologyName:psychologyName,condition:condition});
    agent.add("Based on the test, seems to be like you are suffering from Mental Disorder. My advice, Dr Ram Charan is the most suitable psychologist on dealing your case.");
  }

  function  question4e() {
    agent.add("Based on the test result, seems to be like you are doing fine.");
  }
  
   function  question4f() {
    psychologyName = "Ram Charan";
    condition = 'Mental Disorder';
    db.collection('result').add({name:username,psychologyName:psychologyName,condition:condition});
    agent.add("Based on the test, seems to be like you are suffering from Mental Disorder. My advice, Dr Ram Charan is the most suitable psychologist on dealing your case.");
  }

  function  question4g() {
    agent.add("Based on the test result, seems to be like you are doing fine.");
  }
  
   function  question4h() {
    agent.add("Did you experience a sense of impending danger, panic or doom?");
  }

  function  question5a1() {
    agent.add("Are you having the difficulty to control worry?");
  }

  function  question5a2() {
    psychologyName = "Sarah Smith";
    condition = 'Anxiety';

    db.collection('result').add({name:username,psychologyName:psychologyName,condition:condition});
    agent.add("Based on the test, seems to be like you are suffering from anxiety. My advice, Dr Sarah Smith is the most suitable psychologist on dealing your case.");
  }

  function  question5a3() {
    psychologyName = "Sarah Smith";
    condition = 'Anxiety';

    db.collection('result').add({name:username,psychologyName:psychologyName,condition:condition});
    agent.add("Based on the test, seems to be like you are suffering from anxiety. My advice, Dr Sarah Smith is the most suitable psychologist on dealing your case.");
  }



  function  question5b1() {
    agent.add("Are you feeling down lately?");
  }

  function  question5b2() {
    agent.add("Did you have recurrent thoughts of death or suicide?");
  }

  function  question5b3() {
    agent.add("Did you have recurrent thoughts of death or suicide?");
  }

  function  question6a() {
    psychologyName = "John Walker";
    condition = 'Depression';

    db.collection('result').add({name:username,psychologyName:psychologyName,condition:condition});
    agent.add("This is Serious!!! Based on the test, seems to be like you are suffering from depression. My advice, Dr John Walker is the most suitable psychologist on dealing your case.");
  }

  function  question6b() {
    psychologyName = "Ram Charan";
    condition = 'Mental Disorder';

    db.collection('result').add({name:username,psychologyName:psychologyName,condition:condition});
    agent.add("Based on the test, seems to be like you are suffering from Mental Disorder. My advice, Dr Ram Charan is the most suitable psychologist on dealing your case.");
  }

  function  question6c() {
    psychologyName = "John Walker";
    condition = 'Depression';

    db.collection('result').add({name:username,psychologyName:psychologyName,condition:condition});
    agent.add("Based on the test, seems to be like you are suffering from depression. My advice, Dr John Walker is the most suitable psychologist on dealing your case.");
  }

  function  question6d() {
    psychologyName = "John Walker";
    condition = 'Depression';

    db.collection('result').add({name:username,psychologyName:psychologyName,condition:condition});
    agent.add("This is Serious!!! Based on the test, seems to be like you are suffering from depression. My advice, Dr John Walker is the most suitable psychologist on dealing your case.");
  }

  function fallback(agent) {
    agent.add(`I didn't understand`);
    agent.add(`I'm sorry, can you try again?`);
  }

  // // Uncomment and edit to make your own intent handler
  // // uncomment `intentMap.set('your intent name here', yourFunctionHandler);`
  // // below to get this function to be run when a Dialogflow intent is matched
  // function yourFunctionHandler(agent) {
  //   agent.add(`This message is from Dialogflow's Cloud Functions for Firebase editor!`);
  //   agent.add(new Card({
  //       title: `Title: this is a card title`,
  //       imageUrl: 'https://developers.google.com/actions/images/badges/XPM_BADGING_GoogleAssistant_VER.png',
  //       text: `This is the body text of a card.  You can even use line\n  breaks and emoji! 💁`,
  //       buttonText: 'This is a button',
  //       buttonUrl: 'https://assistant.google.com/'
  //     })
  //   );
  //   agent.add(new Suggestion(`Quick Reply`));
  //   agent.add(new Suggestion(`Suggestion`));
  //   agent.setContext({ name: 'weather', lifespan: 2, parameters: { city: 'Rome' }});
  // }

  // // Uncomment and edit to make your own Google Assistant intent handler
  // // uncomment `intentMap.set('your intent name here', googleAssistantHandler);`
  // // below to get this function to be run when a Dialogflow intent is matched
  // function googleAssistantHandler(agent) {
  //   let conv = agent.conv(); // Get Actions on Google library conv instance
  //   conv.ask('Hello from the Actions on Google client library!') // Use Actions on Google library
  //   agent.add(conv); // Add Actions on Google library responses to your agent's response
  // }
  // // See https://github.com/dialogflow/fulfillment-actions-library-nodejs
  // // for a complete Dialogflow fulfillment library Actions on Google client library v2 integration sample

  // Run the proper function handler based on the matched Dialogflow intent name
  let intentMap = new Map();
  intentMap.set('Default Welcome Intent', welcome);
  intentMap.set('Default Fallback Intent', fallback);
  intentMap.set('Health Screening', healthScreenig);
  
  intentMap.set('Health Screening - no', question2a);
  intentMap.set('Health Screening - yes', question2b);

  intentMap.set('Health Screening - no - yes', question3a);
  intentMap.set('Health Screening - yes - no', question3b);
  intentMap.set('Health Screening - no - no', question3c);
  intentMap.set('Health Screening - yes - yes', question3d);

  intentMap.set('Health Screening - no - yes - yes', question4a);
  intentMap.set('Health Screening - yes - no - no', question4b);
  intentMap.set('Health Screening - no - no - yes', question4c);
  intentMap.set('Health Screening - yes - yes - no', question4d);
  intentMap.set('Health Screening - no - yes - no', question4e);
  intentMap.set('Health Screening - yes - no - yes', question4f);
  intentMap.set('Health Screening - no - no - no', question4g);
  intentMap.set('Health Screening - yes - yes - yes', question4h);

  intentMap.set('Health Screening - yes - yes - yes - yes', question5a1);

  intentMap.set('Health Screening - yes - yes - yes - yes - yes', question5a2);
  intentMap.set('Health Screening - yes - yes - yes - yes - no', question5a3);

  intentMap.set('Health Screening - yes - yes - yes - no', question5b1);

  intentMap.set('Health Screening - yes - yes - yes - no - yes', question5b2);
  intentMap.set('Health Screening - yes - yes - yes - no - no', question5b3);

  intentMap.set('Health Screening - yes - yes - yes - no - yes - yes', question6a);
  intentMap.set('Health Screening - yes - yes - yes - no - no - no', question6b);
  intentMap.set('Health Screening - yes - yes - yes - no - yes - no', question6c);
  intentMap.set('Health Screening - yes - yes - yes - no - no - yes', question6d);
  intentMap.set('Get Name', getName);

  // intentMap.set('your intent name here', yourFunctionHandler);
  // intentMap.set('your intent name here', googleAssistantHandler);
  agent.handleRequest(intentMap);
});