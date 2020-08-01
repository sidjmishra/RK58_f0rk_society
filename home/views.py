from django.shortcuts import render, redirect
from home import templates
import pyrebase
import firebase_admin
from firebase_admin import credentials, firestore, auth, threading
from django.core.mail import send_mail
import os

config={
    'apiKey': "AIzaSyDMD127uosKN8bfmhCD_jwz_q09En2T_0g",
    'authDomain': "bribe-block.firebaseapp.com",
    'databaseURL': "https://bribe-block.firebaseio.com",
    'projectId': "bribe-block",
    'storageBucket': "bribe-block.appspot.com",
    'messagingSenderId': "883197621162",
    'appId': "1:883197621162:web:e1cb0f7c7735f6e84eb1d3",
    'measurementId': "G-GXPSH1W25J"
}

firebase = pyrebase.initialize_app(config)
authpy = firebase.auth()
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
print(BASE_DIR)
DIR=str(BASE_DIR)+'/home/assets/bribe-block-firebase-adminsdk-d9igq-1b0de61f8c.json'

cred = credentials.Certificate(f'{DIR}')
firebase_admin.initialize_app(cred)

db = firestore.client()
def login(request):

    if request.session.has_key('username'):
        return  redirect(paidBribe, user=request.session['username'])
        

    if request.method == 'POST':
        email = request.POST.get('email')
        passw = request.POST.get('pass')
        try:
            user = auth.get_user_by_email(email)
            d = user.custom_claims
            if d['admin'] == True:
                _ = authpy.sign_in_with_email_and_password(email,passw)
                request.session['username'] = user.email          
                return redirect(paidBribe, user=user.email)
        except:
            message ="You have entered invalid credentials"
            return render(request,"login.html",{"message":message})
        message ="You have entered invalid credentials"
        return render(request,"login.html",{"message":message})
    else:
        return render(request, "login.html")

def register(request):

    if request.session.has_key('username'):
        return  redirect(paidBribe, user=request.session['username'])

    if request.method == 'POST':
        first = request.POST.get('first')
        mid = request.POST.get('mid')
        last = request.POST.get('last')
        nm = first+" "+mid+" "+last
        gender = request.POST.get('gender')
        phone = request.POST.get('phone')
        email = request.POST.get('email')
        passw = request.POST.get('password')
        conf_passw = request.POST.get('password_confirm')
        addr1 = request.POST.get('address1')
        addr2 = request.POST.get('address2')
        pin = request.POST.get('pincode')
        city = request.POST.get('city')
        state = request.POST.get('state')
        idtype = request.POST.get('id-type')

        if passw == conf_passw:
            auth.create_user(display_name=nm, email=email, password=passw, phone_number="+91"+phone)
            user = auth.get_user_by_email(email)
            auth.set_custom_user_claims(user.uid, {"admin":True})
            db = firestore.client()
            db.collection(u'admins').document(email).set({
                'name':nm,
                'email':email,
                'phone_no':phone,
                'gender':gender,
                'address-line-1': addr1,
                'address-line-2': addr2,
                'pincode': pin,
                'city': city,
                'state': state,
                'id-type': idtype
            })
    return render(request, "register.html")
  
def logout(request):
    if request.session.has_key('username'):
        request.session.flush()
    else:
        pass
    return redirect(login)

def home(request, user):

    if not request.session.has_key('username'):
        return redirect(login)
    if request.session['username'] != user:
        return redirect(login)
    
    docs = db.collection(u'FIR_NCR').stream()
    list1 = []
    list2 = []
    list3 = []
    for doc in docs:
        email = db.collection(u'users').document(u'{}'.format(doc.id)).get().to_dict()['email']
        penddingSubdocs = db.collection(u'FIR_NCR').document(u'{}'.format(doc.id)).collection(u'FIR').where(u'Status',u'==',u'Pending').get()
        for subdoc in penddingSubdocs:
            list1.append((subdoc.id,doc.id,email))

        inProgressDocs = db.collection(u'FIR_NCR').document(u'{}'.format(doc.id)).collection(u'FIR').where(u'Status',u'==',u'inProgress').get()
        for subdoc in inProgressDocs:
            list2.append((subdoc.id,doc.id,email))

        assessedDocs = db.collection(u'FIR_NCR').document(u'{}'.format(doc.id)).collection(u'FIR').where(u'Status',u'==',u'Assessed').get()
        for subdoc in assessedDocs:
            list3.append((subdoc.id,doc.id,email))

    return render(request, "home.html", {"user":request.session['username'], "category":"FIR", "pending_id_list":list1, "progress_id_list":list2, "assessed_id_list":list3, "fir_active": "active", "assesedNo" : len(list3), "progressNo":len(list2), "newNo":len(list1) })

