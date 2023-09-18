// CODE WITH IMPLEMENTATION
// Main.dart

import 'package:flutter/material.dart'; import 'package:flutter/services.dart';
import 'package:vehicle_maintenance_app/checkscreen.dart'; import 'package:vehicle_maintenance_app/global.dart'; import 'package:vehicle_maintenance_app/models/servicemodel.dart';
import 'package:vehicle_maintenance_app/ongenerateroute.dart'; import 'package:vehicle_maintenance_app/screens/addnewcar.dart'; import 'package:vehicle_maintenance_app/screens/loginpage.dart'; import 'package:vehicle_maintenance_app/screens/mainscreens/dashboard. dart';
import 'package:vehicle_maintenance_app/screens/mainscreens/homeparent
.dart'; import
'package:vehicle_maintenance_app/screens/payment/billingmain.da rt';
import 'package:vehicle_maintenance_app/screens/payment/paymentscreen. dart';
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched uleappointment.dart';
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched uleconfirmation.dart';
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched ulereview.dart';
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched uleshop.dart';
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched ulesuccess.dart';
import 'package:vehicle_maintenance_app/screens/signup.dart'; import 'package:vehicle_maintenance_app/screens/payment/paymentsuccess full.dart';
import 'package:firebase_core/firebase_core.dart';
 
import 'package:vehicle_maintenance_app/screens/upcoming_appointments. dart';
import 'package:vehicle_maintenance_app/services/decision.dart';
String initialroute = ''; void main() async {
SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle( statusBarColor: Colors.transparent,
));
WidgetsFlutterBinding.ensureInitialized(); await Firebase.initializeApp(); initialroute = await logindecision(); runApp(MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) { return MaterialApp(
debugShowCheckedModeBanner: false, theme: ThemeData(
fontFamily: 'opensans', useMaterial3: true,
scaffoldBackgroundColor: Colors.white, colorSchemeSeed: maintheme, elevatedButtonTheme: ElevatedButtonThemeData(
style: ElevatedButton.styleFrom( surfaceTintColor: Colors.white, foregroundColor: maintheme,
),
),
),
initialRoute: initialroute,
onGenerateRoute: RouteGenerator.generateRoute,
);
}
}

// addnewcar.dart

import 'package:firebase_auth/firebase_auth.dart'; import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/data.dart'; import 'package:vehicle_maintenance_app/global.dart'; import
'package:vehicle_maintenance_app/services/user_services.dart';
 
import 'package:vehicle_maintenance_app/widgets/loadingblock.dart';

class addNewCar extends StatefulWidget {
const addNewCar({Key? key}) : super(key: key);

@override
State<addNewCar> createState() => _addNewCarState();
}

class _addNewCarState extends State<addNewCar> { String? carmaker;
String? carmodel;
UserServices userServices = UserServices();

@override
void initState() {
// TODO: implement initState super.initState();
if (carmaker == null) {
carmaker = carMakers.keys.first; carmodel = carMakers[carmaker][0];
}
}

@override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar(
backgroundColor: Colors.white, elevation: 0,
centerTitle: true, scrolledUnderElevation: 0, leading: IconButton(
onPressed: () { Navigator.pop(context);
},
icon: Icon( CupertinoIcons.left_chevron, color: darktext,
),
),
title: Text( "Add Vehicle",
style: TextStyle( color: darktext,
fontWeight: FontWeight.bold,
),
),
actions: [ IconButton(
onPressed: () async { loadingBlock(context: context);
 
await userServices.addnewcar( carmaker: carmaker!, carmodel: carmodel!,
);
Navigator.pop(context); // to pop dialog box Navigator.pop(context); // to pop screen print('Successfull');
},
icon: Icon( Icons.check_rounded, color: darktext,
),
),
],
),
body: Container(
padding: EdgeInsets.symmetric(horizontal: 15), child: Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
SizedBox( height: 20,
),

Container( height: 200,
width: MediaQuery.of(context).size.width, margin: EdgeInsets.symmetric(vertical: 10), child: ClipRRect(
borderRadius: BorderRadius.circular(16), child: Image.asset(
'assets/images/vehicles/'	+ carPhotos[carmodel!].toString(),
fit: BoxFit.cover,
),
),

color: Colors.black.withAlpha(50), borderRadius: BorderRadius.circular(16),
),
),
SizedBox( height: 20,
),
Text(
'Vehicle Maker', style: subtitle,
),
SizedBox( height: 15,
),
Container(
 
padding: EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(
borderRadius: BorderRadius.circular(12), border: Border.all(
width: 1,
color: maintheme,
),
),
child: DropdownButton( value: carmaker,
alignment: AlignmentDirectional.centerStart, borderRadius: BorderRadius.circular(12), isExpanded: true,
style: TextStyle( fontSize: 16, color: darktext,
),
underline: Container(), icon: Icon(
CupertinoIcons.chevron_down, size: 20,
color: darktext,
),
items: [
for (String i in carMakers.keys) DropdownMenuItem(
value: i, child: Text(i),
),
],
onChanged: (a) { setState(() {
carmaker = a;
carmodel = carMakers[carmaker][0];
});
},
),
),
SizedBox( height: 20,
),
Text(
'Vehicle Model', style: subtitle,
),
SizedBox( height: 15,
),
Container(
padding: EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(
borderRadius: BorderRadius.circular(12), border: Border.all(
 
width: 1,
color: maintheme,
),
),
child: DropdownButton( value: carmodel,
alignment: AlignmentDirectional.centerStart, borderRadius: BorderRadius.circular(12), isExpanded: true,
style: TextStyle( fontSize: 16, color: darktext,
),
underline: Container(), icon: Icon(
CupertinoIcons.chevron_down, size: 20,
color: darktext,
),
items: [
for (String i in carMakers[carmaker]) DropdownMenuItem(
value: i, child: Text(i),
),
],
onChanged: (a) { setState(() {
carmodel = a;
});
},
),
),
SizedBox( height: 30,
),
],
),
),
);
}
}
 
// billingmain.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart'; import
'package:vehicle_maintenance_app/screens/payment/paymentwidgets
/paymentduesection.dart'; import
'package:vehicle_maintenance_app/screens/payment/paymentwidgets
/paymenttiles.dart'; import
'package:vehicle_maintenance_app/services/user_services.dart'; import 'package:vehicle_maintenance_app/widgets/carcarousal.dart';

class billingMain extends StatefulWidget {
const billingMain({Key? key}) : super(key: key);

@override
State<billingMain> createState() => _billingMainState();
}

class _billingMainState extends State<billingMain> { UserServices userServices = UserServices(); List<String> carkeys = [];
bool loaded = false; int currentpage = 0;
void setcurrentpage(int page) { print(page);
setState(() { currentpage = page;
});
}

Future<QuerySnapshot> getcardata() async { QuerySnapshot data = await userServices.getcars(); carkeys.clear();
for (DocumentSnapshot snapshot in data.docs) { carkeys.add(snapshot.id.toString());
}
loaded = true; return data;
}

@override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar(
backgroundColor: Colors.white, automaticallyImplyLeading: false,
 
elevation:   0, centerTitle: true, scrolledUnderElevation: 0, title: Text(
"Billing",
style: TextStyle( color: darktext,
fontWeight: FontWeight.bold,
),
),
),
body: Container(
child: FutureBuilder( future: getcardata(),
builder: (context, snapshot) {
if (snapshot.hasData && snapshot.data!.size != 0) { return Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
SizedBox( height: 15,
),
Container( height: 180,
child: carCarousal( setCurrentpage: setcurrentpage, items: [
for	(DocumentSnapshot	doc	in
 
snapshot.data!.docs)


],
),
),
 

buildVehiclecard(
carmaker: doc.get('carmaker'), carmodel: doc.get('carmodel'))
 





15),
 
SizedBox( height: 15,
),
Expanded(
child: Container(
padding: EdgeInsets.symmetric(horizontal:

child: SingleChildScrollView( physics: BouncingScrollPhysics(), child: Column(
crossAxisAlignment:
 
CrossAxisAlignment.start,
 

mainAxisSize: MainAxisSize.min, children: [
paymentDueSection(
carkey: carkeys[currentpage],
),
SizedBox(
 
height: 15,
),
Text(
'RECENT TRANSACTIONS',
style: subtitle.copyWith( color: darktext,
),
),
SizedBox( height: 5,
),
recentTransactionsTile(),
],
),
),
),
),
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [ TextButton(
onPressed: () {},
child: Text('See all Transactions'),
),
],
),
],
);
 

== 0) {
 
} else if (snapshot.hasData && snapshot.data!.size

return Center( child: Text(
'Please add Vehicle in DashBoard', style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold, color: darktext,
),
 
),
);
}
return Center(
child: CircularProgressIndicator(),
);
},
),
),
);
}}
 
// carcarousal.dart

import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/data.dart'; import 'package:vehicle_maintenance_app/global.dart';

class carCarousal extends StatefulWidget { final Function? setCurrentpage;
final List items;
const carCarousal({Key? key, this.setCurrentpage, this.items = const []})
: super(key: key);

@override
State<carCarousal> createState() => _carCarousalState();
}

class _carCarousalState extends State<carCarousal> { int currentpage = 0;
@override
Widget build(BuildContext context) { return Column(
children: [ Expanded(
child: Container(
// height: 180,
width: MediaQuery.of(context).size.width, child: CarouselSlider(
items: [
for (var i in widget.items) i,
],
options: CarouselOptions( enableInfiniteScroll: false, viewportFraction: 16 / 9,
enlargeFactor: 0.3, enlargeCenterPage: true, initialPage: 0,
scrollPhysics: BouncingScrollPhysics(), onPageChanged: (int page, reason) {
if (widget.setCurrentpage != null) { widget.setCurrentpage!(page);
}
setState(() { currentpage = page;
});
}),
),
),
),
 
SizedBox( height: 10,
),
Row(
mainAxisAlignment: MainAxisAlignment.center, children: [
for (int i = 0; i < widget.items.length; i++) Row(
children: [ AnimatedContainer(
duration: Duration(milliseconds: 600), curve: Curves.fastLinearToSlowEaseIn, height: 7,
width: (i == currentpage) ? (20) : (7), decoration: BoxDecoration(
color: (i == currentpage)
? (maintheme)
: (Colors.grey.withAlpha(150)), borderRadius: BorderRadius.circular(30),
),
),
SizedBox( width: 5,
),
],
),
],
),
],
);
}
}

class buildVehiclecard extends StatelessWidget { final String carmaker;
final String carmodel; const buildVehiclecard(
{Key?	key,	required	this.carmaker,	required this.carmodel})
: super(key: key);

@override
Widget build(BuildContext context) { print(carPhotos[carmodel].toString()); return ClipRRect(
borderRadius: BorderRadius.circular(16), child: Container(
height: 180,
width: MediaQuery.of(context).size.width - 30, decoration: BoxDecoration(
color: Colors.black,
),
child: Stack(
 
children: [ Container(
height: 180,
width: MediaQuery.of(context).size.width, decoration: BoxDecoration(
image: DecorationImage( fit: BoxFit.fill, image: AssetImage(
'assets/images/vehiclebg.jpg',
),
),
),
child: BackdropFilter( filter: ImageFilter.blur(
sigmaX: 2,
sigmaY: 2,
),
child: Container( decoration: BoxDecoration(
color: Colors.black.withAlpha(25),
),
),
),
),
Positioned(
child: Container( height: 180,
width: MediaQuery.of(context).size.width, child: Column(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
crossAxisAlignment: CrossAxisAlignment.center,
children: [ Text(
carmaker + ' ' + carmodel, style: TextStyle(
color: Colors.white, fontSize: 18,
fontWeight: FontWeight.bold,
),
),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [ Container(
height: 100,
width: 180,
decoration: BoxDecoration(
color: Colors.white.withAlpha(150), borderRadius:
BorderRadius.circular(12),
 



BorderRadius.circular(12),
 
),
child: ClipRRect( borderRadius:

child: Image.asset( 'assets/images/vehicles/' +
 

carPhotos[carmodel].toString(),
fit: BoxFit.cover,
),
),
),
Column( crossAxisAlignment:
 
CrossAxisAlignment.start,
 

children: [ Text(
'Car Maker: ', style: TextStyle(
fontSize:   13, color: Colors.white,
),
),
Text(
carmaker,
style: TextStyle( fontSize: 15,
fontWeight: FontWeight.bold, color: Colors.white,
),
),
SizedBox( height: 15,
),
Text(
'Car Model: ', style: TextStyle(
fontSize:   13, color: Colors.white,
),
),
Text(
carmodel,
style: TextStyle( fontSize: 15,
fontWeight: FontWeight.bold, color: Colors.white,
),
),
 
],
),
],
),
 
],
),
),
),
],
),
),
);
}
}


// carmodel.dart


class CarModel { String? carmaker; String? carmodel;

CarModel({ this.carmaker, this.carmodel,
});
}


// checkscreen.dart

import 'package:flutter/material.dart'; import
'package:vehicle_maintenance_app/services/constants.dart'; import 'package:vehicle_maintenance_app/services/user_services.dart';

class checkscreen extends StatefulWidget {
const checkscreen({Key? key}) : super(key: key);

@override
State<checkscreen> createState() => _checkscreenState();
}

class _checkscreenState extends State<checkscreen> { UserServices userServices = UserServices(); @override
Widget build(BuildContext context) { return Scaffold(
body: Center(
child: ElevatedButton( onPressed: () {}, child: Text("Click me"),
),
),
 
);
}
}

// commonvars.dart

List months = [ '',
'January', 'February', 'March',
'April',
'May',
'June',
'July',
'August', 'September', 'October', 'November', 'December'
];
List days = [ 'Sun',
'Mon',
'Tue',
'Wed',
'Thu',
'Fri',
'Sat',
'Sun',
];

