# f0rk_society
## RK58_sih2020
Smart India Hackathon - 2020
Name of Solution-Aharya
Round 1-

video presentation- https://drive.google.com/file/d/1bQBxwS037PqGdauF04nRaIc_dwtoIDI6/view?usp=sharing
we highly recomend to check out this short video as it show complete working of application.


Here we have tried to provide basic functionality of reporting updating the status of reports submitted by the user
we have 2 main entity in round 1
1-Aharya app(user)
2-Aharya website(Admin)

we have hosted the web-app for better experience.
		url-https://anticorruptionweb.herokuapp.com/


***Aharya App***
		

It is an cross platform application which is been build with the help of flutter. Initially it serves to to perform basic functionality of reporting a bribe and reporting 
an unusual incident.it also has additional features of reporting FIR,NCR,Filing a complaint against prison management,requesting for NOC certificate
The user can also complain for delay in action for there current complains with easy,we have also provided status function which shows the status of all the request the user 
have made and it get updated dynamically whenever the status of that report changes.

Database-Firebase

How does Aharya works ?

• Getting Started : You can either sign-up through email,Phone number,UID and password or use your Google account to sign-in.

• Update your profile :Once signup you need to update your profile with valid credentials .

• Submiting Reports : You can submit a report by clicking Bribe Reporting(on home page) ->Bribe Reporting,You can also submit the reports regarding Unusual behaviour by the professionals 
		      by clicking Bribe Reporting(on home page) -> Unusual Incident

• Viewing status of all reports : On the home screen, you will see a menu button after clicking on that there would be display of multiple options you need to select status button
                                  and then select the type of the report for which you wanna se the status.
				  ex for status of bribery report- menu(☰)->status->Bribe report

• Other functionalites : You can try Chat function,reporting FIR,NCR,Requesting NOC,Reporting Delay in action,Requesting an appointment with admin,Helpline Number(button) which have multiple Helplines





***Aharya Website***
It is Web-App made with Django which is an open source framework by Python. The web-app serves to view the data and reports submitted by the user and also change the status of  the app.The web-app shows the number of 
cases reported for that particular type.It also shows a pie-chart which is use to segregation of cases into 3 types
1.Pending cases(cases which are registered but not open)
2.in process cases(cases which are open but not given verdict)
3.Accepted cases(cases which are accepted as legit cases)
It also shows all the data which is submitted by the user in proper readable format


***Note***- if you sign up for new user then we havent added and validators for Adhar card and security code field is not added which we would add in future course once signup is done you need to login with that credentials again
***** predefine credentials- mail-hyp9820@student.sfit.ac.in
			     pass-12345678 
How does Aharya Web-App ?

• Getting Started : You can either sign-in with predfine credential given by Govt or else you can signup with your details.

• Viewing Reports : You can view all the reports with their unique id on home screen you select the type of report from top right of the navbar

• Update status : You can change the status of the report by selecting any of the 2 buttons(accept,reject).

• Viewing General data : On left side of the windoe you will se cumilative data of Pending,In-process,Accepted cases with userid of Admin.

• Other fun things : You can view a pie chart to understand the data more precisely.