def details(request, category, user, uid, case_id):

    if not request.session.has_key('username'):
        return redirect(login)
    if request.session['username'] != user:
        return redirect(login)

    metadata = {'category':category, 'user':user, 'uid':uid, 'case_id':case_id}

    # Bride Report
    if category == "PaidBribe":
        if request.GET.get('delete')=='del':
            db.collection(category).document(uid).collection(u'all_data').document(case_id).delete()
            return redirect(paidBribe, user=user)
        if request.GET.get('accept')=='accpt':
            db.collection(category).document(uid).collection(u'all_data').document(case_id).set({
                u'Status': u'Accepted'
            }, merge=True)
            return redirect(paidBribe, user=user)
        if request.GET.get('evid')=='evidence':
            # Show Evidence
            return redirect(police)

        print("***************",category,"**************")
        doc_ref = db.collection(category).document(uid).collection(u'all_data').document(case_id)
        print(category, uid, case_id)
        doc = doc_ref.get()
        case_data = doc.to_dict()
        print(case_data)
        data = {}
        for i in sorted(case_data):
            data[i] = case_data[i]
        # print(data)
        if data['Status'] == 'Pending':
            db.collection(category).document(uid).collection(u'all_data').document(case_id).set({
                u'Status': u'In Process'
            }, merge=True)
        return render(request, "bribeDetails.html", {"user":request.session['username'], "data":data, "metadata":metadata})

    # FIR
    if category == "FIR":
        category = "FIR_NCR"
        if request.GET.get('delete')=='del':
            db.collection(category).document(uid).collection(u'FIR').document(case_id).delete()
            return redirect(home, user=user)
        if request.GET.get('accept')=='accpt':
            db.collection(category).document(uid).collection(u'FIR').document(case_id).set({
                u'Status': u'Assessed'
            }, merge=True)
            return redirect(home, user=user)

        print("***************",category,"**************")
        doc_ref = db.collection(category).document(uid).collection(u'FIR').document(case_id)
        doc = doc_ref.get()
        case_data = doc.to_dict()
        data = {}
        for i in sorted(case_data):
            data[i] = case_data[i]
        # print(data)
        if data['Status'] == 'Pending':
            db.collection(category).document(uid).collection(u'FIR').document(case_id).set({
                u'Status': u'inProgress'
            }, merge=True)
        return render(request, "details.html", {"user":request.session['username'], "data":data, "metadata":metadata})

    # NCR
    if category == "NCR":
        category = "FIR_NCR"
        if request.GET.get('delete')=='del':
            db.collection(category).document(uid).collection(u'NCR').document(case_id).delete()
            return redirect(home, user=user)
        if request.GET.get('accept')=='accpt':
            db.collection(category).document(uid).collection(u'NCR').document(case_id).set({
                u'Status': u'Assessed'
            }, merge=True)
            return redirect(home, user=user)

        print("***************",category,"**************")
        doc_ref = db.collection(category).document(uid).collection(u'NCR').document(case_id)
        doc = doc_ref.get()
        case_data = doc.to_dict()
        data = {}
        for i in sorted(case_data):
            data[i] = case_data[i]
        # print(data)
        if data['Status'] == 'Pending':
            db.collection(category).document(uid).collection(u'NCR').document(case_id).set({
                u'Status': u'inProgress'
            }, merge=True)
        return render(request, "details.html", {"user":request.session['username'], "data":data, "metadata":metadata})

    # NOC
    if category == "NOC":
        if request.GET.get('delete')=='del':
            db.collection(category).document(uid).collection(u'all_data').document(case_id).delete()
            return redirect(noc, user=user)
        if request.GET.get('accept')=='accpt':
            db.collection(category).document(uid).collection(u'all_data').document(case_id).set({
                u'Status': u'Accepted'
            }, merge=True)
            return redirect(noc, user=user)
        print("***************",category,"**************")
        doc_ref = db.collection(category).document(uid).collection(u'all_data').document(case_id)
        doc = doc_ref.get()
        case_data = doc.to_dict()
        data = {}
        for i in sorted(case_data):
            data[i] = case_data[i]
        # print(data)
        if data['Status'] == 'Pending':
            db.collection(category).document(uid).collection(u'all_data').document(case_id).set({
                u'Status': u'In Process'
            }, merge=True)
        return render(request, "nocDetails.html", {"user":request.session['username'], "data":data, "metadata":metadata})

    # Unusual Behaviour
    if category == "UnusualBehaviour":
        if request.GET.get('delete')=='del':
            db.collection(category).document(uid).collection(u'all_data').document(case_id).delete()
            return redirect(unusualBehaviour, user=user)
        if request.GET.get('accept')=='accpt':
            db.collection(category).document(uid).collection(u'all_data').document(case_id).set({
                u'Status': u'Accepted'
            }, merge=True)
            return redirect(unusualBehaviour, user=user)

        print("***************",category,"**************")
        doc_ref = db.collection(category).document(uid).collection(u'all_data').document(case_id)
        doc = doc_ref.get()
        case_data = doc.to_dict()
        data = {}
        for i in sorted(case_data):
            data[i] = case_data[i]
        # print(data)
        if data['Status'] == 'Pending':
            db.collection(category).document(uid).collection(u'all_data').document(case_id).set({
                u'Status': u'In Process'
            }, merge=True)
        return render(request, "ubDetails.html", {"user":request.session['username'], "data":data, "metadata":metadata})
    