// constants.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance; FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference userbase = firestore.collection('userdata');

String userkey = ''; String username = '';
 
// dashboard.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart'; import 'package:vehicle_maintenance_app/global.dart'; import 'package:vehicle_maintenance_app/global.dart'; import 'package:vehicle_maintenance_app/models/servicemodel.dart'; import
'package:vehicle_maintenance_app/screens/mainscreens/homeparent
.dart'; import
'package:vehicle_maintenance_app/screens/schedules_screen/sched uleshop.dart';
import 'package:vehicle_maintenance_app/services/user_services.dart'; import 'package:vehicle_maintenance_app/widgets/carcarousal.dart'; import 'package:vehicle_maintenance_app/widgets/loadingblock.dart';

class Dashboard extends StatefulWidget { final GlobalKey<ScaffoldState> mykey;
const Dashboard({Key? key, required this.mykey}) : super(key: key);

@override
State<Dashboard> createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> { UserServices userServices = UserServices(); List<String> carkeys = [];
 
int currentpage = 0;
bool refreshbottom = false; void setCurrentpage(int page) {
setState(() { currentpage = page;
});
print(currentpage.toString() + 'from dashboard'); print(carkeys.length.toString()); print(carkeys);
}

Future<QuerySnapshot> getcardata() async { QuerySnapshot data = await userServices.getcars();

carkeys.clear();
for (DocumentSnapshot snapshot in data.docs) { carkeys.add(snapshot.id.toString());
}
if (refreshbottom == false) {
// to set the option visible refreshbottom = true; setState(() {});
}
return data;
}


@override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar( elevation: 0, centerTitle: true,
scrolledUnderElevation: 0, automaticallyImplyLeading: false, backgroundColor: Colors.white, title: Text(
 
'Dashboard', style: TextStyle(
fontWeight: FontWeight.bold,
),
),
actions: [ IconButton(
onPressed: () { widget.mykey.currentState?.openEndDrawer();
},
icon: Icon( Icons.menu,
),
),
],
),
body: Container( child: Column(
children: [ Container(
margin: EdgeInsets.symmetric(horizontal: globalpadding),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
Text(
'Shops',
style: TextStyle( fontSize: 16,
fontWeight: FontWeight.bold,
),
),
SizedBox( height: 10,
),
Container(
 
// height: 70, child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
shopcircle(imgname: 'lg1.jpg'), shopcircle(imgname: 'lg2.jpg'), shopcircle(imgname: 'lg3.jpg'), shopcircle(imgname: 'lg4.jpg'), SizedBox(
width: 20,
),
Icon(Icons.search),
],
),
),
//shop circles SizedBox(
height: 15,
),
],
),
),
 







!= 0) {
 
Expanded(
child: FutureBuilder( future: getcardata(),
builder: (context, snapshot) {
if (snapshot.hasData && snapshot.data!.size

return Column( children: [
Container( height: 180, width:
 
MediaQuery.of(context).size.width,
child: carCarousal(
 




documentsnapshot
 
setCurrentpage: setCurrentpage, items: [
for (DocumentSnapshot

in snapshot.data!.docs) Stack(
children: [ buildVehiclecard(
carmaker:
 


documentsnapshot.get('carmaker'),
carmodel:


 
documentsnapshot.get('carmodel'),
 

),
Positioned( top: 0,
right: 0,
child: IconButton( icon: Icon(
 

 
Icons.delete_forever_rounded,







getdeleteconfirmation(
 

color: Colors.white,
),
onPressed: () async { bool? result =
await

context); print(result);
if (result == true) {
 


 
loadingBlock(context: context);

userServices.deleteCar(
 

await
 
carkey:
(currentpage ==


carkeys.length)
?
(carkeys[currentpage - 1])
:
(carkeys[currentpage]),
);


 
Navigator.pop(context);
 

setState(() {});
}
},
),
)
],
),
 
addnewvehicle(),
],
),
),
 





carkeys.length)





BouncingScrollPhysics(),
 
Expanded(
child: Container( child: Visibility(
visible: (currentpage ==

? (false)
: (true),
child: SingleChildScrollView( physics:

child: Column( children: [
SizedBox(
height: 15,
 




carkeys.length)

(carkeys[currentpage - 1])

(carkeys[currentpage]),
 
),
paymentTile(
carkey: (currentpage ==

?

:
 
),
SizedBox( height: 15,
 




carkeys.length)

(carkeys[currentpage - 1])

(carkeys[currentpage]),
 
),
appointmentTile(
carkey: (currentpage ==

?

:
 
),
SizedBox( height: 15,
 




carkeys.length)

(carkeys[currentpage - 1])

(carkeys[currentpage]),
 
),
scheduleAppointmentTile( carkey: (currentpage ==

?

:
 
),
SizedBox( height: 20,
),
],
),
 
),
),
),
),
],
);
} else if (snapshot.hasData && snapshot.data!.size == 0) {
return Center(
child: FloatingActionButton.extended( onPressed: () async {
await Navigator.pushNamed(context,
 
'/addnewvehicle');
 

setState(() {});
},
 
backgroundColor: maintheme.withAlpha(200),
foregroundColor: Colors.white, label: Text('Add New Vehicle'), icon: Icon(Icons.add),
),
);
} else {
return Container( height: 100,
width: 100, child: FittedBox(
child: CircularProgressIndicator( strokeWidth: 2,
),
),
);
}
},
),
),
 
],
),
),
);
}


getdeleteconfirmation(context) { return showDialog(
context: context, barrierDismissible: false, builder: (context) {
return AlertDialog( title: Text('Delete'),
content: Text('Do you want to delete this car?'), shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
actions: [ TextButton(
onPressed: () { Navigator.pop(context);
},
child: Text("Cancel"),
),
FilledButton( onPressed: () {
Navigator.pop(context, true);
},
style: FilledButton.styleFrom( backgroundColor: Colors.red,
 


),
],
);
});
 
),
child: Text('Delete'),
 
}

addnewvehicle() { return Container(
height: 180,
width: MediaQuery.of(context).size.width - 30, decoration: BoxDecoration(
color: maintheme.withAlpha(50), borderRadius: BorderRadius.circular(16),
),
child: Center(
child: FloatingActionButton.extended( onPressed: () async {
await Navigator.pushNamed(context, '/addnewvehicle');
setState(() {});
},
backgroundColor: maintheme.withAlpha(200), foregroundColor: Colors.white,
label: Text('Add New Vehicle'), icon: Icon(Icons.add),
),
),
);
}


Widget shopcircle({String imgname = 'lg1.jpg'}) { return Container(
height: MediaQuery.of(context).size.width / 6, width: MediaQuery.of(context).size.width / 6, decoration: BoxDecoration(
shape: BoxShape.circle, border: Border.all(
color: maintheme.withAlpha(50), width: 5,
),
 
),
child: ClipRRect(
borderRadius: BorderRadius.circular(100), child: Image.asset(
'assets/logos/' + imgname, fit: BoxFit.fill,
),
),
);
}
}


class scheduleAppointmentTile extends StatelessWidget { final String carkey;
const scheduleAppointmentTile({Key? key, required this.carkey})
: super(key: key);

@override
Widget build(BuildContext context) { return Container(
padding: EdgeInsets.symmetric(horizontal: globalpadding), child: ElevatedButton(
onPressed: () {
Navigator.pushNamed(context, '/scheduleshop', arguments: ServiceModel(carkey: carkey));
},
style: ElevatedButton.styleFrom( backgroundColor: Colors.white, foregroundColor: maintheme, elevation: 7,
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),
),
),
child: Container(
 
height: 100, child: Column(
mainAxisAlignment: MainAxisAlignment.center, children: [
Row(
crossAxisAlignment: CrossAxisAlignment.center, children: [
Stack(
children: [ iconMaker(
iconData: Icons.calendar_month,
),
Positioned( right: 3,
top: 3,
child: Container( height: 7,
width: 7,
decoration: BoxDecoration( color: Colors.red, borderRadius:
BorderRadius.circular(20)),
),
),
],
),
SizedBox( width: 20,
),
Expanded(
child: Column( crossAxisAlignment:
CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.center,
children: [
 
Text(
"SCHEDULE APPOINTMENT",
style: TextStyle( fontSize: 14,
fontWeight: FontWeight.bold, color: Colors.black),
),
SizedBox( height: 5,
),
Text(
"Time to give your car some love", style: TextStyle(
fontSize:   12, color: Colors.black,
),
),
],
),
),
IconButton( onPressed: () {}, icon: Icon(
Icons.chevron_right_rounded, size: 30,
color: Colors.black,
),
),
],
),
],
),
),
),
);
}
 
}

class iconMaker extends StatelessWidget { final IconData iconData;
const iconMaker({Key? key, this.iconData = Icons.access_time})
: super(key: key);

@override
Widget build(BuildContext context) { return Container(
height: 45,
width: 45,
decoration: BoxDecoration( color: darktext.withAlpha(30), shape: BoxShape.circle,
),
child: Icon( iconData,
color: darktext, size: 30,
),
);
}
}


class appointmentTile extends StatelessWidget { final String carkey;
const appointmentTile({Key? key, required this.carkey}) : super(key: key);

@override
Widget build(BuildContext context) { return Container(
padding: EdgeInsets.symmetric(horizontal: globalpadding), child: ElevatedButton(
 
onPressed: () {
Navigator.pushNamed(context, '/upcomingappointments', arguments: [carkey, '']);
},
style: ElevatedButton.styleFrom( backgroundColor: Colors.white, foregroundColor: maintheme, elevation: 7,
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),
),
),
child: Container( height: 100, child: Column(
mainAxisAlignment: MainAxisAlignment.center, children: [
Row(
crossAxisAlignment: CrossAxisAlignment.center, children: [
Stack(
children: [ iconMaker(
iconData: Icons.timelapse_rounded,
),
Positioned( right: 3,
top: 3,
child: Container( height: 7,
width: 7,
decoration: BoxDecoration( color: Colors.red, borderRadius:
BorderRadius.circular(20)),
),
 
),
],
),
SizedBox( width: 20,
),
Expanded(
child: Column( crossAxisAlignment:
CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.center,
children: [ Text(
"UPCOMING APPOINTMENTS",
style: TextStyle( fontSize: 14,
fontWeight: FontWeight.bold, color: Colors.black),
),
SizedBox( height: 5,
 




3 days",
 
),
Text(
"You Have an Appointment at MIDAS in

style: TextStyle( fontSize:   12, color: Colors.black,
 
),
),
],
),
),
IconButton( onPressed: () {},
 
icon: Icon( Icons.chevron_right_rounded, size: 30,
color: Colors.black,
),
),
],
),
],
),
),
),
);
}
}


class paymentTile extends StatefulWidget { final String carkey;
const paymentTile({Key? key, required this.carkey}) : super(key: key);

@override
State<paymentTile> createState() => _paymentTileState();
}


class _paymentTileState extends State<paymentTile> { UserServices userServices = UserServices();
bool expanded = false; int totalcost = 0; getsnapshotlist() async {
totalcost = 0;
print('made 0'); List<DocumentSnapshot> snapshots = []; QuerySnapshot querySnapshot =
await userServices.getunpaidservicewithcarkey(carkey: widget.carkey);
 
for (DocumentSnapshot doc in querySnapshot.docs) { snapshots.add(doc);
totalcost += int.parse(doc.get('serviceprice'));
}
return snapshots;
}


@override
Widget build(BuildContext context) { return Container(
padding: EdgeInsets.symmetric(horizontal: globalpadding), child: ElevatedButton(
onPressed: () {
setState(() {
expanded = !expanded;
});
},
style: ElevatedButton.styleFrom( backgroundColor: Colors.white, foregroundColor: maintheme, padding: EdgeInsets.all(0), elevation: 7,
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),
),
),
child: AnimatedContainer(
duration: Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn, width: MediaQuery.of(context).size.width,
padding: EdgeInsets.symmetric(horizontal: 15,
vertical: 0),
height: (expanded) ? (180) : (100), child: SingleChildScrollView(
physics: NeverScrollableScrollPhysics(), scrollDirection: Axis.vertical,
 
child: FutureBuilder( future: getsnapshotlist(),
builder: (context, snapshot) { if (snapshot.hasData) {
return Column( mainAxisAlignment:
MainAxisAlignment.start,
children: [ Container(
height: 100, child: Column(
mainAxisAlignment:
 
MainAxisAlignment.center,




CrossAxisAlignment.center,







Icons.notifications_rounded,











BoxDecoration(

> 0)

(Colors.red)
 

children: [ Row(
crossAxisAlignment:

children: [ Stack(
children: [ iconMaker(
iconData:

),
Positioned( right: 3,
top: 3,
child: Container( height: 7,
width: 7, decoration:

color: (totalcost

?
 

(Colors.transparent),
 
:

borderRadius:
 


BorderRadius.circular(20)),
),
),
],
),
SizedBox( width: 20,
),
Expanded(
child: Column( crossAxisAlignment:

CrossAxisAlignment.start,
mainAxisAlignment:


 
MainAxisAlignment.center,








FontWeight.bold,



(Colors.black.withAlpha(100))

(Colors.black),
 

children: [ Text(
"PAYMENTS DUE",
style: TextStyle( fontSize: 14, fontWeight:

color: (expanded)
?

:
 
),
),
SizedBox( height: 5,
 
),
(expanded)
? (Text(
'Total: ₹ ' +


 
totalcost.toString(),

TextStyle(



FontWeight.bold,

Colors.black,
 

style:

fontSize: 16, fontWeight:

color:
 
),
))
 




have payments due")

have no payments due"),

TextStyle(



Colors.black,
 
: (Text(
(totalcost > 0)
? ("You

: ("You

style:

fontSize: 12, color:

),
)),
],
),
),
 
SizedBox( width: 20,
),
IconButton( onPressed: () {
 
setState(() {
expanded = !expanded;
});
},
 



Duration(milliseconds: 500),

Curves.fastLinearToSlowEaseIn,

: (0)) / 4,
 
icon: AnimatedRotation( duration:

curve:

turns: ((expanded) ? (1)

child: Icon(
 


 
Icons.chevron_right_rounded,




),
),
],
),
],
),
 

size: 30,
color: Colors.black,
),
 












checkup at Luffy Lube',
 
),
ClipRect(
child: (expanded)
? (Row(
children: [ Expanded(
flex: 4, child: Text(
'Oil Change, standard

style: TextStyle( fontSize: 12,
 

FontWeight.bold,
 
fontWeight:

color: Colors.black,
),
),
),
 
SizedBox( width: 10,
 









'/upcomingappointments',
 
),
Expanded( flex: 2,
child: OutlinedButton( onPressed: () {
Navigator.pushNamed( context,

arguments: [ widget.carkey, 'Payment Dues'
]);
 



OutlinedButton.styleFrom(

Colors.white,

Colors.red,

RoundedRectangleBorder(
 
},
style:

backgroundColor:

foregroundColor:

shape:


borderRadius:
 

 

BorderRadius.circular(12),
 


),
side: BorderSide( color: Colors.red,
width: 1,
 
),
),
child: Text( 'Review',
style: TextStyle( color: Colors.red, fontSize: 15,
),
),
),
),
],
))
: (Container()),
),
],
);
} else {
return Column( mainAxisAlignment:
MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [ Row(),
LinearProgressIndicator(),
],
);
}
},
)),
),
),
);
}
}
 
