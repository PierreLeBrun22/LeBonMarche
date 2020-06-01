import 'package:flutter/material.dart';
import 'package:lebonmarche/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lebonmarche/services/fetch_data.dart' as dataFetch;

class Login extends StatefulWidget {
  Login({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final _formKeyLogin = new GlobalKey<FormState>();
  final _formKeySignup = new GlobalKey<FormState>();

  String _emailLogin;
  String _passwordLogin;
  String _errorMessageLogin;

  String _emailSignup;
  String _passwordSignup;
  String _confirmPasswordSignup;
  String _errorMessageSignup;
  String _firstName;
  String _name;
   List<String> _companyList = <String>['Choose one'];
  String _company = 'Choose one';
  List<String> _statutList = <String>['Choose one'];
  String _statut = 'Choose one';
  List<String> _packList = <String>['Choose one'];
  String _pack = 'Choose one';

  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSaveLogin() {
    final form = _formKeyLogin.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool _validateAndSaveSignup() {
    final form = _formKeySignup.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmitLogin() async {
    if (_validateAndSaveLogin()) {
       setState(() {
      _errorMessageLogin = "";
      _isLoading = true;
    });
        String userId = "";
      try {
        userId = await widget.auth.signIn(_emailLogin, _passwordLogin);
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessageLogin = e.details;
          } else
            _errorMessageLogin = e.message;
        });
      }
    }
  }

  void _validateAndSubmitSignup() async {
    if (_validateAndSaveSignup()) {
       setState(() {
      _errorMessageSignup = "";
      _isLoading = true;
    });
     if (_passwordSignup != _confirmPasswordSignup) {
        print('Error: The tow passwords entered do not match.');
        setState(() {
          _isLoading = false;
          _errorMessageSignup = 'The two passwords entered do not match.';
        });
      } 
      else {
        String userId = "";
        try {
          userId = await widget.auth.signUp(_emailSignup, _passwordSignup);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          dataFetch.pushUserDataSignupProfile(userId, _emailSignup, _firstName, _name, _company, _statut, _pack);
          print('Signed up user: $userId');
          final form = _formKeySignup.currentState;
          form.reset();
          setState(() {
            _isLoading = false;
            _emailSignup = '';
            _passwordSignup = '';
            _confirmPasswordSignup = '';
            _pack = 'Choose one';
            _company = 'Choose one';
            _statut = 'Choose one';
          });
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            if (_isIos) {
              _errorMessageSignup = e.details;
            } else
              _errorMessageSignup = e.message;
          });
        }
      }
    }
  }

  void _getCompany() async {  
CollectionReference ref = Firestore.instance.collection('company');
QuerySnapshot eventsQuery = await ref.getDocuments();
    eventsQuery.documents.forEach((document) {
       _companyList.add(document['name']);
    });
  }

    void _getPack() async {  
CollectionReference ref = Firestore.instance.collection('packs');
QuerySnapshot eventsQuery = await ref.getDocuments();
    eventsQuery.documents.forEach((document) {
       if(document['name'] != 'Open') {
        _packList.add(document['name']);
      }
    });
  }

  void _getStatus() async {  
CollectionReference ref = Firestore.instance.collection('status');
QuerySnapshot eventsQuery = await ref.getDocuments();
    eventsQuery.documents.forEach((document) {
       _statutList.add(document['name']);
    });
  }

  @override
  void initState() {
    _errorMessageSignup = "";
    _errorMessageLogin = "";
    _isLoading = false;
    _getCompany();
    _getStatus();
    _getPack();
    super.initState();
  }

  Widget homePage() {
    return new Scaffold(
      body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Color(0xFF302f33),
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: AssetImage('assets/img/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 200.0),
            child: Center(
              child: new Icon(
                FontAwesomeIcons.handshake,
                color: Color(0xFF43e97b),
                size: 60.0,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 20.0),
              child: new Center(
                child: new Text(
                  "MyServices",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontFamily: 'Satisfy'
                  ),
                ),
              )),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new OutlineButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.white),
                    onPressed: () => gotoSignup(),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "SIGN UP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Color(0xFF43e97b),
                    onPressed: () => gotoLogin(),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    ); 
  }

  Widget loginPage() {
    return new Scaffold(
      body: new Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.05), BlendMode.dstATop),
            image: AssetImage('assets/img/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Form(
          key: _formKeyLogin,
          child: new ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(120.0),
                child: Center(
                  child: new Icon(
                FontAwesomeIcons.handshake,
                color: Color(0xFF43e97b),
                size: 60.0,
              ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'exemple@exemple.com',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: new Icon(
                              Icons.mail,
                              color: Colors.grey,
                            )),
                        validator: (value) =>
                            value.isEmpty ? 'Email can\'t be empty' : null,
                        onSaved: (value) => _emailLogin = value,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '*********',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: new Icon(
                              Icons.lock,
                              color: Colors.grey,
                            )),
                        validator: (value) =>
                            value.isEmpty ? 'Password can\'t be empty' : null,
                        onSaved: (value) => _passwordLogin = value,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 40.0),
                  child: _showErrorMessageLogin()),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Color(0xFF43e97b),
                        onPressed: () => {_validateAndSubmitLogin()},
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "LOGIN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signupPage() {
    return new Scaffold(
      body: new Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.05), BlendMode.dstATop),
            image: AssetImage('assets/img/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Form(
          key: _formKeySignup,
          child: new ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(100.0),
                child: Center(
                  child: new Icon(
                FontAwesomeIcons.handshake,
                color: Color(0xFF43e97b),
                size: 60.0,
              ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'exemple@exemple.com',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: new Icon(
                              Icons.mail,
                              color: Colors.grey,
                            )),
                        validator: (value) =>
                            value.isEmpty ? 'Email can\'t be empty' : null,
                        onSaved: (value) => _emailSignup = value,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '*********',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: new Icon(
                              Icons.lock,
                              color: Colors.grey,
                            )),
                        validator: (value) =>
                            value.isEmpty ? 'Password can\'t be empty' : null,
                        onSaved: (value) => _passwordSignup = value,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "CONFIRM PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '*********',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: new Icon(
                              Icons.lock,
                              color: Colors.grey,
                            )),
                        validator: (value) => value.isEmpty
                            ? 'Confirmed password can\'t be empty'
                            : null,
                        onSaved: (value) => _confirmPasswordSignup = value,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "FIRST NAME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'First name',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: new Icon(
                              FontAwesomeIcons.userAlt,
                              color: Colors.grey,
                            )),
                        validator: (value) =>
                            value.isEmpty ? 'First name can\'t be empty' : null,
                        onSaved: (value) => _firstName = value,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "NAME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: new Icon(
                              FontAwesomeIcons.userAlt,
                              color: Colors.grey,
                            )),
                        validator: (value) =>
                            value.isEmpty ? 'Name can\'t be empty' : null,
                        onSaved: (value) => _name = value,
                      ),
                    ),
                  ],
                ),
              ),
               Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "COMPANY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child:new FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: const Icon(FontAwesomeIcons.solidBuilding, color: Colors.grey),
                errorText: state.hasError ? state.errorText : null,
              ),
              isEmpty: _company == 'Choose one',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _company,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _company = newValue;
                      state.didChange(newValue);
                    });
                  },
                  items: _companyList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
          validator: (val) {
            return  val != null && val != 'Choose one' ? null : 'Please select a company';
          },
        ),
        )
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "STATUS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child:new FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: const Icon(FontAwesomeIcons.solidAddressBook, color: Colors.grey),
                errorText: state.hasError ? state.errorText : null,
              ),
              isEmpty: _statut == 'Choose one',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _statut,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _statut = newValue;
                      state.didChange(newValue);
                    });
                  },
                  items: _statutList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
          validator: (val) {
            return val != null && val != 'Choose one' ? null : 'Please select a status';
          },
        ),
        )
                  ],
                ),
              ),
               Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "PACK",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43e97b),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child:new FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: const Icon(FontAwesomeIcons.suitcase, color: Colors.grey),
                errorText: state.hasError ? state.errorText : null,
              ),
              isEmpty: _pack == 'Choose one',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _pack,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _pack = newValue;
                      state.didChange(newValue);
                    });
                  },
                  items: _packList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
          validator: (val) {
            return val != null && val != 'Choose one' ? null : 'Please select a pack';
          },
        ),
        )
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 40.0),
                  child: _showErrorMessageSignup()),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 50.0, bottom: 20.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Color(0xFF43e97b),
                        onPressed: () => {_validateAndSubmitSignup()},
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "SIGN UP",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showErrorMessageLogin() {
    if (_errorMessageLogin.length > 0 && _errorMessageLogin != null) {
      return new Text(
        _errorMessageLogin,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showErrorMessageSignup() {
    if (_errorMessageSignup.length > 0 && _errorMessageSignup != null) {
      return new Text(
        _errorMessageSignup,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Stack(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              controller: _controller,
              physics: new AlwaysScrollableScrollPhysics(),
              children: <Widget>[loginPage(), homePage(), signupPage()],
              scrollDirection: Axis.horizontal,
            )),
        _showCircularProgress(),
      ],
    );
  }
}
