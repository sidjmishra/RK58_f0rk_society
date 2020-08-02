import 'dart:math';

import 'package:block/modal/constants.dart';
import 'package:block/views/Appointment/appointData.dart';
import 'package:block/views/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/services/auth.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {

  final _formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  bool isLoading = false;

  TextEditingController name = TextEditingController();
  TextEditingController add_1 = TextEditingController();
  TextEditingController add_2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController userContact = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController dateCtl = TextEditingController();

  final _states = ['Andhra Pradesh', 'Arunachal Pradesh', 'Assam',	'Bihar', 'Chhattisgarh', 'Delhi', 'Goa',
    'Gujarat', 'Haryana',	'Himachal Pradesh',	'Jammu and kashmir',	'Ladakh',	'Jharkhand',	'Karnataka',
    'Kerala',	'Madhya Pradesh',	'Maharashtra', 'Manipur',	'Meghalaya', 'Mizoram',	'Nagaland', 'Odisha',	'Punjab',
    'Rajasthan', 'Sikkim',	'Tamil Nadu',	'Telangana', 'Tripura',	'Uttarakhand', 'Uttar Pradesh', 'West Bengal',
    'Andaman and Nicobar', 'Chandigarh', 'Dadra and Nagar Haveli', 'Daman and Diu', 'Lakshadweep'];
  String hintState = 'Select States';
  var pickedCountryName;
  var _currentSelectedState;
  var pickedCountry;
  var stateName;
  var id;
  String subLocal;

  void randomId() async {
    var number = Random.secure();
    QuerySnapshot dataID;

    id = Constants.myUid.substring(0, 4) + number.nextInt(9999).toString();
    dataID = await Firestore.instance.collection('Appointment').document(Constants.myUid).collection('all_data').getDocuments();
    if(dataID.documents.isNotEmpty) {
      for(var index = 0; index < dataID.documents.length; index++) {
        if(dataID.documents[index].data['id'] == id && id.length < 8) {
          setState(() {
            id = Constants.myUid.substring(0, 4) + number.nextInt(9999).toString();
          });
        }
      }
    }
    print(id);
  }

  @override
  void initState() {
    randomId();
    super.initState();
  }

  void resetForm() {
    name.clear();
    add_1.clear();
    add_2.clear();
    city.clear();
    pincode.clear();
    reason.clear();
    details.clear();
    userContact.clear();
    state.clear();
    dateCtl.clear();
    _currentSelectedState = null;
  }

  void setData() {
    if (pickedCountryName == null && pickedCountry == null) {
      pickedCountry = '+91';
      pickedCountryName = 'India';
    }
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      AppointDatabase(uid: Constants.myUid)
          .userSubmitted(
          id,
          Constants.myEmail,
          Constants.myName,
          name.text,
          add_1.text,
          add_2.text,
          city.text,
          pincode.text,
          _currentSelectedState,
          userContact.text,
          reason.text,
          details.text,
          dateCtl.text,
          pickedCountry.toString(),
          pickedCountryName.toString())
          .then((value) {
        Alert(
            context: context,
            type: AlertType.success,
            title: 'Data Submitted',
            desc: '',
            buttons: [
              DialogButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]).show();
        resetForm();
        randomId();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Appointment Request',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                Icons.clear,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: HotConstants.myPhone == null
          ? Column(
        children: <Widget>[
          Text('User Not verified'),
          SizedBox(height: 20.0),
          RaisedButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Profile()
              ));
            },
            color: Colors.orangeAccent,
            child: Text('Add Information'),
          ),
        ],
      ) : Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900],
              Colors.orange[800],
              Colors.orange[400],
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Text(
                      'Appointment',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  FadeAnimation(
                    1.3,
                    Text(
                      'Fill details for the appointment!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(35),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                            1.3,
                            Text(
                              'Date of Appointment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[300]),
                                      ),
                                    ),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter a Date';
                                        }
                                        return null;
                                      },
                                      controller: dateCtl,
                                      textAlign: TextAlign.center,
                                      onTap: () async {
                                        DateTime date = DateTime(2000);
                                        FocusScope.of(context)
                                            .requestFocus(
                                            FocusNode());
                                        date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100),
                                        );
                                        dateCtl.text = date
                                            .toIso8601String()
                                            .substring(0, 10);
                                        print(dateCtl);
                                      },
                                      maxLength: 10,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Enter the Date',
                                        hintStyle: TextStyle(
                                            color: Colors.grey[300]),
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Full Name',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          formDesign(
                            textData: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter full name';
                                }
                                return null;
                              },
                              controller: name,
                              maxLength: 30,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Full Name',
                                hintStyle:
                                TextStyle(color: Colors.grey[300]),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Address',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          formDesign(
                            textData: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Address';
                                }
                                return null;
                              },
                              controller: add_1,
                              maxLength: 300,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Address Line 1',
                                hintStyle:
                                TextStyle(color: Colors.grey[300]),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: 10),
                          formDesign(
                            textData: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Address';
                                }
                                return null;
                              },
                              controller: add_2,
                              maxLength: 300,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Address Line 2',
                                hintStyle:
                                TextStyle(color: Colors.grey[300]),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          formDesign(
                            textData: TextFormField(
                              validator: (value) {
                                if (value.isEmpty || value.length < 3) {
                                  return 'Please Enter valid city name';
                                }
                                return null;
                              },
                              controller: city,
                              maxLength: 20,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'City/Locality',
                                hintStyle:
                                TextStyle(color: Colors.grey[300]),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: FadeAnimation(
                                  1.3,
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              225, 95, 27, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: DropdownButton<String>(
                                            items: _states.map((String
                                            dropDownStringItem) {
                                              return DropdownMenuItem<
                                                  String>(
                                                value: dropDownStringItem,
                                                child: Text(
                                                    dropDownStringItem),
                                              );
                                            }).toList(),
                                            value: _currentSelectedState,
                                            onChanged: (String
                                            newValueSelected) {
                                              setState(() {
                                                _currentSelectedState =
                                                    newValueSelected;
                                              });
                                            },
                                            hint: Text(
                                              hintState,
                                              style: TextStyle(
                                                  color:
                                                  Colors.grey[300]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: formDesign(
                                  textData: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty ||
                                          value.length < 6) {
                                        return 'Please Enter valid pincode';
                                      }
                                      return null;
                                    },
                                    controller: pincode,
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Pincode',
                                      hintStyle: TextStyle(
                                          color: Colors.grey[300]),
                                      border: InputBorder.none,
                                      counterText: '',
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Details of Appointment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          formDesign(
                            textData: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter subject';
                                }
                                return null;
                              },
                              controller: reason,
                              maxLength: 300,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Subject of Appointment',
                                hintStyle:
                                TextStyle(color: Colors.grey[300]),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          formDesign(
                            textData: TextFormField(
                              validator: (value) {
                                if (value.isEmpty || value.length < 6) {
                                  return 'Please Enter details';
                                }
                                return null;
                              },
                              controller: details,
                              maxLength: 300,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Details for Appointment',
                                hintStyle:
                                TextStyle(color: Colors.grey[300]),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              maxLines: 3,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Text(
                              'Contact Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.3,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[300]),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ListTile(
                                                title:
                                                _buildCountryPickerDropdown(
                                                    hasPriorityList:
                                                    true),
                                                dense: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            width: 123,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.orange[400],
                            ),
                            child: Center(
                              child: FlatButton(
                                onPressed: () {
                                  setData();
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCountryPickerDropdown(
      {bool filtered = false,
        bool sortedByIsoCode = false,
        bool hasPriorityList = false,
        bool hasSelectedItemBuilder = false}) {
    double dropdownButtonWidth = MediaQuery.of(context).size.width * 0.4;
    //respect dropdown button icon size
    double dropdownItemWidth = dropdownButtonWidth - 50;
    double dropdownSelectedItemWidth = dropdownButtonWidth - 70;
    return Row(
      children: <Widget>[
        SizedBox(
          width: dropdownButtonWidth,
          child: CountryPickerDropdown(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            itemHeight: null,
            isDense: false,
            selectedItemBuilder: hasSelectedItemBuilder == true
                ? (Country country) => _buildDropdownSelectedItemBuilder(
                country, dropdownSelectedItemWidth)
                : null,
            itemBuilder: (Country country) => hasSelectedItemBuilder == true
                ? _buildDropdownItemWithLongText(country, dropdownItemWidth)
                : _buildDropdownItem(country, dropdownItemWidth),
            initialValue: 'IN',
            itemFilter: filtered
                ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
                : null,
            priorityList: hasPriorityList
                ? [
              CountryPickerUtils.getCountryByIsoCode('IN'),
            ]
                : null,
            sortComparator: sortedByIsoCode
                ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
                : null,
            onValuePicked: (Country country) {
              print("${country.name}");
              pickedCountry = country.phoneCode;
              pickedCountryName = country.name;
              print(country);
            },
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty || value.length < 10) {
                return 'Please Enter valid phone number';
              }
              return null;
            },
            controller: userContact,
            decoration: InputDecoration(
              hintText: "Phone",
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintStyle: TextStyle(color: Colors.grey[300]),
              counterText: '',
            ),
            keyboardType: TextInputType.number,
            maxLength: 10,
          ),
        )
      ],
    );
  }

  Widget _buildDropdownItem(Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Expanded(child: Text("+${country.phoneCode}(${country.isoCode})")),
          ],
        ),
      );

  Widget _buildDropdownItemWithLongText(
      Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(
                width: 8.0,
              ),
              Expanded(child: Text('${country.name}')),
            ],
          ),
        ),
      );

  Widget _buildDropdownSelectedItemBuilder(
      Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                  child: Text(
                    '${country.name}',
                    style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      );

  Widget formDesign({Widget textData}) {
    return FadeAnimation(
      1.3,
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(225, 95, 27, .3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]),
                ),
              ),
              child: textData,
            ),
          ],
        ),
      ),
    );
  }
}