// data.dart

import 'package:vehicle_maintenance_app/models/shop_model.dart';

Map<String, dynamic> carMakers = { 'Mahindra': [
'XUV300',
'XUV500',
'XUV700',
'Thar',
],
'Tata': [ 'Harrier', 'Nexon',
'Hexa',
'Punch',
],
'Hyundai': [
'Creta',
'Xcent',
'Venue',
'Verna',
],
'Honda': [
'Amaze',
'City',
'Accord',
'Civic',
],
};

Map<String, String> carPhotos = { 'XUV300': 'xuv300.png',
'XUV500': 'xuv500.png',
'XUV700': 'xuv700.png',
 
'Thar': 'thar.webp', 'Harrier': 'harrier.png', 'Nexon': 'nexon.png',
'Hexa': 'hexa.png',
'Punch': 'punch.jpeg',
'Creta': 'creta.png',
'Xcent': 'xcent.png',
'Venue': 'venue.png',
'Verna': 'verna.png',
'Amaze': 'amaze.png',
'City': 'city.png',
'Accord': 'accord.png',
'Civic': 'civic.png',
};

Map<String, int> services = {
'General check-up and inspection': 4000, 'Engine oil change': 1770,
'Air filter cleaning or replacement': 2300, 'Brake system inspection and repair': 3100, 'Wheel alignment and balancing': 1600, 'Battery check and replacement': 2900,
'Suspension system inspection and repair': 3500, 'Transmission system service': 2850,
'Fuel system cleaning': 2700, 'Spark plug replacement': 1040,
'Coolant system flush and refill': 1500, 'Timing belt replacement': 3000,
'Power steering system service': 2100, 'AC system service and repair': 4020,
'Exhaust system inspection and repair': 2700,
};

List<ShopModel> shopdata = [ ShopModel(
shopname: 'A to Z Motor Cycle Service Center',
 
shopaddress:
'R26C+PQX, Bajanai kovil Main Rd, Kavanur R.F.R[31]C, Tamil Nadu 603203',
shopphone: '+91 9892327504',
),
ShopModel(
shopname: 'S-Drive Multibrand Car Service - Perumbakkam', shopaddress:
'No 8, 202c, Nookampalayam Rd, Perumbakkam, Chennai, Tamil Nadu 600126',
shopphone: '+91 9196937586',
),
ShopModel(
shopname: 'Vijay Automobiles Kattankulathur (car and bike)',
shopaddress:
'No 20 , Humming bird street, near Vgn Southern Avenue, apts, Kattankulathur, Tamil Nadu 603203',
shopphone: '+91 9395562173',
),
ShopModel(
shopname: 'Yamaha Service Centre (Bikes)', shopaddress:
'No.50, NH-1, Vallal MGR Salai, Opp. Railway Station, Maraimalai Nagar, Tamil Nadu 603209',
shopphone: '+91 95660 09898',
),
ShopModel(
shopname: 'Maruti Suzuki Service (Vishnu Cars)', shopaddress:
'No 19, GST Rd Potheri, Kattankulathur, Guduvancheri, Tamil Nadu 603202',
shopphone: '044 6620 5616',
),
ShopModel(
shopname: 'MG Automobile ( Car and Bike)',
 
shopaddress: 'Pillayar Koil St, Potheri, Kattankulathur, Tamil Nadu 603203',
shopphone: '+91 9854056414',
),
ShopModel(
shopname: 'MAHARAJA AUTO MOBILE & GARAGE (Car and Bike)', shopaddress:
'Thailavaram Bus Stop, Thailavaram Village R2JW+9MG Chennai - Theni Highway, Chennai - Theni Hwy, Potheri, Kattankulathur, TamilNadu 603202',
shopphone: '+91 9618683380',
),
];

Map finaldata = {
// sample
'name': 'dhanush', 'cars': {
'key': {
'carmaker': 'carmaker', 'carmodel': 'carmodel',
},
},
'services': { 'servicekey': {
'carkey':   'carkey', 'shopname': 'shopname', 'servicename': 'servicename', 'serviceprice': 'serviceprice', 'servicedate': 'servicedate', 'servicetime': 'servicetime',
'notes': 'notes of the service',
'paymentstatus': 'paymentstatus', // completed, pending
},
},
};
 
// decision.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; import 'package:vehicle_maintenance_app/services/constants.dart';

logindecision() async { SharedPreferences sharedpref = await
SharedPreferences.getInstance();
String? spuserkey = sharedpref.getString('userkey'); String? spusername = sharedpref.getString('username');

if (spuserkey != null && spusername != null && spuserkey != '' && spusername != '') {
print(spuserkey); userkey = spuserkey; username = spusername; return '/home';
} else {
return '/login';
}
}







// global.dart

import 'package:flutter/material.dart';

double globalpadding = 15;
 
const Color maintheme = Color(0xff5658D6); const Color darktext = Color(0xff090446); TextStyle subtitle = TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold, color: darktext,
);

// historyscreen.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart'; import 'package:vehicle_maintenance_app/services/constants.dart'; import
'package:vehicle_maintenance_app/services/user_services.dart'; import 'package:vehicle_maintenance_app/widgets/servicetile.dart';

class historyScreen extends StatefulWidget {
const historyScreen({Key? key}) : super(key: key);

@override
State<historyScreen> createState() => _historyScreenState();
}

class _historyScreenState extends State<historyScreen> { Map<String, List<DocumentSnapshot>> carservices = {};
final UserServices userServices = UserServices(); Future<Map<String, List<DocumentSnapshot>>> getdata() async {
QuerySnapshot	querySnapshot	=	await userServices.getserviceswithuserkey();
carservices.clear();
for	(DocumentSnapshot	documentSnapshot	in querySnapshot.docs) {
carservices.putIfAbsent(documentSnapshot.get('carkey'), () => []);
carservices[documentSnapshot.get('carkey').toString()]
?.add(documentSnapshot);
}
return carservices;
}

@override
Widget build(BuildContext context) {
 
return Scaffold( appBar: AppBar(
elevation:   0, centerTitle: true, scrolledUnderElevation: 0,
automaticallyImplyLeading: false, backgroundColor: Colors.white, title: Text(
'History', style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),
body: Container(
child: FutureBuilder( future: getdata(),
builder: (context, snapshot) {
if (snapshot.hasData && snapshot.data!.length != 0)
{
return ListView.builder(
padding: EdgeInsets.symmetric(vertical: 15), physics:   BouncingScrollPhysics(), itemCount: snapshot.data!.length, itemBuilder: (context, i) {
return section(
carkey: snapshot.data!.keys.elementAt(i), documentSnapshot:
snapshot.data!.values.elementAt(i),
);
},
);
 

== 0) {
 
} else if (snapshot.hasData && snapshot.data!.length

return Center( child: Text(
'No Service History Found', style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold, color: darktext,
),
 
),
);
} else
return Center(child: CircularProgressIndicator());
},
),
),
);
}

Widget section(
 
{required String carkey,
required List<DocumentSnapshot> documentSnapshot}) { return Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
SizedBox( height: 5,
),
Container(
padding:	EdgeInsets.symmetric(horizontal:	15,
vertical: 10),
child: FutureBuilder( future:

userbase.doc(userkey).collection('cars').doc(carkey).get(), builder: (context, snapshot) {
if (snapshot.hasData) { return Text(
snapshot.data!.get('carmaker') + ' ' +
snapshot.data!.get('carmodel') + ": ",
style: TextStyle( fontSize: 16,
fontWeight: FontWeight.bold, color: darktext,
),
);
} else
return Container(
padding: EdgeInsets.symmetric(vertical: 10),
width: 60,
child: LinearProgressIndicator(),
);
}),
),
Column( children: [
for (DocumentSnapshot ds in documentSnapshot) serviceTile(documentSnapshot: ds),
],
),
],
);
}
}


// homescreen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
import 'package:vehicle_maintenance_app/global.dart'; import
'package:vehicle_maintenance_app/screens/mainscreens/dashboard. dart';
import 'package:vehicle_maintenance_app/screens/mainscreens/historyscr een.dart';
import 'package:vehicle_maintenance_app/screens/mainscreens/schedulesc reen.dart';
import 'package:vehicle_maintenance_app/screens/payment/billingmain.da rt';
import 'package:vehicle_maintenance_app/services/constants.dart'; import 'package:vehicle_maintenance_app/widgets/loadingblock.dart';

class homeParent extends StatefulWidget {
const homeParent({Key? key}) : super(key: key);


@override
State<homeParent> createState() => _homeParentState();
}


class _homeParentState extends State<homeParent> { late PageController pageController;

int bottomindex = 2; double globalpadding = 15;
TextStyle dummystyle = TextStyle( fontSize: 25,
fontWeight: FontWeight.bold, color: darktext,
);
 
GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

void changePage(int pageindex) { setState(() {
bottomindex = pageindex; pageController.animateToPage(pageindex,
duration: Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
});
}


@override
void initState() {
// TODO: implement initState super.initState();
pageController = PageController(initialPage: bottomindex);
}

@override
Widget build(BuildContext context) { return Scaffold(
key: _globalKey,
// appBar: AppBar(), body: PageView(
controller: pageController, physics: BouncingScrollPhysics(), onPageChanged: (i) {
setState(() { bottomindex = i;
});
},
children: [ billingMain(),
// Container(
//	alignment: Alignment.center,
 
//	child: Text(
//	'Schedule',
//	style: dummystyle,
//	),
// ), scheduleScreen(),
Dashboard(mykey: _globalKey), historyScreen(),
// Container(
//	alignment: Alignment.center,
//	child: Text(
//	'History',
//	style: dummystyle,
//	),
// ), Container(
alignment: Alignment.center, child: Text(
'Messages', style: dummystyle,
),
),
],
),
endDrawer: Drawer( backgroundColor: maintheme, width: 300,
shape: RoundedRectangleBorder( borderRadius: BorderRadius.only(
topLeft: Radius.circular(22), bottomLeft: Radius.circular(22),
),
),
child: Container( child: Column(
children: [
 
SizedBox( height: 100,
),
Container(
margin: EdgeInsets.only(left: 25), child: Row(
children: [ Card(
elevation: 7,
shape: CircleBorder(), child: CircleAvatar(
radius: 35, child: ClipRRect(
borderRadius: BorderRadius.circular(200),
child: Image.asset('assets/images/profilephoto.png'),
),
backgroundColor: Colors.black,
),
),
SizedBox( width: 15,
),
Expanded( child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Welcome', style: TextStyle(
fontWeight: FontWeight.bold, fontSize: 20,
color: Colors.white,
),
 
),
SizedBox( height: 5,
),
Text(
username, maxLines: 1,
overflow: TextOverflow.ellipsis, style: TextStyle(
fontSize: 18,
color: Colors.white,
),
),
],
),
),
SizedBox( width: 15,
),
],
),
),
SizedBox( height: 35,
),
Column( children: [
draweritem(
title: 'Vehicle',
icon: Icons.car_rental_rounded,
),
draweritem(
title: 'Settings',
icon: Icons.settings_rounded,
),
draweritem(
 
title: 'Help',
icon: Icons.help_outline_rounded,
),
draweritem( title: 'About',
icon: Icons.info_outline_rounded,
),
draweritem( title: 'Invite',
icon: Icons.insert_invitation_rounded,
),
draweritem(
title: 'Log Out',
icon: Icons.logout_rounded, onPressed: () async {
loadingBlock(context: context); await firebaseAuth.signOut(); SharedPreferences sharedpref =
await SharedPreferences.getInstance();
sharedpref.setString('userkey', ''); sharedpref.setString('username', ''); Navigator.pop(context); Navigator.pushReplacementNamed(context,
'/login');
},
),
],
),
Spacer(), Row(
mainAxisAlignment: MainAxisAlignment.center, children: [
Text(
'VehiCare', style: TextStyle(
 
fontWeight: FontWeight.bold, fontSize: 30,
color: Colors.white,
),
),
SizedBox( width: 20,
),
// Icon(
//	Icons.car_crash_rounded,
//	color: Colors.red,
//	size: 60,
// ), Container(
height: 60,
width: 60,
decoration: BoxDecoration( boxShadow: [
BoxShadow( blurRadius: 20,
color: Colors.black.withAlpha(50),
),
],
),
child: Image.asset( 'assets/images/logo_black.png', color: Colors.white,
),
),
],
),
SizedBox( height: 30,
),
],
),
 
),
),
bottomNavigationBar: BottomNavigationBar( backgroundColor: maintheme,
type: BottomNavigationBarType.fixed, currentIndex: bottomindex, selectedFontSize: 12,
unselectedFontSize: 10,
iconSize: 25,
selectedItemColor: Colors.white, unselectedItemColor: Colors.white.withAlpha(150), onTap: (index) {
setState(() { changePage(index);
});
},
items: [ BottomNavigationBarItem(
icon: Icon(Icons.currency_rupee_rounded), label: 'Billing',
),
BottomNavigationBarItem(
icon: Icon(Icons.schedule_rounded), label: 'Schedule',
),
BottomNavigationBarItem(
icon: Icon(Icons.dashboard_customize_rounded), label: 'Dashboard',
),
BottomNavigationBarItem(
icon: Icon(Icons.history_edu_rounded), label: 'History',
),
BottomNavigationBarItem(
icon: Icon(Icons.message_rounded), label: 'Messages',
 
),
],
),
);
}