def paidBribe(request, user):

    if not request.session.has_key('username'):
        return redirect(login)
    if request.session['username'] != user:
        return redirect(login)

    docs = db.collection(u'PaidBribe').stream()
    list1 = []
    list2 = []
    list3 = []
    total_cases = 0
    pending_cases = 0
    for doc in docs:
        email = db.collection(u'users').document(u'{}'.format(doc.id)).get().to_dict()['email']
        pendingSubdocs = db.collection(u'PaidBribe').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'Pending').get()
        for subdoc in pendingSubdocs:
            list1.append((subdoc.id,doc.id, email))

        inProcessDocs = db.collection(u'PaidBribe').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'In Process').get()
        for subdoc in inProcessDocs:
            list2.append((subdoc.id,doc.id, email))

        acceptedDocs = db.collection(u'PaidBribe').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'Accepted').get()
        for subdoc in acceptedDocs:
            list3.append((subdoc.id,doc.id, email))

    pending_cases = len(list1)
    inprocess_cases = len(list2)
    accepted_cases = len(list3)
    total_cases = (len(list1)+len(list2)+len(list3))

    return render(request, "paidBribe.html", {"user":request.session['username'], "pending_cases":pending_cases, "inprocess_cases":inprocess_cases, "accepted_cases":accepted_cases, "total_cases":total_cases, "category":"PaidBribe", "bribe_active": "active", "pending":list1, "inprocess":list2, "accepted":list3})

# def hotReport(request, user):

#     if not request.session.has_key('username'):
#         return redirect(login)
#     if request.session['username'] != user:
#         return redirect(login)

#     docs = db.collection(u'Hot Report').stream()
#     lst = []
#     for doc in docs:

#         email = db.collection(u'users').document(u'{}'.format(doc.id)).get().to_dict()['email']
#         # print(email)
#         reports = db.collection(u'Hot Report').document(u'{}'.format(doc.id)).collection(u'all_data').get()
#         for report in reports:
#             lst.append((report.id,doc.id, email, report.to_dict()))
#             print(report.to_dict())

#     return render(request, "hotReport.html",  {"user":request.session['username'], "category":"hot", "hot_active": "active", "data":lst})

def rti(request, user):
    if not request.session.has_key('username'):
        return redirect(login)
    if request.session['username'] != user:
        return redirect(login)

    if request.method == 'POST':
        case_id = request.POST.get('id')
        rid = request.POST.get('rdocid')
        uid = request.POST.get('udocid')
        msg = request.POST.get('message')
        email = request.POST.get('email')
        send_mail('Delay in Actions Response - {}'.format(case_id),
            'Respected {},\nThis is the response regarding your delay in action report having Case ID: {},\n{}\nThank you for your co-operation.\nPlease do not reply to this email.'.format(email, case_id,msg),
            'aharyaindia@gmail.com', ['{}'.format(email)], fail_silently = False)
        db.collection(u'Delay in Actions').document(uid).collection(u'all_data').document(rid).set({
                u'Status': u'Responded'
        }, merge=True)

        return redirect(rti, user=user)

    docs = db.collection(u'Delay in Actions').stream()
    lst = []
    for doc in docs:
         reports = db.collection(u'Delay in Actions').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'Pending').get()
         for report in reports:
            dic = report.to_dict()
            if dic['ApplicationType'] == 'Bribe Report':
                category = 'PaidBribe'
            elif dic['ApplicationType'] == 'FIR Reporting':
                category = 'FIR'
            elif dic['ApplicationType'] == 'NOC':
                category = 'NOC'
            elif dic['ApplicationType'] == 'Hot Bribe Reporting':
                category = 'Hot Report'
            else:
                category = 'Appointment'
            
            lst.append((report.id, doc.id, report.to_dict(), category))
             
    return render(request, "rti.html", {"user":request.session['username'], "rti_active":"active", "data":lst})
    
