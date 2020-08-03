## Smart India Hackathon - 2020 Name of Solution-Aharya Database - Firebase emailid(firebase)-sidjmishra007@student.sfit.ac.in password(firebase)-siddevy@2513 This description shows our implementation till round 2

Here we have tried to provide basic functionality of reporting updating the status of reports submitted by the user. Here is one od the main entity Aharya app(user)

### Aharya App

It is an cross platform application which is been build with the help of flutter. Initially it serves to to perform basic functionality of reporting a bribe and reporting an unusual incident.it also has additional features of reporting FIR,NCR,Filing a complaint against prison management,requesting for NOC certificate The user can also complain for delay in action for there current complains with easy,we have also provided status function which shows the status of all the request the user have made and it get updated dynamically whenever the status of that report changes.

#### Some screenshots of the application
![Login SCreen](Screenshots/ss1.jpeg?raw=true) ![Signup SCreen](Screenshots/ss2.jpeg?raw=true) ![Otp verificcation](Screenshots/ss3.jpeg?raw=true)

#### Home Screen
![Home](Screenshots/ss4.jpeg?raw=true) ![Menu](Screenshots/ss5.jpeg?raw=true)

### Key Features

#### Quick reporting of bribe with the help of immutable decentralized system.

We have use most mordern technology to store the data and try to implement minimal steps to report a bribe. we have store evidence's on ipfs and there Hash on Ethereum Rinkby test network.The copy of this image link is stored in our cloud data base (EvidenceLinks database) they are been segregated with the help of UID given to every report Code Link: https://github.com/sidjmishra/RK58_f0rk_society/tree/ipfs-webapp

![Reporting](Screenshots/ss7.jpeg?raw=true) ![Reporting](Screenshots/ss8.jpeg?raw=true) ![Reporting](Screenshots/ss9.jpeg?raw=true)

#### One Click reporting for emergencies.

With our wow feature named Hot reporting if user is stuck in some unwanted situation and he wants to report a bribe he can do that with a click and all the data would be stored securly with the current time stamp from the user when video was recorded soo the authenticity of data is maintained Code Link: https://github.com/sidjmishra/RK58_f0rk_society/blob/app/lib/views/HotReporting/hotReporting.dart

![Hot Reporting](Screenshots/ss6.jpeg?raw=true)

#### Live instantaneous interaction

One of our key feature called as Aharya Stream. It supports live streaming of the videos from the admin to the user which can be useful to stream the live court cases of the use, so the user physically presence is not required in the court. It also supports video call feature upto 4 users. Code Link: https://github.com/sidjmishra/RK58_f0rk_society/tree/app/lib/views/LiveStream

![Live Stream](Screenshots/ss16.jpeg?raw=true)

#### How does Aharya works ?

• Getting Started : You can either sign-up through email,Phone number,UID and password or use your Google account to sign-in.

• Update your profile :Once signup you need to update your profile with valid credentials with adhar card(as we didnt have uid database access soo we couldnt implement the otp verification of registered number).

• Submiting Reports : You can submit a report by clicking Bribe Reporting(on home page) ->Bribe Reporting,You can also submit the reports regarding Unusual behaviour by the professionals by clicking Bribe Reporting(on home page) -> Unusual Incident or by just clicking on Hot reporting button

• Viewing status of all reports : On the home screen, you will see a menu button after clicking on that there would be display of multiple options you need to select status button and then select the type of the report for which you wanna se the status. ex for status of bribery report- menu(☰)->status->Bribe report

• Other functionalites : You can try Chat function,reporting FIR,NCR,Requesting NOC,Reporting Delay in action,Requesting an appointment with admin,Helpline Number(button) which have multiple Helplines

![Status](Screenshots/ss10.jpeg?raw=true) ![Status](Screenshots/ss11.jpeg?raw=true) ![RTI](Screenshots/ss12.jpeg?raw=true)