Widget draweritem(
{title = 'title', required IconData icon, Function? onPressed}) {
return TextButton( onPressed: () {
if (onPressed != null) { onPressed();
}
},
style: TextButton.styleFrom( foregroundColor: Colors.white, shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
),
child: Container(
margin: EdgeInsets.only(top: 8, bottom: 8, left: 35), child: Row(
children: [ Icon(
icon, size: 20,
color: Colors.white,
),
SizedBox( width: 15,
),
Text(
title,
style: TextStyle(
 
fontSize:   18, color: Colors.white,
),
),
],
),
),
);
}
}












// loadingblock.dart

import 'package:flutter/material.dart';

loadingBlock({required BuildContext context, bool exitable = false}) {
showDialog( context: context,
barrierDismissible: false,
builder: (context) => WillPopScope( onWillPop: () async {
return exitable;
},
child: AlertDialog(
contentPadding: EdgeInsets.symmetric(vertical: 30), content: Container(
height: 50,
width: 50,
 
child: FittedBox(
child: CircularProgressIndicator( strokeWidth: 3,
),
),
),
),
),
);
}


// loginpage.dart

import 'package:firebase_auth/firebase_auth.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart'; import
'package:vehicle_maintenance_app/screens/mainscreens/homeparent
.dart';
import 'package:vehicle_maintenance_app/screens/signup.dart'; import 'package:vehicle_maintenance_app/services/constants.dart'; import 'package:vehicle_maintenance_app/services/user_auth.dart';

class LoginPage extends StatefulWidget {
const LoginPage({Key? key}) : super(key: key);


@override
State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> { TextEditingController emailcontroller =
TextEditingController();
 
TextEditingController passwordcontroller = TextEditingController();
Authentication _authentication = Authentication();

String errortext = '';
bool obscurepassword = true; bool loading = false;
bool remember = true;

login() async {
String email, password; setState(() {
loading = true;
});

email = emailcontroller.text; password = passwordcontroller.text; if (email != '' && password != '') {
var result = await _authentication.loginUser(email, password);
if (result.runtimeType == UserCredential) { Navigator.pushReplacementNamed(context, '/home');
} else if (result.toString().contains('invalid-email')) { setState(() {
errortext = 'Invalid email Format';
});
} else if (result.toString().contains('user-not-found'))
{
showDialog( context: context,
builder: (context) => AlertDialog( contentPadding: EdgeInsets.all(50), title: Text(
'User not Found', style: TextStyle(
fontWeight: FontWeight.bold,
 
fontSize: 20,
),
),
content: Text(
"Do you Want to SIGNUP ??", style: TextStyle(
fontSize: 18,
),
),
actions: [ TextButton(
onPressed: () { Navigator.pop(context);
},
style: TextButton.styleFrom(), child: Text(
"Cancel",
style: TextStyle(),
),
),
SizedBox( width: 10,
 





'/signup');
 
),
OutlinedButton( onPressed: () {
Navigator.pushReplacementNamed(context,
 
},
style: TextButton.styleFrom( backgroundColor: maintheme, foregroundColor: Colors.white,
),
child: Text( "Sign Up",
style: TextStyle( color: Colors.white,
 
fontWeight: FontWeight.bold,
),
),
),
],
),
);
} else if (result.toString().contains('wrong-password'))
{
setState(() {
errortext = 'Oops, Wrong Password!!';
});
} else { setState(() {
errortext = 'Login Successfully Failed';
});
}
}
setState(() { loading = false;
});
}


bool rem = true; @override
Widget build(BuildContext context) { return Scaffold(
body: SafeArea( child: Container(
padding: EdgeInsets.symmetric(horizontal: 15), child: Column(
children: [ Row(
mainAxisAlignment: MainAxisAlignment.end, children: [
TextButton(
 



'/signup');
 
onPressed: () { Navigator.pushReplacementNamed(context,

},
child: Text( "Sign Up",
style: TextStyle(
fontWeight: FontWeight.bold,
 
),
),
),
],
),
Expanded(
child: SingleChildScrollView( physics: BouncingScrollPhysics(), child: Container(
// height: MediaQuery.of(context).size.height,
child: Column( mainAxisAlignment:
MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [ SizedBox(
height: 50,
),
Row(),
// Container(
//	child: Icon(
//	Icons.car_crash_sharp,
//	color: Colors.redAccent,
//	size: 100,
//	),
// ),
 
Container( height: 150,
width: 150,
child: Image.asset( 'assets/images/logo_color.png',
),
),
SizedBox( height: 10,
),
Text(
"VehiCare", style: TextStyle(
color: maintheme, fontWeight: FontWeight.bold, fontSize: 35,
),
),
SizedBox( height: 30,
 



















OutlineInputBorder(
 
),
Container( height: 60,
child: TextField(
controller: emailcontroller, style: TextStyle(
fontSize: 18,
),
decoration: InputDecoration( hintText: 'Email', hintStyle: TextStyle(
color: Colors.grey, fontSize: 18,
),
focusedBorder:
 

BorderRadius.circular(12),








OutlineInputBorder(

BorderRadius.circular(12),









),
 
borderRadius:

borderSide: BorderSide( color: maintheme, width: 1,
),
),
enabledBorder:

borderRadius:

borderSide: BorderSide( color: maintheme, width: 0.5,
),
),
),
),
 
SizedBox( height: 20,
 










passwordcontroller,
 
),
Row(
children: [ Expanded(
child: Container( height: 60, child: TextField(
controller:

style: TextStyle( fontSize: 18,
 
),
obscureText: obscurepassword, obscuringCharacter: '*', decoration: InputDecoration(
 
hintText: 'Password', hintStyle: TextStyle( color: Colors.grey,
fontSize: 18,
 



OutlineInputBorder(

BorderRadius.circular(12),
 
),
focusedBorder:

borderRadius:

borderSide: BorderSide( color: maintheme, width: 1,
),
 



OutlineInputBorder(

BorderRadius.circular(12),
 
),
enabledBorder:

borderRadius:

borderSide: BorderSide( color: maintheme, width: 0.5,
),
 
),
),
),
),
),
 









!obscurepassword;
 
SizedBox( width: 5,
),
IconButton( onPressed: () {
setState(() { obscurepassword =

});
 
},
icon: (obscurepassword)
?
(Icon(Icons.visibility_outlined))
:
(Icon(Icons.visibility_off_outlined)),
),
],
),
SizedBox( height: 5,
 










(false) : (true);
 
),
Row(
children: [ TextButton(
onPressed: () {
setState(() { remember =
(remember == true) ?
 





15),
 
});
},
style: TextButton.styleFrom( padding: EdgeInsets.only(right:

),
child: Row( children: [
Checkbox(
value:   remember, shape: CircleBorder(), activeColor: maintheme,
checkColor: Colors.white, onChanged: (res) {},
 
),
Text(
 
'Remember Me', style: TextStyle(
color: Colors.black, fontSize: 12,
),
),
],
),
),
Spacer(), TextButton(
onPressed: () {}, child: Text(
'Forgot Password?', style: TextStyle(
color: maintheme, fontSize: 14,
),
),
),
],
),
SizedBox( height: 20,
),
TextButton(
onPressed: (loading == true)
? (null)
: (() {
login();
}),
style: TextButton.styleFrom( backgroundColor: maintheme, foregroundColor: Colors.white, padding: EdgeInsets.zero, shape: RoundedRectangleBorder(
 

BorderRadius.circular(12),







MainAxisAlignment.center,
 
borderRadius:

),
),
child: Row(
mainAxisSize: MainAxisSize.max, mainAxisAlignment:

children: [ (loading == true)
? (CircularProgressIndicator( color: Colors.white,
 





Alignment.center,
 
))
: (Container(
height: 60, alignment:

child: Text( "Log in",
style: TextStyle( color: Colors.white, fontSize: 20,
),
),
)),
],
),
),
 
SizedBox( height: 50,
),
Text(
errortext,
style: TextStyle( color: Colors.red,
fontWeight: FontWeight.bold,
 
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
),
);
}
}


// ongenerateroute.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/models/servicemodel.dart'; import 'package:vehicle_maintenance_app/screens/addnewcar.dart'; import 'package:vehicle_maintenance_app/screens/loginpage.dart'; import 'package:vehicle_maintenance_app/screens/mainscreens/homeparent
.dart'; import
'package:vehicle_maintenance_app/screens/payment/paymentscreen. dart';
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched uleappointment.dart';
 
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched uleconfirmation.dart';
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched ulereview.dart';
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched uleshop.dart';
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched ulesuccess.dart';
import 'package:vehicle_maintenance_app/screens/signup.dart'; import 'package:vehicle_maintenance_app/screens/upcoming_appointments. dart';

class RouteGenerator {
static Route generateRoute(RouteSettings settings) { final args = settings.arguments;
switch (settings.name) {
// main screens case '/login':
return MaterialPageRoute(builder: (_) => LoginPage());

case '/signup':
return MaterialPageRoute(builder: (_) => SignUp());

case '/home':
return MaterialPageRoute(builder: (_) => homeParent());

//anonymous
case '/addnewvehicle':
return MaterialPageRoute(builder: (_) => addNewCar());

case '/upcomingappointments':
 
if (args is List) {
return MaterialPageRoute(
builder: (_) => upcomingAppointmentScreen( carkey: args[0],
title: args[1],
));
} else
return errorroute();

//scheduling routes case '/scheduleshop':
if (args is ServiceModel) { return MaterialPageRoute(
builder: (_) => scheduleShop(serviceModel:
 
args));
 

} else
return errorroute();
 
case '/schedulereview':
if (args is ServiceModel) return MaterialPageRoute(
builder: (_) => scheduleReview(serviceModel:
 
args));
 

else
return errorroute();
 
case '/scheduleappointment': if (args is ServiceModel)
return MaterialPageRoute(
builder: (_) => scheduleAppointment(serviceModel:
 
args));
 

else
return errorroute();
 
case '/scheduleconfirmation': if (args is ServiceModel)
return MaterialPageRoute( builder: (_) =>
scheduleConfirmation(serviceModel: args));
 
else
return errorroute();

case '/schedulesuccess':
return MaterialPageRoute(builder: (_) => scheduleSuccess());

//payment screen routes case '/paymentscreen':
if (args is List<DocumentSnapshot>) return MaterialPageRoute(
builder: (_) => paymentScreen( servicesnapshots: args,
));
else
return errorroute();


// default default:
return errorroute();
}
}


static Route errorroute() {
return MaterialPageRoute(builder: (_) { return Scaffold(
appBar: AppBar(
title: Text("Error Page"),
),
);
});
}
}


// schedule order
 
// 1. schedule shop
// 2. schedule review
// 3. schedule appointment
// 4. schedule confirmation
// 5. schedule success

// payment_services.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:vehicle_maintenance_app/services/constants.dart';

class PaymentServices { payforService(List<DocumentSnapshot> snapshots) async {
for (DocumentSnapshot doc in snapshots) { await
userbase.doc(userkey).collection('services').doc(doc.id).update ({
'paymentstatus': 'completed',
});
}
}
}


// paymentscreen.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart'; import
'package:vehicle_maintenance_app/screens/payment/paymentsuccess full.dart';
import 'package:vehicle_maintenance_app/services/payment_services.dart ';
 
import 'package:vehicle_maintenance_app/widgets/carcarousal.dart'; import 'package:vehicle_maintenance_app/widgets/loadingblock.dart';

TextStyle cardhead = TextStyle( fontSize: 13,
color: Colors.white,
);
TextStyle cardans = TextStyle( fontSize: 15,
color: Colors.white,
);

class paymentScreen extends StatefulWidget { final List<DocumentSnapshot> servicesnapshots; const paymentScreen({Key? key, required
this.servicesnapshots})
: super(key: key);


@override
State<paymentScreen> createState() => _paymentScreenState();
}


class _paymentScreenState extends State<paymentScreen> { int totalprice = 0;
PaymentServices paymentServices = PaymentServices();

payservices() async { await
paymentServices.payforService(widget.servicesnapshots); print('completed');
}

getConfirmation(BuildContext context) { showDialog(
 
context: context, builder: (context) {
return CupertinoAlertDialog(
title: Text('Are you sure you want to complete payment?\n₹ ' +
totalprice.toString()), actions: [
CupertinoDialogAction( child: Text('Cancel'), onPressed: () {
Navigator.pop(context);
},
),
CupertinoDialogAction( child: Text('Yes'), onPressed: () async {
loadingBlock(context: context); await payservices();
Navigator.pop(context); // to pop loading block Navigator.pop(context); // to pop dialog box Navigator.pushNamedAndRemoveUntil(
context, '/home',
(route) => false,
);
Navigator.push( context, MaterialPageRoute(
builder: (context) => paymentSuccessfullScreen()));
},
),
],
);
},
);
 
}

calculatetotal() {
for (DocumentSnapshot doc in widget.servicesnapshots) { totalprice += int.parse(doc.get('serviceprice'));
}
}


@override
void initState() {
// TODO: implement initState super.initState(); calculatetotal();
}

@override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar( automaticallyImplyLeading: false, backgroundColor: Colors.white, elevation: 0,
centerTitle: true, scrolledUnderElevation: 0, leading: TextButton(
onPressed: () { Navigator.pop(context);
},
child: Text( 'Cancel',
style: TextStyle(
fontWeight: FontWeight.bold, fontSize: 15,
),
),
),
 
leadingWidth: 100, title: Text(
"Payment",
style: TextStyle( color: darktext,
fontWeight: FontWeight.bold,
),
),
),
body: Container(
// padding: EdgeInsets.symmetric(horizontal: 15), child: Column(
children: [ SizedBox(
height: 15,
),
Row(
children: [ SizedBox(
width: 20,
),
Text(
'LINKED CARDS',
style: TextStyle( fontSize: 14,
fontWeight: FontWeight.bold,
),
),
Spacer(), Text(
'ADD NEW',
style: TextStyle( fontSize: 14, color: maintheme,
fontWeight: FontWeight.bold,
),
 
),
SizedBox( width: 20,
),
],
),
SizedBox( height: 10,
),
Container( height: 260,
child: carCarousal( items: [
buildCreditCard(), buildCreditCard(), buildCreditCard(),
],
),
),
SizedBox( height: 15,
),
Expanded(
child: Padding(
padding: EdgeInsets.symmetric(horizontal: 15), child: Column(
children: [ Expanded(
child: Card( elevation: 7,
surfaceTintColor: Colors.white, color: Colors.white,
child: Container(
padding: EdgeInsets.all(25), width:
MediaQuery.of(context).size.width,
 
child: Column( children: [
Row(
mainAxisAlignment:


 
MainAxisAlignment.spaceBetween,
 

children: [ Expanded(
child: Column( crossAxisAlignment:
 

CrossAxisAlignment.start,
mainAxisAlignment:


 
MainAxisAlignment.start,
 

children: [ Text(
 

 
widget.servicesnapshots.first





FontWeight.bold,
 

.get('shopname'), style: TextStyle(
fontSize: 16, fontWeight:

),
),
SizedBox( height: 5,
),
Text(
 


widget.servicesnapshots.first


 
.get('servicedate'),
 

style: TextStyle( fontSize: 14,
 

FontWeight.bold,

darktext.withAlpha(100),
 
fontWeight:

color:

),
),
],
),
),
 
IconButton( onPressed: () {}, icon: Icon(

 
Icons.info_outline_rounded,
 

color: maintheme,
),
),
],
),
 
SizedBox( height: 15,
),
Expanded(
child: ListView.builder( itemCount:
 
widget.servicesnapshots.length,

BouncingScrollPhysics(),




widget.servicesnapshots[i]

.get('servicename'),

widget.servicesnapshots[i]
 

physics:

itemBuilder: (context, i) { return billdetails(
servicename:




price:
 
.get('serviceprice'),
 

);
}),
),
 







MainAxisAlignment.end,




totalprice.toString(),





FontWeight.bold,
 
SizedBox( height: 10,
),
Row(
mainAxisAlignment:

children: [ Text(
'Total: ₹ ' +

style: TextStyle( color: maintheme, fontSize: 18, fontWeight:
 
),
),
],
),
 









BorderRadius.circular(10),
 
SizedBox( height: 10,
),
Row(
children: [ ClipRRect(
borderRadius:

child: Container( height: 30,
width: 50,
child: Image.asset(
 
'assets/images/creditcardbg.jpg',
),
),
),
SizedBox( width: 10,
 









FontWeight.bold,
 
),
Text(
'My Personal Card', style: TextStyle(
color: Colors.black, fontSize: 14, fontWeight:
 
),
),
],
)
],
),
),
),
),
SizedBox( height: 15,
),
],
),
),
),
Padding(
padding: EdgeInsets.symmetric(vertical: 15,
horizontal: 15),
child: OutlinedButton( onPressed: () {
 
getConfirmation(context);
},
style: OutlinedButton.styleFrom( backgroundColor: Colors.white, foregroundColor: Colors.red,
padding: EdgeInsets.symmetric(vertical: 17), shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
side: BorderSide( width: 1,
color: Colors.red,
),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.center, children: [
Text(
'Complete Payment', style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold, color: Colors.red,
),
),
],
),
),
),
],
),
),
);
}
}
 
class billdetails extends StatelessWidget { final String servicename;
final String price;
const billdetails({Key? key, this.servicename = 'Detail', this.price = '50'})
: super(key: key);

@override
Widget build(BuildContext context) { return Container(
padding: EdgeInsets.symmetric(vertical: 2), child: Row(
children: [ Expanded(
child: Text( servicename, maxLines: 1,
overflow: TextOverflow.ellipsis, style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold, color: darktext,
),
),
),
SizedBox( width: 15,
),
Text(
'₹ ' + price.toString(), style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold, color: darktext,
),
),
 
],
),
);
}
}


class buildCreditCard extends StatelessWidget {
const buildCreditCard({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) { return ClipRRect(
borderRadius: BorderRadius.circular(22), child: Container(
height: 240,
alignment: Alignment.center,
width: MediaQuery.of(context).size.width - 30, child: Stack(
children: [ Container(
// height: 240,
width: MediaQuery.of(context).size.width, child: Image.asset(
'assets/images/creditcardbg.jpg', fit: BoxFit.fill,
),
),
Container(
// height: 240,
// width: MediaQuery.of(context).size.width, padding: EdgeInsets.all(25),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max,
children: [ Text(
 
'My Personal Card', style: TextStyle(
fontSize: 18,
color: Colors.white, fontWeight: FontWeight.bold,
),
),
SizedBox( height: 25,
),
Expanded( child: Row(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [ Expanded(
flex: 5, child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [ Column(
crossAxisAlignment:
 
CrossAxisAlignment.start,
 

mainAxisSize: MainAxisSize.min, children: [
Text(
'Credit Card Number', style: cardhead,
 




4783',
 
),
Text(
'xxxx - xxxx - xxxx -

style: cardans,
 






CrossAxisAlignment.start,
 
),
],
),
Column( crossAxisAlignment:

mainAxisSize: MainAxisSize.min, children: [
Text(
'Name on the Card', style: cardhead,
 
),
Text(
'DREW FULLER',
style: cardans,
),
],
),
],
),
),
Expanded( flex: 2,
child: Column( crossAxisAlignment:
CrossAxisAlignment.start,
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [ Column(
crossAxisAlignment:
 
CrossAxisAlignment.start,
 

mainAxisSize: MainAxisSize.min, children: [
Text(
'Expiration',
 
style: cardhead,
),
Text(
'09/23',
style: cardans,
 







CrossAxisAlignment.start,
 
),
],
),
Column( crossAxisAlignment:

mainAxisSize: MainAxisSize.min, children: [
Text(
'CVV/CVS',
style: cardhead,
 
),
Text(
'***',
style: cardans,
),
],
),
// Text(
//	'Credit Card Number',
//	style: cardhead,
// ),
// Text(
//	'xxxx - xxxx - xxxx - 4783',
//	style: cardans,
// ),
// Text(
//	'Credit Card Number',
//	style: cardhead,
// ),
// Text(
 
//	'xxxx - xxxx - xxxx - 4783',
//	style: cardans,
// ),
],
),
),
],
),
),
SizedBox( height: 15,
),
],
),
),
Positioned( bottom: 10,
right: 10,
child: IconButton( onPressed: () {}, icon: Icon(
Icons.edit_outlined,
color: Colors.white.withAlpha(150), size: 20,
),
),
),
],
),
),
);
}
}
 
// paymentsuccessful.dart

import 'package:flutter/cupertino.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart';

class paymentSuccessfullScreen extends StatelessWidget {
const paymentSuccessfullScreen({Key? key}) : super(key: key); final String servicehead = "Successfully Paid";
final String servicedes = "Your Payment has been Successfully Completed";
@override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar(
backgroundColor: Colors.white, automaticallyImplyLeading: false, elevation: 0,
centerTitle: true, scrolledUnderElevation: 0, title: Text(
"Confirmation", style: TextStyle(
color:   darktext, fontWeight: FontWeight.bold,
),
),
),
body: Container(
padding: EdgeInsets.all(35), child: Column(
mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
Text(
servicehead,
textAlign: TextAlign.center,
 
style: TextStyle( fontSize: 30,
fontWeight: FontWeight.bold, color: darktext,
),
),
Text(
servicedes,
textAlign: TextAlign.center, style: TextStyle(
fontSize: 18,
),
),
OutlinedButton( onPressed: () {
Navigator.pop(context);
},
style: OutlinedButton.styleFrom( side: BorderSide(
color: maintheme,
),
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),
),
),
child: Container(
padding: EdgeInsets.all(15), child: Text(
'Back to Billing Menu', style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
),
 
Container( height: 150,
width: 150,
child: Image.asset( 'assets/images/logo_color.png',
),
),
SizedBox( height: 60,
),
],
),
),
);
}
}





