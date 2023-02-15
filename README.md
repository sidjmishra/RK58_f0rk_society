# f0rk_society
## RK58_sih2020
Smart India Hackathon - 2020
Name of Solution-Aharya
Database - Firebase
user app = Dart(flutter)
admin web-app = Python-Django
admin app = Dart(flutter)

***note***-this repo consist of multiple branches and each branch is been associated with our main entities. ex app branch hass the code for user application 

This description shows our implementation till round 3

Here we have tried to provide basic functionality of reporting updating the status of reports submitted by the user
we have 3 main entity 
1-Aharya app(user)
2-Aharya website(Admin)
3.Aharya app(admin)

***Aharya App****


It is an cross platform application which is been build with the help of flutter. Initially it serves to to perform basic functionality of reporting a bribe and reporting 
an unusual incident.it also has additional features of reporting FIR,NCR,Filing a complaint against prison management,requesting for NOC certificate
The user can also complain for delay in action for there current complains with easy,we have also provided status function which shows the status of all the request the user 
have made and it get updated dynamically whenever the status of that report changes.

***Key Features***
1. Quick reporting of bribe with the help of immutable decentralized system.

we have use most mordern technology to store the data and try to implement minimal steps to report a bribe. we have store evidence's on ipfs and there Hash on Ethereum Rinkby test network.The copy of this image link is stored
in our cloud data base (EvidenceLinks database) they are been segregated with the help of UID given to every report
Code Link: https://github.com/sidjmishra/RK58_f0rk_society/tree/ipfs-webapp


2.One Click reporting for emergencies.

With our wow feature named Hot reporting if user is stuck in some unwanted situation and he wants to report a bribe he can do that with a click and all the data would be stored securly with the current time stamp from the user when video was recorded soo the authenticity 
of data is maintained
Code Link: https://github.com/sidjmishra/RK58_f0rk_society/blob/app/lib/views/HotReporting/hotReporting.dart

3. Live instantaneous interaction

One of our key feature called as Aharya Stream. It supports live streaming of the videos from the admin to the user which can be useful to stream the live court cases of the use, so the user physically presence is not required in the court. It also supports video call feature upto 4 users.
Code Link: https://github.com/sidjmishra/RK58_f0rk_society/tree/app/lib/views/LiveStream


How does Aharya works ?

• Getting Started : You can either sign-up through email,Phone number,UID and password or use your Google account to sign-in.

• Update your profile :Once signup you need to update your profile with valid credentials with adhar card(as we didnt have uid database access soo we couldnt implement the otp verification of registered number).

• Submiting Reports : You can submit a report by clicking Bribe Reporting(on home page) ->Bribe Reporting,You can also submit the reports regarding Unusual behaviour by the professionals 
		      by clicking Bribe Reporting(on home page) -> Unusual Incident
		      or by just clicking on ***Hot reporting*** button

• Viewing status of all reports : On the home screen, you will see a menu button after clicking on that there would be display of multiple options you need to select status button
                                  and then select the type of the report for which you wanna se the status.
				  ex for status of bribery report- menu(☰)->status->Bribe report

• Other functionalites : You can try Chat function,reporting FIR,NCR,Requesting NOC,Reporting Delay in action,Requesting an appointment with admin,Helpline Number(button) which have multiple Helplines



**************Aharya Website*******************
It is Web-App made with Django which is an open source framework by Python. The web-app serves to view the data and reports submitted by the user and also change the status of  the app.The web-app shows the number of 
cases reported for that particular type.It also shows a pie-chart which is use to segregation of cases into 3 types
1.Pending cases(cases which are registered but not open)
2.in process cases(cases which are open but not given verdict)
3.Accepted cases(cases which are accepted as legit cases)
It also shows all the data which is submitted by the user in proper readable format
we have also use the implementation of various graphs soo that data can be visualize properly.


*****Note- if you sign up for new user then we havent added and validators for Adhar card and security code field is not added which we would add in future course once signup is done you need to login with that credentials again.RTI is only working for bribery for further types it would work in future versions
How does Aharya Web-App ?

• Getting Started : You can either sign-in with predfine credential given by Govt or else you can signup with your details.

• Viewing Reports : You can view all the reports with their unique id on home screen you select the type of report from top right of the navbar

• Update status : You can change the status of the report by selecting any of the 2 buttons(accept,reject).

• Viewing General data : On left side of the windoe you will se cumilative data of Pending,In-process,Accepted cases with userid of Admin.

• Other fun things : You can view a pie chart to understand the data more precisely.


You can also view data regarding ***Hot Reporting,FIR,NCR,NOC,Delay in Action(RTI),etc***
