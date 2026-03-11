import 'package:cab_taxi_app/Pages/editBooking/ui/editBookingOneWayScreen.dart';
import 'package:cab_taxi_app/Pages/editBooking/ui/editBookingRoundTripScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Add New Booking/bloc/addBookingBloc.dart';
import '../Add New Booking/bloc/addBookingEvent.dart';
import '../Custom_Widgets/custom_app_bar.dart';

class EditBookingScreen extends StatefulWidget {
  final String bookingType; //Round Trip  //Round Trip
  final String vehicalType;
  final String pickUpLocation;
  final String dropLocation;
  final String pickUpDate;
  final String pickUpTime;
  final String totalFare;
  final String driverCommission;
  final String remark;
  const EditBookingScreen({
    super.key,
    required this.bookingType,
    required this.pickUpTime,
    required this.remark,
    required this.driverCommission,
    required this.pickUpDate,
    required this.totalFare,
    required this.dropLocation,
    required this.pickUpLocation,
    required this.vehicalType,
  });

  @override
  State<EditBookingScreen> createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool isOneWay;
  @override
  void initState() {
    super.initState();
    // context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
    context.read<AddBookingBloc>().add(LoadCarCategories(context));
    isOneWay = widget.bookingType.toLowerCase() == "one way";
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // controller.getHomeData();
    // _loadNumericPart();
    // selectedDate = DateTime.now();
    // selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const AppBAR(
        title: "Edit Booking",
        showLeading: true,
        showAction: true,
      ),
      body: widget.bookingType.toLowerCase() == "one way"
          ? EditBookingOneWayScreen(
              driverCommission: widget.driverCommission,
              dropLocation: widget.dropLocation,
              pickUpDate: widget.pickUpDate,
              pickUpLocation: widget.pickUpLocation,
              pickUpTime: widget.pickUpTime,
              remark: widget.remark,
              totalFare: widget.totalFare,
              vehicalType: widget.vehicalType,
            )
          : EditBookingRoundTripScreen(
              driverCommission: widget.driverCommission,
              dropLocation: widget.dropLocation,
              pickUpDate: widget.pickUpDate,
              pickUpLocation: widget.pickUpLocation,
              pickUpTime: widget.pickUpTime,
              remark: widget.remark,
              totalFare: widget.totalFare,
              vehicalType: widget.vehicalType),
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
    super.key,
    required this.selectedValue,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    required this.color,
    this.hint = '',
    this.backgroundColor = Colors.white,
    this.width = 150.0,
    this.isReadOnly,
  });

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
                ? widget.itemLabel(widget.selectedValue as T)
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w400,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF86888A)),
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
      {super.key,
      required this.width,
      required this.height,
      required this.controller,
      required this.hintText,
      this.onPress,
      this.iconButton,
      this.icon,
      this.readOnly,
      this.validator,
      this.keyboardType});

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
        shadows: const [
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
          if (icon != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon!,
            ),
        ],
      ),
    );
  }
}