// paymenttiles.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart';

class recentTransactionsTile extends StatelessWidget {
const recentTransactionsTile({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) { return Column(
children: [ TextButton(
onPressed: () {},
style: TextButton.styleFrom( backgroundColor: Colors.white,
 
foregroundColor: maintheme, shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
child: Container( child: Row(
children: [ Expanded(
child: Column( crossAxisAlignment:
CrossAxisAlignment.start,
children: [ SizedBox(
height: 5,
),
Text(
'MIDAS',
style: TextStyle( color: darktext, fontSize: 14,
fontWeight: FontWeight.bold,
),
),
SizedBox( height: 5,
),
Text(
'February 02, 2019', style: TextStyle(
color: darktext.withAlpha(100), fontSize: 13,
),
),
Text(
'Tires, Brakes',
 
style: TextStyle(
color: darktext.withAlpha(100), fontSize: 13,
),
),
],
),
),
Row(
children: [ Text(
'\$ 125',
style: TextStyle( fontSize: 20, color: maintheme,
fontWeight: FontWeight.bold,
),
),
Icon(
Icons.chevron_right_rounded, color: darktext,
size: 35,
),
],
),
],
),
),
),
Divider(
color: darktext.withAlpha(100),
),
],
);
}
}
 
class PaynowTile extends StatelessWidget { final DocumentSnapshot snapshot;
const PaynowTile({Key? key, required this.snapshot}) : super(key: key);

@override
Widget build(BuildContext context) { return Card(
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),
),
color: Colors.white, elevation: 7,
surfaceTintColor: Colors.white, child: Container(
padding: EdgeInsets.all(15), child: Row(
children: [ Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
Text(
snapshot.get('shopname'), maxLines: 1,
overflow: TextOverflow.ellipsis, style: subtitle.copyWith(
fontSize: 15,
),
),
SizedBox( height: 7,
),
Text(
snapshot.get('servicedate'),
 
style: TextStyle(
color: darktext.withAlpha(100), fontSize: 13,
),
),
SizedBox( height: 4,
),
Text(
snapshot.get('servicename'), style: TextStyle(
color: darktext.withAlpha(100), fontSize: 13,
),
),
],
),
),
SizedBox( width: 15,
),
Column( children: [
Text(
'₹ ' +
snapshot.get('serviceprice').toString(),
style: TextStyle( fontSize: 18,
fontWeight: FontWeight.bold, color: maintheme,
),
),
SizedBox( height: 10,
),
OutlinedButton(
 
onPressed: () { Navigator.pushNamed(
context, '/paymentscreen', arguments: [snapshot],
);
},
style: OutlinedButton.styleFrom( backgroundColor: Colors.white, foregroundColor: Colors.red, shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
side: BorderSide( color: Colors.red, width: 1,
),
),
child: Text( 'Pay Now',
style: TextStyle( color: Colors.red, fontSize: 15,
),
),
),
],
),
],
),
),
);
}
}
 
// scheduleappointment.dart

import 'package:flutter/cupertino.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/commonvars.dart'; import 'package:vehicle_maintenance_app/data.dart'; import 'package:vehicle_maintenance_app/global.dart'; import
'package:vehicle_maintenance_app/models/servicemodel.dart'; import 'package:vehicle_maintenance_app/screens/schedules_screen/sched uleconfirmation.dart';

class scheduleAppointment extends StatefulWidget { final ServiceModel serviceModel;
const scheduleAppointment({Key? key, required this.serviceModel})
: super(key: key);

@override
State<scheduleAppointment> createState() =>
_scheduleAppointmentState();
}

