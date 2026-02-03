
import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/home_controller.dart';
import '../../Controllers/my_booking_controller.dart';
import '../../core/network_service.dart';
import '../../models/dropdown_models.dart';
import '../../models/post_booking_model.dart';
import '../../services/location_search.dart';
import '../Custom_Widgets/CustomShimmer_widget.dart';
import '../HomePageFlow/home_controller.dart';
import 'addBookingOneWayScreen.dart';

//todo special req: text size bigger
//todo: list of vehical based on length
//todo: list of location spacing reduce
//todo: bold
class AddBookingScreen extends StatefulWidget {
  const AddBookingScreen({super.key});

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> with SingleTickerProviderStateMixin  {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    // context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // controller.getHomeData();
    // _loadNumericPart();
    // selectedDate = DateTime.now();
    // selectedTime = TimeOfDay.now();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(


        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            // color: Color.fromRGBO(0, 0, 0, 1),
              color: Colors.white),
        ),
        centerTitle: false,
        title: Text(
          'CabYatra',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),

        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (value) {
           // controller.getHomeData();
          },
          indicator: BoxDecoration(
            border: Border(
              bottom: const BorderSide(
                  color: Color.fromRGBO(255, 216, 0, 1), width: 4),
            ),
          ),
          labelColor: Colors.black,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelColor: const Color(0xFF5A6980),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          tabs: const [
            Tab(text: "One way"),
            Tab(text: "Round Trip"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(

              child: TabBarView(
                controller: _tabController,
                children: [
                  AddBookingOneWayScreen(),
                  Text("Round Trip dsft"),
                ],
              ),
            ),
          ),
        ],
      ),
      drawerEnableOpenDragGesture: true,
    );
  }
}



///////////////////////////////////////drop dowan screen code

class CustomDropdown<T> extends StatefulWidget {
  final T? selectedValue;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String hint;
  final Color backgroundColor;
  final Color color;
  final double width;
  final bool? isReadOnly; // nullable

  const CustomDropdown({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    required this.color,
    this.hint = '',
    this.backgroundColor = Colors.white,
    this.width = 150.0,
    this.isReadOnly,
  }) : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isDropdownOpen = false;

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readOnly = widget.isReadOnly == true;

    return Column(
      children: [
        GestureDetector(
          onTap: readOnly ? null : _toggleDropdown,
          child: commonBox(
            text: widget.selectedValue != null
                ? widget.itemLabel(widget.selectedValue!)
                : widget.hint,
            backgroundColor: widget.backgroundColor,
            width: widget.width,
            onTap: readOnly ? null : _toggleDropdown,
          ),
        ),
        if (_isDropdownOpen && !readOnly)
          Container(
            width: widget.width,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.items.map((T item) {
                return GestureDetector(
                  onTap: readOnly
                      ? null
                      : () {
                    widget.onChanged(item);
                    setState(() {
                      _isDropdownOpen = false;
                    });
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text(
                      widget.itemLabel(item),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget commonBox({
    required String text,
    VoidCallback? onTap,
    required Color backgroundColor,
    required double width,
  }) {
    return Container(
      height: 45,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color:  Colors.black,
                fontSize: 15,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Color(0xFF86888A)),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final double width;
  final TextEditingController controller;
  final String hintText;
  final double height;
  final IconButton? iconButton;
  final Icon? icon;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onPress;

  const CustomContainer(
      {Key? key,
      required this.width,
      required this.height,
      required this.controller,
      required this.hintText,
         this.onPress,
      this.iconButton,
        this.icon,
      this.readOnly,
      this.validator,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onTap: onPress,
              readOnly: readOnly ?? false,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none, // Removes underline
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: keyboardType,
              maxLines: null,
              onChanged: (value) {
                if (validator != null) {
                  final errorMessage = validator!(value);
                  if (errorMessage != null) {
                    print(errorMessage);
                  }
                }
              },
            ),
          ),
          if (iconButton != null) iconButton!,
          if (icon != null) Padding(
            padding: const EdgeInsets.all(8.0),
            child: icon!,
          ),
        ],
      ),
    );
  }
}