def unusualBehaviour(request, user):
    if not request.session.has_key('username'):
        return redirect(login)
    if request.session['username'] != user:
        return redirect(login)

    docs = db.collection(u'UnusualBehaviour').stream()
    list1 = []
    list2 = []
    list3 = []
    total_cases = 0
    pending_cases = 0
    for doc in docs:
        email = db.collection(u'users').document(u'{}'.format(doc.id)).get().to_dict()['email']
        pendingSubdocs = db.collection(u'UnusualBehaviour').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'Pending').get()
        for subdoc in pendingSubdocs:
            list1.append((subdoc.id,doc.id, email))

        inProcessDocs = db.collection(u'UnusualBehaviour').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'In Process').get()
        for subdoc in inProcessDocs:
            list2.append((subdoc.id,doc.id, email))

        acceptedDocs = db.collection(u'UnusualBehaviour').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'Accepted').get()
        for subdoc in acceptedDocs:
            list3.append((subdoc.id,doc.id, email))

    pending_cases = len(list1)
    inprocess_cases = len(list2)
    accepted_cases = len(list3)
    total_cases = (len(list1)+len(list2)+len(list3))

    return render(request, "unusualBehaviour.html", {"user":request.session['username'], "pending_cases":pending_cases, "inprocess_cases":inprocess_cases, "accepted_cases":accepted_cases, "total_cases":total_cases, "category":"UnusualBehaviour", "bribe_active": "active", "pending":list1, "inprocess":list2, "accepted":list3})

def noc(request, user):

    if not request.session.has_key('username'):
        return redirect(login)
    if request.session['username'] != user:
        return redirect(login)
    
    docs = db.collection(u'NOC').stream()
    list1 = []
    list2 = []
    list3 = []
    for doc in docs:
        email = db.collection(u'users').document(u'{}'.format(doc.id)).get().to_dict()['email']
        pendingSubdocs = db.collection(u'NOC').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'Pending').get()
        for subdoc in pendingSubdocs:
            list1.append((subdoc.id,doc.id, email))

        inProcessDocs = db.collection(u'NOC').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'In Process').get()
        for subdoc in inProcessDocs:
            list2.append((subdoc.id,doc.id, email))

        acceptedDocs = db.collection(u'NOC').document(u'{}'.format(doc.id)).collection(u'all_data').where(u'Status',u'==',u'Accepted').get()
        for subdoc in acceptedDocs:
            list3.append((subdoc.id,doc.id, email))
    pending_cases = len(list1)
    inprocess_cases = len(list2)
    accepted_cases = len(list3)
    total_cases = (len(list1)+len(list2)+len(list3))
    return render(request, "noc.html", {"user":request.session['username'], "pending_cases":pending_cases, "inprocess_cases":inprocess_cases, "accepted_cases":accepted_cases, "total_cases":total_cases, "noc_active": "active", "category":"NOC", "pending":list1, "inprocess":list2, "accepted":list3})

def ncr(request, user):

    if not request.session.has_key('username'):
        return redirect(login)
    if request.session['username'] != user:
        return redirect(login)
    
    docs = db.collection(u'FIR_NCR').stream()
    list1 = []
    list2 = []
    list3 = []
    for doc in docs:
        email = db.collection(u'users').document(u'{}'.format(doc.id)).get().to_dict()['email']
        penddingSubdocs = db.collection(u'FIR_NCR').document(u'{}'.format(doc.id)).collection(u'NCR').where(u'Status',u'==',u'Pending').get()
        for subdoc in penddingSubdocs:
            list1.append((subdoc.id,doc.id,email))

        inProgressDocs = db.collection(u'FIR_NCR').document(u'{}'.format(doc.id)).collection(u'NCR').where(u'Status',u'==',u'inProgress').get()
        for subdoc in inProgressDocs:
            list2.append((subdoc.id,doc.id,email))

        assessedDocs = db.collection(u'FIR_NCR').document(u'{}'.format(doc.id)).collection(u'NCR').where(u'Status',u'==',u'Assessed').get()
        for subdoc in assessedDocs:
            list3.append((subdoc.id,doc.id,email))

    return render(request, "ncr.html", {"user":request.session['username'], "category":"NCR", "pending_id_list":list1, "progress_id_list":list2, "assessed_id_list":list3, "ncr_active": "active", "assesedNo" : len(list3), "progressNo":len(list2), "newNo":len(list1) })

def police(request):
    return render(request, "police.html")