class _scheduleAppointmentState extends State<scheduleAppointment> {
int? servicevalue;
DateTime selecteddate = DateTime.now(); TimeOfDay selectedtime =
TimeOfDay.fromDateTime(DateTime.now()); TextEditingController notes = TextEditingController();

@override
Widget build(BuildContext context) { return Scaffold(
resizeToAvoidBottomInset: false,
 
appBar: AppBar(
backgroundColor: Colors.white, elevation: 0,
centerTitle: true, scrolledUnderElevation: 0, leading: IconButton(
onPressed: () { Navigator.pop(context);
},
icon: Icon( CupertinoIcons.left_chevron, color: darktext,
),
),
title: Text( "Schedule", style: TextStyle(
color:   darktext, fontWeight: FontWeight.bold,
),
),
),
body: Container(
padding: EdgeInsets.symmetric(horizontal: 15), child: Column(
children: [ Expanded(
child: SingleChildScrollView( physics: BouncingScrollPhysics(), child: Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
SizedBox( height: 15,
),
Text(
 
'SELECT SERVICE',
style: subtitle,
),
SizedBox( height: 10,
),
Row(
children: [ Expanded(
child: Container( padding:
EdgeInsets.symmetric(horizontal: 15),
decoration: BoxDecoration( borderRadius:
 
BorderRadius.circular(12),











services.length; i++)
 

border: Border.all( width: 1,
color: maintheme,
),
),
child: DropdownButton( items: [
for (int i = 0; i <

DropdownMenuItem( value: i, child:
 
Text(services.keys.elementAt(i)),
),
],
value: servicevalue, alignment:
AlignmentDirectional.centerStart,
borderRadius:
BorderRadius.circular(12),
isExpanded: true,
 
style: TextStyle( fontSize: 16, color: darktext,
),
underline: Container(), hint: Text('Services'), icon: Icon(
CupertinoIcons.chevron_down, size: 20,
color: darktext,
),
onChanged: (a) { setState(() {
servicevalue = a;
});
},
),
),
),
],
),
SizedBox( height: 20,
),
Text(
'SELECT DATE AND TIME',
style: subtitle,
),
SizedBox( height: 10,
),
Row(
children: [ Expanded(
flex: 5,
child: TextButton(
 



showDatePicker(








selecteddate) {
 
onPressed: () async {
DateTime? picked = await

context: context, initialDate: selecteddate, firstDate: DateTime.now(), lastDate: DateTime(2025, 2),
);
if (picked != null && picked !=

setState(() { selecteddate = picked; print(selecteddate);
});
 












BorderRadius.circular(12),
 
}
},
style: TextButton.styleFrom( side: BorderSide(
width: 1,
color: maintheme,
),
shape: RoundedRectangleBorder( borderRadius:

),
),
child: Container( padding:
 
EdgeInsets.symmetric(vertical: 5),
child: Text( selecteddate.day.toString() +
' / ' +
months[selecteddate.month]
+
' / ' +
 
selecteddate.year.toString() +



+
 

' ( ' +
days[selecteddate.weekday]

' )',
style: TextStyle( color: darktext,
fontWeight: FontWeight.bold,
),
),
 
),
),
),
SizedBox( width: 10,
 








showTimePicker(
 
),
Expanded( flex: 3,
child: TextButton( onPressed: () async {
TimeOfDay? pickedtime = await

context: context, initialTime:
 

TimeOfDay.fromDateTime(DateTime.now()),
);
if (pickedtime != null) { setState(() {
selectedtime = pickedtime;
});
}
},
style: TextButton.styleFrom( side: BorderSide(
 






BorderRadius.circular(12),
 
width: 1,
color: maintheme,
),
shape: RoundedRectangleBorder( borderRadius:

),
),
child: Container( padding:
 
EdgeInsets.symmetric(vertical: 5),
child: Text(

selectedtime.hourOfPeriod.toString() +
' : ' +


selectedtime.minute.toString() +
'	' +


selectedtime.period.name.toUpperCase(),
style: TextStyle( color: darktext,
fontWeight: FontWeight.bold,
),
),
),
),
),
],
),
SizedBox( height: 10,
),
Text(
"Note: The date and time will be confirmed by the service provider within 24 hours after
 
scheduling through Vehicle Manager. You'll be notified by email, text or a phone call, based on your preference.",
textAlign: TextAlign.justify, style: TextStyle(
fontSize: 13,
color: darktext.withAlpha(100),
),
),
SizedBox( height: 20,
),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [ Text(
'NOTES',
style: subtitle,
),
IconButton( onPressed: () {}, icon: Icon(
Icons.info_outline_rounded, color: maintheme,
),
)
],
),
SizedBox( height: 10,
),
Container(
child: TextField( controller: notes,
keyboardType: TextInputType.multiline,
 
minLines: 5,
maxLines: 5,
// expands: true, decoration: InputDecoration(
hintText:
'Add additional notes about your visit and/or maintenance need',
border: OutlineInputBorder( borderRadius:
 
BorderRadius.circular(12),
 

borderSide: BorderSide( color: maintheme, width: 1,
),
),
 
),
),
),
SizedBox( height: 500,
),
],
),
),
),
TextButton( onPressed: () {
if (servicevalue != null && selecteddate != null && selectedtime != null) {
print(servicevalue); print(selecteddate.day); print(selectedtime); widget.serviceModel.servicename =
services.keys.elementAt(servicevalue!); widget.serviceModel.serviceprice =
 
services.values.elementAt(servicevalue!).toString();

widget.serviceModel.day = selecteddate.day.toString();
widget.serviceModel.month = (selecteddate.month).toString();
widget.serviceModel.year = selecteddate.year.toString();
widget.serviceModel.hours = selectedtime.hour.toString();
widget.serviceModel.minutes = selectedtime.minute.toString();
widget.serviceModel.notes = notes.text;

Navigator.pushNamed(context, '/scheduleconfirmation',
arguments: widget.serviceModel);
}
widget.serviceModel.printer();
},
style: TextButton.styleFrom( backgroundColor: Colors.white, foregroundColor: maintheme,
padding: EdgeInsets.symmetric(vertical: 17), shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
side: BorderSide( width: 0.5, color: darktext,
),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.center, children: [
 
Text(
'Continue', style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold, color: darktext,
),
),
],
),
),
SizedBox( height: 15,
),
],
),
),
);
}
}


// scheduleconfirmation.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:firebase_auth/firebase_auth.dart'; import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/commonvars.dart'; import 'package:vehicle_maintenance_app/global.dart'; import 'package:vehicle_maintenance_app/models/servicemodel.dart'; import
'package:vehicle_maintenance_app/screens/mainscreens/dashboard. dart';
 
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched ulesuccess.dart';
import 'package:vehicle_maintenance_app/services/constants.dart'; import 'package:vehicle_maintenance_app/services/user_services.dart'; import 'package:vehicle_maintenance_app/widgets/loadingblock.dart';

class scheduleConfirmation extends StatelessWidget { final ServiceModel serviceModel;
scheduleConfirmation({Key? key, required this.serviceModel})
: super(key: key);
final UserServices userServices = UserServices(); @override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar(
backgroundColor: Colors.white, elevation: 0,
centerTitle: true, scrolledUnderElevation: 0, leading: IconButton(
onPressed: () { Navigator.pop(context);
},
icon: Icon( CupertinoIcons.left_chevron, color: darktext,
),
),
title: Text( "Schedule", style: TextStyle(
color: darktext,
 
fontWeight: FontWeight.bold,
),
),
),
body: Container(
padding: EdgeInsets.symmetric(horizontal: 15), child: Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
SizedBox( height: 15,
),
Text(
'IS EVERYTHING CORRECT?',
style: subtitle,
),
SizedBox( height: 10,
),
Card(
surfaceTintColor: Colors.white, elevation: 7,
color: Colors.white,
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),
),
child: Container(
padding: EdgeInsets.all(15), child: Column(
children: [ Text(
// "Oil Change at Jiffy Lube", serviceModel.servicename! +
' at ' + serviceModel.shopmodel!.shopname,
textAlign: TextAlign.center,
 
style: TextStyle( fontSize: 18,
fontWeight: FontWeight.bold, color: darktext,
),
),
SizedBox( height: 20,
),
Row(
mainAxisSize: MainAxisSize.min, mainAxisAlignment:
MainAxisAlignment.start,
children: [ iconMaker(
iconData: CupertinoIcons.clock,
),
SizedBox( width: 20,
),
Container( width: 250, child: Text(
// 'Monday, April 8 at 5:30 PM',

months[int.parse(serviceModel.month!)] +
' ' +
serviceModel.day   + ' at ' + serviceModel.hours + ':' +
serviceModel.minutes, style: TextStyle(
fontSize: 13,
color: darktext.withAlpha(100), fontWeight: FontWeight.bold,
 
),
),
),
],
),
SizedBox( height: 20,
),
Row(
mainAxisSize: MainAxisSize.min, mainAxisAlignment:
MainAxisAlignment.start,
children: [ iconMaker(
iconData: Icons.location_on_outlined,
),
SizedBox( width: 20,
 






Road,\nHanover Park',

+
 
),
Expanded(
child: Container( child: Text(
// 'Jiffy Lube\n756, Barrington

serviceModel.shopmodel!.shopname

'\n' +
 


serviceModel.shopmodel!.shopaddress,
textAlign: TextAlign.start, style: TextStyle(
fontSize: 13,
color: darktext.withAlpha(100), fontWeight: FontWeight.bold,
),
),
 
),
),
],
),
],
),
),
),
SizedBox( height: 20,
),
Text(
'CONTACT INFO',
style: subtitle,
),
SizedBox( height: 10,
),
Card(
surfaceTintColor: Colors.white, color:   Colors.white, elevation: 7,
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),
),
child: Container(
padding: EdgeInsets.all(25), child: Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [ Text(
username,
 
style: TextStyle( color: maintheme, fontSize: 18,
fontWeight: FontWeight.bold,
),
),
IconButton( onPressed: () {}, icon: Icon(
Icons.edit_outlined, color: darktext, size: 20,
),
),
],
),
SizedBox( height: 10,
),
Text(
'+91 1234567890',
style: TextStyle( color: maintheme, fontSize: 14,
fontWeight: FontWeight.bold,
),
),
SizedBox( height: 5,
),
Text(
'themailid@gmail.com', style: TextStyle(
color: maintheme, fontSize: 14,
fontWeight: FontWeight.bold,
 
),
),
],
),
),
),
Spacer(), TextButton(
onPressed: () async { loadingBlock(context: context);
await userServices.addSchedule(serviceModel:
 
serviceModel);
 

Navigator.pop(context); Navigator.pushNamedAndRemoveUntil(
context, '/home',
ModalRoute.withName('/'),
 
);
Navigator.pushNamed(context, '/schedulesuccess');
// removing all from stack and
// pushing home under schedule succes screen
},
style: TextButton.styleFrom( backgroundColor: darktext, foregroundColor: Colors.white,
padding: EdgeInsets.symmetric(vertical: 17), shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
side: BorderSide( width: 0.5, color: darktext,
),
),
child: Row(
 
mainAxisAlignment: MainAxisAlignment.center, children: [
Text(
'Schedule appointment', style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold, color: Colors.white,
),
),
],
),
),
SizedBox( height: 15,
),
],
),
),
);
}
}


// schedulereview.dart

import 'dart:developer';

import 'package:flutter/cupertino.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart'; import 'package:vehicle_maintenance_app/models/servicemodel.dart'; import
'package:vehicle_maintenance_app/screens/mainscreens/homeparent
.dart';
 
import 'package:vehicle_maintenance_app/screens/schedules_screen/sched uleappointment.dart';

class scheduleReview extends StatelessWidget { final ServiceModel serviceModel;
const scheduleReview({Key? key, required this.serviceModel})
: super(key: key);

@override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar(
backgroundColor: Colors.white, elevation: 0,
centerTitle: true, scrolledUnderElevation: 0, leading: IconButton(
onPressed: () { Navigator.pop(context);
},
icon: Icon( CupertinoIcons.left_chevron, color: darktext,
),
),
title: Text( "Schedule", style: TextStyle(
color:   darktext, fontWeight: FontWeight.bold,
),
),
),
body: Container(
padding: EdgeInsets.symmetric(horizontal: 15),
 
child: Column( children: [
Card(
surfaceTintColor: Colors.white, color:   Colors.white, elevation: 7,
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),
),
child: Container(
width: MediaQuery.of(context).size.width, padding: EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [ Expanded(
child: Text(
// 'Jiffy Lube',

serviceModel.shopmodel!.shopname.toString(),
style: TextStyle( fontSize: 18,
fontWeight: FontWeight.bold, color: darktext,
),
),
),
IconButton( onPressed: () {}, icon: Icon(
Icons.favorite_border_rounded, size: 30,
 
),
),
],
),
 












5245',
 
SizedBox( height: 5,
),
ReviewStar(), SizedBox(
height: 10,
),
Text(
// '756, Barrington Road, Hanover Park

serviceModel.shopmodel!.shopaddress, style: subtitle.copyWith(
fontSize: 13,
color: darktext.withAlpha(100),
),
),
SizedBox( height: 5,
),
linkfunc(
icon: Icons.call_outlined, text: 'Call ' +
 

serviceModel.shopmodel!.shopphone.toString(),
),
linkfunc(
icon: Icons.location_on_outlined, text: 'Get Directions',
),
linkfunc(
icon: Icons.browse_gallery_outlined, text: 'Go to Website',
 
),
SizedBox( height: 15,
),
TextButton( onPressed: () {
Navigator.pushNamed(context,
 
'/scheduleappointment',

},
 

arguments: serviceModel);
 





17),
 
style: TextButton.styleFrom( backgroundColor: Colors.white, foregroundColor: maintheme,
padding: EdgeInsets.symmetric(vertical:

shape: RoundedRectangleBorder( borderRadius:
 
BorderRadius.circular(12),
),
side: BorderSide( width: 0.5, color: darktext,
),
),
child: Row( mainAxisAlignment:
MainAxisAlignment.center,
children: [ Text(
'Schedule Appoinement', style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold, color: darktext,
),
),
 
],
),
),
],
),
),
),
SizedBox( height: 5,
),
Row(
children: [ SizedBox(
width: 10,
),
Text(
"REVIEWS",
style: subtitle,
),
Spacer(), IconButton(
onPressed: () {}, icon: Icon(
Icons.filter_alt_outlined, size: 25,
color: darktext,
),
),
SizedBox( width: 10,
),
],
),
SizedBox( height: 0,
),
 
Expanded(
child: SingleChildScrollView( physics: BouncingScrollPhysics(), child: Column(
children: [
for (int i = 0; i < 3; i++) ReviewTile(),
],
),
),
),
TextButton( onPressed: () {},
child: Text('See all Reviews'),
),
],
),
),
);
}


Widget linkfunc({required IconData icon, required String text}) {
return TextButton( onPressed: () {},
style: TextButton.styleFrom( padding: EdgeInsets.symmetric(
vertical: 0,
horizontal: 10,
),
),
child: Row( children: [
Icon(
icon,
color: maintheme, size: 20,
 
),
SizedBox( width: 10,
),
Text(
text,
style: TextStyle( color: darktext, fontSize: 14,
fontWeight: FontWeight.bold,
),
)
],
),
);
}
}


class ReviewTile extends StatelessWidget {
const ReviewTile({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) { return Column(
children: [ TextButton(
onPressed: () {},
style: TextButton.styleFrom( backgroundColor: Colors.white, foregroundColor: maintheme, shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
child: Container( child: Row(
 
children: [ Expanded(
child: Column( crossAxisAlignment:
CrossAxisAlignment.start,
children: [ Row(
children: [ ReviewStar(
a: 2,
),
SizedBox( width: 10,
),
Text(
'1 Week ago', style: TextStyle(
color: darktext.withAlpha(100), fontSize: 13,
),
),
],
),
SizedBox( height: 5,
),
Text(
'by John Butler', style: TextStyle(
color: darktext.withAlpha(100), fontSize: 13,
),
),
SizedBox( height: 5,
),
 
Text(
'Bad Experience with customer service and adnfnasdfnasdfna ads f asdf as df asdf ',
style: TextStyle(
color: darktext.withAlpha(100), fontSize: 13,
),
),
],
),
),
Icon(
Icons.chevron_right_rounded, color: darktext,
size: 35,
),
],
),
),
),
Divider(
color: darktext.withAlpha(100),
),
],
);
}
}


class ReviewStar extends StatelessWidget { final int a;
const ReviewStar({Key? key, this.a = 3}) : super(key: key);

@override
Widget build(BuildContext context) { return Row(
children: [
 
for (int i = 0; i < a; i++) Icon(
Icons.star, size:   20, color: darktext,
),
for (int i = 0; i < 5 - a; i++) Icon(
Icons.star, size: 20,
color: darktext.withAlpha(100),
),
],
);
}
}


// schedulescreen.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart'; import 'package:vehicle_maintenance_app/services/constants.dart'; import
'package:vehicle_maintenance_app/services/user_services.dart'; import 'package:vehicle_maintenance_app/widgets/servicetile.dart';

class scheduleScreen extends StatefulWidget {
const scheduleScreen({Key? key}) : super(key: key);

@override
State<scheduleScreen> createState() =>
_scheduleScreenState();
}
 
class _scheduleScreenState extends State<scheduleScreen> { int totalcost = 0;
Map<String, List<DocumentSnapshot>> carservices = {}; final UserServices userServices = UserServices();
Future<Map<String, List<DocumentSnapshot>>> getdata() async { QuerySnapshot querySnapshot =
await userServices.getunpaidservicewithuserkey(); totalcost = 0;
carservices.clear();
for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
carservices.putIfAbsent(documentSnapshot.get('carkey'), () => []);
carservices[documentSnapshot.get('carkey').toString()]
?.add(documentSnapshot);

totalcost += int.parse(documentSnapshot.get('serviceprice').toString());
}
return carservices;
}

@override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar(
backgroundColor: Colors.white, elevation: 0,
centerTitle: true, scrolledUnderElevation: 0, automaticallyImplyLeading: false, title: Text(
"Schedules", style: TextStyle(
fontWeight: FontWeight.bold,
 
color: darktext,
),
),
),
 





{







10),
 
body: FutureBuilder( future: getdata(),
builder: (context, snapshot) {
if (snapshot.hasData && snapshot.data!.length != 0)

return Column( children: [
Expanded(
child: ListView.builder(
padding: EdgeInsets.symmetric(vertical:

physics: BouncingScrollPhysics(), itemCount: snapshot.data!.length, itemBuilder: (context, i) {
return section( carkey:
 
snapshot.data!.keys.elementAt(i),
documentSnapshot:

snapshot.data!.values.elementAt(i));
}),
 




10),
 
),
Container(
padding: EdgeInsets.symmetric(vertical:

child: Row( mainAxisAlignment:
 
MainAxisAlignment.center,
children: [ Text(
'Total Cost: ', style: TextStyle(
 
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
Text(
'₹ ' + totalcost.toString(), style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
],
),
),
],
);
} else if (snapshot.hasData && snapshot.data!.length == 0) {
return Center( child: Text(
'No Services Booked Yet!!', style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold, color: darktext,
),
),
);
} else {
return Center(
child: CircularProgressIndicator(),
);
}
}),
);
}
 
Widget section(
{required String carkey,
required List<DocumentSnapshot> documentSnapshot}) { return Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
SizedBox( height: 5,
),
Container(
padding: EdgeInsets.symmetric(horizontal: 15,
vertical: 10),
child: FutureBuilder( future:

userbase.doc(userkey).collection('cars').doc(carkey).get(), builder: (context, snapshot) {
if (snapshot.hasData) { return Text(
snapshot.data!.get('carmaker') + ' ' +
snapshot.data!.get('carmodel') + ": ",
style: TextStyle( fontSize: 16,
fontWeight: FontWeight.bold, color: darktext,
),
);
} else
return Container(
padding: EdgeInsets.symmetric(vertical:
 
10),
 

width: 60,
child: LinearProgressIndicator(),
 
);
}),
),
Column( children: [
for (DocumentSnapshot ds in documentSnapshot) serviceTile(documentSnapshot: ds),
],
),
],
);
}
}



// scheduleshop.dart

import 'package:flutter/cupertino.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/data.dart'; import 'package:vehicle_maintenance_app/global.dart'; import
'package:vehicle_maintenance_app/models/servicemodel.dart'; import 'package:vehicle_maintenance_app/models/shop_model.dart'; import 'package:vehicle_maintenance_app/screens/mainscreens/homeparent
.dart'; import
'package:vehicle_maintenance_app/screens/schedules_screen/sched ulereview.dart';

class scheduleShop extends StatefulWidget { final ServiceModel serviceModel;
const scheduleShop({Key? key, required this.serviceModel}) : super(key: key);
 
@override
State<scheduleShop> createState() => _scheduleShopState();
}


class _scheduleShopState extends State<scheduleShop> { @override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar(
backgroundColor: Colors.white, elevation: 0,
centerTitle: true, scrolledUnderElevation: 0, leading: IconButton(
onPressed: () { Navigator.pop(context);
},
icon: Icon( CupertinoIcons.left_chevron, color: darktext,
),
),
title: Text( "Schedule", style: TextStyle(
color:   darktext, fontWeight: FontWeight.bold,
),
),
),
body: Container(
margin: EdgeInsets.only(top: 15), child: Column(
children: [ Row(
 
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [ SizedBox(
width: 25,
),
Text(
'RECENT SHOPS',
style: subtitle,
),
Spacer(), Icon(
Icons.more_horiz_rounded, color: darktext,
),
SizedBox( width: 30,
),
],
),
SizedBox( height: 10,
),
Expanded(
child: ListView.builder(
physics: BouncingScrollPhysics(), padding: EdgeInsets.only(bottom: 20), itemCount: shopdata.length, itemBuilder: (context, i) {
return shopTile( shopmodel: shopdata[i],
);
},
),
),
],
 
),
),
);
}


Widget shopTile({required ShopModel shopmodel}) { return Container(
margin: EdgeInsets.symmetric(vertical: 5, horizontal:
 
15),
 

child: ElevatedButton( onPressed: () {
widget.serviceModel.shopmodel = shopmodel; Navigator.pushNamed(context, '/schedulereview',
arguments: widget.serviceModel);
 
},
style: ElevatedButton.styleFrom( backgroundColor: Colors.white,
// foregroundColor: maintheme, elevation: 2,
surfaceTintColor: Colors.white, padding: EdgeInsets.all(0), shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: Container(
padding: EdgeInsets.symmetric( vertical: 15,
horizontal: 15,
),
child: Row( children: [
Expanded( child: Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
 























5245',
 
Text(
// 'Jiffy Lube', shopmodel.shopname, style: subtitle.copyWith(
fontSize: 15,
),
),
SizedBox( height: 5,
),
ReviewStar( a: 3,
),
SizedBox( height: 5,
),
Text(
// '756, Barrington Road, Hanover Park

shopmodel.shopaddress, style: subtitle.copyWith(
fontSize: 12,
color: darktext.withAlpha(100),
),
),
],
),
),
 
Icon(
Icons.chevron_right_rounded, color: darktext,
size: 25,
),
],
),
),
 
),
);
}
}


// schedulesuccess.dart

import 'package:flutter/cupertino.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart';

class scheduleSuccess extends StatelessWidget {
const scheduleSuccess({Key? key}) : super(key: key);

final String t2 =
"You'll receive a confirmation email from Jiffy Lube to confirm your requredted date and time.";

@override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar(
backgroundColor: Colors.white, elevation: 0,
centerTitle: true, automaticallyImplyLeading: false, scrolledUnderElevation: 0,
title: Text( "Confirmation", style: TextStyle(
color:   darktext, fontWeight: FontWeight.bold,
),
),
),
body: Container(
 

30),
 
padding: EdgeInsets.symmetric(vertical: 25, horizontal:

child: Column(
mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
Text(
'Thanks for Scheduling your next Service', textAlign: TextAlign.center,
style: TextStyle( fontSize: 24, color: darktext,
fontWeight: FontWeight.bold,
 
),
),
Text(
t2,
textAlign: TextAlign.center, style: TextStyle(
color: darktext, fontSize: 18,
),
),
OutlinedButton( onPressed: () {
Navigator.pop(context);
},
style: OutlinedButton.styleFrom( foregroundColor: maintheme, side: BorderSide(
color: maintheme,
),
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12),
),
),
child: Container(
 

horizontal: 15),
 
padding: EdgeInsets.symmetric(vertical: 15,

child: Text(
'Back to Dashboard', style: TextStyle(
fontWeight: FontWeight.bold,
),
 
),
),
),
SizedBox( height: 10,
),
Container( height: 150,
width: 150,
child: Image.asset( 'assets/images/logo_color.png',
),
),
SizedBox( height: 20,
),
],
),
),
);
}
}


// servicemodel.dart

import 'package:vehicle_maintenance_app/models/shop_model.dart';

class ServiceModel {
 
String? carkey; ShopModel? shopmodel; String? servicename; String? serviceprice; String? day;
String? month; String? year; String? hours; String? minutes; String? notes;
String? paymentstatus;

ServiceModel({ this.carkey, this.shopmodel, this.servicename, this.serviceprice, this.day, this.month, this.year, this.hours, this.minutes, this.notes = '',
this.paymentstatus = 'pending',
});

void printer() { print(this.carkey); print(this.shopmodel); print(this.servicename); print(this.serviceprice); print(this.day); print(this.month); print(this.year); print(this.hours); print(this.minutes);
 
print(this.notes); print(this.paymentstatus);
}
}


// servicetile.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart';

class serviceTile extends StatelessWidget { final DocumentSnapshot documentSnapshot;
const serviceTile({Key? key, required this.documentSnapshot})
: super(key: key);

@override
Widget build(BuildContext context) { return Container(
padding: EdgeInsets.symmetric(horizontal: 15, vertical:
 
5),
 

child: ElevatedButton( onPressed: () {},
style: ElevatedButton.styleFrom( foregroundColor: maintheme, elevation: 7,
shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),
),
),
child: Container(
padding: EdgeInsets.symmetric(vertical: 15,
 
horizontal: 10),
child: Row( children: [
Expanded(
 
child: Column(
crossAxisAlignment: CrossAxisAlignment.start, children: [
Text(

documentSnapshot.get('servicename').toString(),
maxLines: 1,
overflow: TextOverflow.ellipsis, style: subtitle,
),
Text(
'at ' + documentSnapshot.get('shopname').toString(),
maxLines: 1,
overflow: TextOverflow.ellipsis, style: subtitle.copyWith(
fontSize: 13,
fontWeight: FontWeight.normal,
),
),
SizedBox( height: 5,
),
Row(
children: [ Text(

documentSnapshot.get('servicedate').toString(),
style: TextStyle( color: darktext,
fontWeight: FontWeight.bold,
),
),
SizedBox( width: 15,
),
 
Text(

documentSnapshot.get('servicetime').toString(),
style: TextStyle( color: darktext,
fontWeight: FontWeight.bold,
),
),
],
),
],
),
),
SizedBox( width: 20,
),
Column( children: [
Text(
'₹ ' +
documentSnapshot.get('serviceprice').toString(),
style: TextStyle(
fontWeight: FontWeight.bold, color: darktext,
fontSize: 18,
),
),
SizedBox( height: 10,
),
paidBadge(
paid: (documentSnapshot.get('paymentstatus').toString() ==
'pending')
? (false)
: (true)),
 
],
),
],
),
),
),
);
}
}


paidBadge({bool paid = true}) { if (paid == true) {
return Row( children: [
Icon(
Icons.check_circle_outline_rounded, color: Colors.green,
size: 15,
),
SizedBox( width: 5,
),
Text(
'Paid',
style: TextStyle( fontSize: 13,
color: Colors.green, fontWeight: FontWeight.bold,
),
),
],
);
} else {
{
return Row( children: [
 
Icon(
Icons.not_interested_rounded, color: Colors.red,
size: 15,
),
SizedBox( width: 5,
),
Text(
'Not Paid', style: TextStyle(
fontSize: 13, color: Colors.red,
fontWeight: FontWeight.bold,
),
),
],
);
}
}
}


// shop_model.dart

class ShopModel {
final String shopname; final String shopaddress; final String shopphone;

ShopModel({
required this.shopname, required this.shopaddress, required this.shopphone,
});
}
 
// signup.dart

import 'package:firebase_auth/firebase_auth.dart'; import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart'; import 'package:vehicle_maintenance_app/screens/loginpage.dart'; import 'package:vehicle_maintenance_app/services/user_auth.dart';

class SignUp extends StatefulWidget {
const SignUp({Key? key}) : super(key: key);


@override
State<SignUp> createState() => _SignUpState();
}


class _SignUpState extends State<SignUp> { TextEditingController name = TextEditingController(); TextEditingController email = TextEditingController(); TextEditingController password = TextEditingController(); String errortext = '';
bool obscurepassword = true;
Authentication _authentication = Authentication(); bool loading = false;

bool validate() {
if (email.text != '' && name.text != '' && password.text != '') {
//signup return true;
} else { setState(() {
errortext = '';
if (email.text == '') {
errortext += 'Enter Email Id\n';
 
}
if (name.text == '') { errortext += 'Enter Name\n';
}
if (password.text == '') {
errortext += 'Enter Password Id\n';
}
});
return false;
}
}


showSuccess() async { await showDialog(
context: context, barrierDismissible: false, builder: (context) => AlertDialog(
title: Text('Sign Up Successfull'), content: Text('You can Login Now'), contentPadding: EdgeInsets.all(30), actions: [
TextButton( onPressed: () {
Navigator.pop(context);
},
child: Text('Go to Login Page'),
),
],
),
);
}


signup() async { setState(() {
loading = true;
});
 
var result =
await _authentication.createUser(name.text, email.text, password.text);
if (result.runtimeType == bool && result == true) {
//success
await showSuccess();

Navigator.pushReplacementNamed(context, '/login');
} else if (result.toString().contains('email-already-in- use')) {
setState(() {
errortext = 'Email Already in Use\nTry Logging in';
});
} else { setState(() {
errortext = 'Sign up successfully Failed';
});
}
setState(() { loading = false;
});
}


@override
Widget build(BuildContext context) { return Scaffold(
body: SafeArea( child: Container(
padding: EdgeInsets.symmetric(horizontal: 15), child: Column(children: [
Row(
mainAxisAlignment: MainAxisAlignment.end, children: [
TextButton(
onPressed: () async {
 

'/login');
 
Navigator.pushReplacementNamed(context,

},
child: Text( "Login",
style: TextStyle(
fontWeight: FontWeight.bold,
 
),
),
),
],
),
Expanded(
child: SingleChildScrollView( physics: BouncingScrollPhysics(), child: Container(
child: Column( mainAxisAlignment:
MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [ SizedBox(
height: 50,
),
Row(),
// Container(
//	child: Icon(
//	Icons.car_crash_sharp,
//	color: Colors.redAccent,
//	size: 100,
//	),
// ), Container(
height: 150,
width: 150,
 
child: Image.asset( 'assets/images/logo_color.png',
),
),
SizedBox( height: 10,
),
Text(
"VehiCare", style: TextStyle(
color: maintheme, fontWeight: FontWeight.bold, fontSize: 35,
),
),
SizedBox( height: 30,
),
Container( height: 60,
child: TextField( controller: name, style: TextStyle(
fontSize: 18,
 












BorderRadius.circular(12),
 
),
decoration: InputDecoration( hintText: 'Name', hintStyle: TextStyle(
color: Colors.grey, fontSize: 18,
),
focusedBorder: OutlineInputBorder( borderRadius:

borderSide: BorderSide( color: maintheme,
 






BorderRadius.circular(12),
 
width: 1,
),
),
enabledBorder: OutlineInputBorder( borderRadius:

borderSide: BorderSide( color: maintheme, width: 0.5,
),
),
),
 
),
),
SizedBox( height: 20,
),
Container( height: 60,
child: TextField( controller: email, style: TextStyle(
fontSize: 18,
 












BorderRadius.circular(12),
 
),
decoration: InputDecoration( hintText: 'Email', hintStyle: TextStyle(
color: Colors.grey, fontSize: 18,
),
focusedBorder: OutlineInputBorder( borderRadius:

borderSide: BorderSide( color: maintheme, width: 1,
 





BorderRadius.circular(12),
 
),
),
enabledBorder: OutlineInputBorder( borderRadius:

borderSide: BorderSide( color: maintheme, width: 0.5,
),
),
),
 
),
),
SizedBox( height: 20,
),
Row(
children: [ Expanded(
child: Container( height: 60, child: TextField(
controller: password, style: TextStyle(
fontSize: 18,
),
obscureText: obscurepassword, obscuringCharacter: '*', decoration: InputDecoration(
hintText: 'Password', hintStyle: TextStyle( color: Colors.grey,
fontSize: 18,
 



OutlineInputBorder(
 
),
focusedBorder:
 

BorderRadius.circular(12),
 
borderRadius:

borderSide: BorderSide( color: maintheme, width: 1,
 
),
),
 

OutlineInputBorder(

BorderRadius.circular(12),
 
enabledBorder:

borderRadius:

borderSide: BorderSide( color: maintheme, width: 0.5,
 
),
),
),
),
),
),
SizedBox( width: 5,
 






!obscurepassword;
 
),
IconButton( onPressed: () {
setState(() { obscurepassword =

});
 
},
icon: (obscurepassword)
?
(Icon(Icons.visibility_outlined))
:
(Icon(Icons.visibility_off_outlined)),
),
 
],
),
SizedBox( height: 5,
),
SizedBox( height: 30,
),
TextButton(
onPressed: (loading == true)
? (null)
: (() {
if (validate() == true) { signup();
}
}),
style: TextButton.styleFrom( backgroundColor: maintheme, foregroundColor: Colors.white, padding: EdgeInsets.zero, shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(12),
),
),
child: Row(
mainAxisSize: MainAxisSize.max, mainAxisAlignment:
 
MainAxisAlignment.center,
 

children: [ (loading == true)
? Container(
padding:
 
EdgeInsets.symmetric(vertical: 10),

(CircularProgressIndicator(
 

child:
 
color: Colors.white,
)),
)
 




Alignment.center,
 
: (Container(
height: 60, alignment:

child: Text( "Sign Up",
style: TextStyle( color: Colors.white, fontSize: 20,
),
 
),
))
],
),
),
SizedBox( height: 50,
),
Text(
errortext, style: TextStyle(
color: Colors.red, fontWeight: FontWeight.bold,
),
),
],
),
),
),
),
]),
),
),
 
);
}
}


// upcoming_appointments.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:firebase_auth/firebase_auth.dart'; import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_maintenance_app/global.dart'; import
'package:vehicle_maintenance_app/services/user_services.dart'; import 'package:vehicle_maintenance_app/widgets/servicetile.dart';

class upcomingAppointmentScreen extends StatefulWidget { final String carkey;
final String title; upcomingAppointmentScreen(
{Key? key,
this.carkey = 'IgoC6hm8VmVNKjlleTET', this.title = 'Upcoming Appointments'})
: super(key: key);


@override
State<upcomingAppointmentScreen> createState() =>
_upcomingAppointmentScreenState();
}


class _upcomingAppointmentScreenState extends State<upcomingAppointmentScreen> {
int totalcost = 0;
final UserServices userServices = UserServices(); Future<List<DocumentSnapshot>> getdata() async {
QuerySnapshot querySnapshot =
 
await userServices.getunpaidservicewithcarkey(carkey: widget.carkey);
List<DocumentSnapshot> documentsnapshots = []; totalcost = 0;
for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
documentsnapshots.add(documentSnapshot); totalcost +=
int.parse(documentSnapshot.get('serviceprice').toString());
}
return documentsnapshots;
}

@override
void initState() {
// TODO: implement initState super.initState(); getdata();
}

@override
Widget build(BuildContext context) { return Scaffold(
appBar: AppBar(
backgroundColor: Colors.white, elevation: 0,
centerTitle: true, scrolledUnderElevation: 0, leading: IconButton(
onPressed: () { Navigator.pop(context);
},
icon: Icon( CupertinoIcons.left_chevron, color: darktext,
),
 
),
title: Text(
(widget.title == '') ? ("Upcoming Appointments") : (widget.title),
style: TextStyle( color: darktext,
fontWeight: FontWeight.bold,
),
),
),
body: FutureBuilder( future: getdata(),
builder: (context, snapshot) {
if (snapshot.hasData && snapshot.data!.length != 0)
{
return Column( children: [
Expanded(
child: ListView.builder(
physics: BouncingScrollPhysics(), itemCount: snapshot.data!.length, itemBuilder: (context, i) {
return serviceTile( documentSnapshot:
 
snapshot.data![i],



),
 

);
}),
 



horizontal: 15),
 
Container(
padding: EdgeInsets.symmetric(vertical: 10,

child: Row( mainAxisAlignment:
 
MainAxisAlignment.center,
children: [ Text(
 
'Total Cost: ', style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
Text(
'₹ ' + totalcost.toString(), style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
Spacer(), OutlinedButton(
onPressed: () { Navigator.pushNamed(
context, '/paymentscreen', arguments: snapshot.data!,
);
 








BorderRadius.circular(12),
 
},
style: OutlinedButton.styleFrom( backgroundColor: Colors.white, foregroundColor: Colors.red, shape: RoundedRectangleBorder(
borderRadius:
 
),
side: BorderSide( color: Colors.red, width: 1,
),
),
child: Text( 'Pay All',
 
style: TextStyle( color: Colors.red, fontSize: 15,
),
),
),
],
),
),
],
);
} else if (snapshot.hasData && snapshot.data!.length == 0) {
return Center( child: Text(
'No Services Booked Yet!!', style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold, color: darktext,
),
),
);
} else {
return Center(
child: CircularProgressIndicator(),
);
}
}),
);
}
}
 
// user_auth.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; import 'package:vehicle_maintenance_app/services/constants.dart';

class Authentication {
createUser(String name, String email, String password) async
{
UserCredential user; try {
user = await firebaseAuth.createUserWithEmailAndPassword( email: email, password: password);
} catch (e) {
print(e); return e;
}
if (user.additionalUserInfo!.isNewUser) { userbase.doc(user.user!.uid.toString()).set({
'name': name, 'cars': {},
'services': {},
});
}
return true;
}


loginUser(String email, String password) async { UserCredential user;
try {
user = await firebaseAuth.signInWithEmailAndPassword( email: email, password: password);

//getting instance for local storage
 
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//getting snapshot for username DocumentSnapshot documentSnapshot =
await userbase.doc(user.user!.uid).get();

// storing userkey and user name in local variable username = documentSnapshot.get('name');
userkey = user.user!.uid.toString();

// storing userkey and user name in local storage sharedPreferences.setString('userkey', user.user!.uid); sharedPreferences.setString('username',
documentSnapshot.get('name'));
} catch (e) {
print(e); return e;
}
// print(user.user!.uid.toString());


return user;
// print(user);
}
}


// user_services.dart

import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:vehicle_maintenance_app/models/servicemodel.dart'; import 'package:vehicle_maintenance_app/services/constants.dart';

class UserServices {
addnewcar({required String carmaker, required String carmodel}) async {
 
await userbase.doc(userkey).collection('cars').add({ 'carmaker': carmaker,
'carmodel': carmodel,
});
print('Success');
}


addSchedule({required ServiceModel serviceModel}) async { var result = await
userbase.doc(userkey).collection('services').add({ 'carkey': serviceModel.carkey,
'shopname': serviceModel.shopmodel!.shopname, 'servicename': serviceModel.servicename, 'serviceprice': serviceModel.serviceprice.toString(), 'servicedate': serviceModel.day.toString() +
'/' +
serviceModel.month.toString() + '/' +
serviceModel.year.toString(), 'servicetime':
serviceModel.hours.toString() + ':' + serviceModel.minutes.toString(),
'servicenotes': serviceModel.notes, 'paymentstatus': serviceModel.paymentstatus,
});
return result;
}

Future<QuerySnapshot> getcars() async { QuerySnapshot querySnapshot =
await userbase.doc(userkey).collection('cars').get(); return querySnapshot;
}

Future<QuerySnapshot> getserviceswithcarkey({required String carkey}) async {
 
QuerySnapshot snapshot = await userbase
.doc(userkey)
.collection('services')
.where('carkey', isEqualTo: carkey)
.get(); return snapshot;
}


Future<QuerySnapshot> getserviceswithuserkey() async { QuerySnapshot querySnapshot =
await userbase.doc(userkey).collection('services').get();
return querySnapshot;
}

Future<QuerySnapshot> getunpaidservicewithcarkey(
{required String carkey}) async { QuerySnapshot querySnapshot = await userbase
.doc(userkey)
.collection('services')
.where('carkey', isEqualTo: carkey)
.where('paymentstatus', isEqualTo: 'pending')
.get();
return querySnapshot;
}

Future<QuerySnapshot> getunpaidservicewithuserkey() async { QuerySnapshot querySnapshot = await userbase
.doc(userkey)
.collection('services')
.where('paymentstatus', isEqualTo: 'pending')
.get();
return querySnapshot;
}

deleteCar({required String carkey}) async {
 
// to delete document from car collection await
userbase.doc(userkey).collection('cars').doc(carkey).delete(); print('user deleted');
// to delete its services
QuerySnapshot querySnapshot = await userbase
.doc(userkey)
.collection('services')
.where('carkey', isEqualTo: carkey)
.get();
for (DocumentSnapshot doc in querySnapshot.docs) { await
userbase.doc(userkey).collection('services').doc(doc.id).delete ();
}
print('services deleted');
}
}
