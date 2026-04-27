import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'package:cab_taxi_app/Pages/Booking/bloc/booking_bloc.dart';
import 'package:cab_taxi_app/Pages/Booking/bloc/booking_event.dart';

class ApplyFilterDialog extends StatefulWidget {
  final bool isPostedBooking;
  const ApplyFilterDialog({super.key, this.isPostedBooking = false});

  @override
  State<ApplyFilterDialog> createState() => _ApplyFilterDialogState();
}

class _ApplyFilterDialogState extends State<ApplyFilterDialog> {
  String? _selectedPickup;
  String? _selectedDrop;
  String? _selectedVehicle;
  String? _selectedStatus;

  List<String> get _vehicles {
    final state = context.read<DashboardBloc>().state;
    return state.carCategoryModel?.data?.map((e) => e.name ?? "").toList() ?? [
      'hatchback',
      'Sedan',
      'SUV',
      'Innova',
      'Traveller'
    ];
  }

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetCitiesEvent(context: context));
    context.read<DashboardBloc>().add(GetCarCategoryEvent(context: context));

    if (widget.isPostedBooking) {
      final state = context.read<BookingBloc>().state;
      _selectedPickup = (state.pickupLocationFilters != null &&
              state.pickupLocationFilters!.isNotEmpty)
          ? state.pickupLocationFilters!.first
          : null;
      _selectedDrop = state.dropLocationFilter;
      _selectedVehicle = (state.selectedVehicleTypes != null &&
              state.selectedVehicleTypes!.isNotEmpty)
          ? state.selectedVehicleTypes!.first
          : null;
      _selectedStatus = state.bookingStatusFilter;
    } else {
      final state = context.read<DashboardBloc>().state;
      _selectedPickup = (state.pickupLocationFilters != null &&
              state.pickupLocationFilters!.isNotEmpty)
          ? state.pickupLocationFilters!.first
          : null;
      _selectedDrop = state.dropLocationFilter;
      _selectedVehicle = (state.selectedVehicleTypes != null &&
              state.selectedVehicleTypes!.isNotEmpty)
          ? state.selectedVehicleTypes!.first
          : null;
    }
  }

  List<String> get _cities {
    final state = context.read<DashboardBloc>().state;
    return state.citiesResponseModel?.data?.map((e) => e.name ?? "").toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              const Center(
                child: Text(
                  "Apply Filter",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Select Vehicle
              _label("Select vehical"),
              _dropdownField(
                title: _selectedVehicle ?? "Select Vehicle",
                onTap: () {
                  _showVehiclePicker();
                },
              ),

              const SizedBox(height: 16),

              if (widget.isPostedBooking) ...[
                /// Booking Status
                _label("Booking Status"),
                _dropdownField(
                  title: _selectedStatus ?? "Select Status",
                  onTap: () {
                    _showStatusPicker();
                  },
                ),
              ] else ...[
                /// Pickup Location
                _label("Pickup Location"),
                _dropdownField(
                  title: _selectedPickup ?? "Add Pickup Location",
                  onTap: () {
                    _showCityPicker(true);
                  },
                ),

                const SizedBox(height: 16),

                /// Drop Location
                _label("Drop Location"),
                _dropdownField(
                  title: _selectedDrop ?? "Add Drop Location",
                  onTap: () {
                    _showCityPicker(false);
                  },
                ),
              ],

              const SizedBox(height: 24),

              /// Buttons
              Row(
                children: [
                  /// Clear Filter
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF3E4959)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (widget.isPostedBooking) {
                            context
                                .read<BookingBloc>()
                                .add(const ClearPostedBookingFilterEvent());
                          } else {
                            context
                                .read<DashboardBloc>()
                                .add(const ClearFilterEvent());
                          }
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Clear Filter",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3E4959),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Done
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (widget.isPostedBooking) {
                            context.read<BookingBloc>().add(
                                  UpdatePostedBookingFilterEvent(
                                    vehicleTypes: _selectedVehicle != null
                                        ? [_selectedVehicle!]
                                        : null,
                                    pickupLocations: _selectedPickup != null
                                        ? [_selectedPickup!]
                                        : null,
                                    dropLocation: _selectedDrop,
                                    bookingStatus: _selectedStatus,
                                  ),
                                );
                          } else {
                            context.read<DashboardBloc>().add(UpdateFilterEvent(
                                  vehicleTypes: _selectedVehicle != null
                                      ? [_selectedVehicle!]
                                      : null,
                                  pickupLocations: _selectedPickup != null
                                      ? [_selectedPickup!]
                                      : null,
                                  dropLocation: _selectedDrop,
                                ));
                          }
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
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
    );
  }

  void _showVehiclePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Vehicle Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: _vehicles.map((v) => ListTile(
                    title: Text(v),
                    onTap: () {
                      setState(() {
                        _selectedVehicle = v;
                      });
                      Navigator.pop(context);
                    },
                  )).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCityPicker(bool isPickup) {
    String searchQuery = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        isPickup ? "Select Pickup City" : "Select Drop City",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: (value) {
                          setModalState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search city...',
                          prefixIcon: const Icon(Icons.search, color: Colors.orange),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const Divider(height: 32),
                      Expanded(
                        child: BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            final allCities = state.citiesResponseModel?.data?.map((e) => e.name ?? "").toList() ?? [];
                            final filteredCities = allCities
                                .where((city) => city.toLowerCase().contains(searchQuery))
                                .toList();

                            if (state.isLoading && allCities.isEmpty) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (filteredCities.isEmpty) {
                              return const Center(child: Text("No cities found"));
                            }

                            return ListView.builder(
                              controller: scrollController,
                              itemCount: filteredCities.length,
                              itemBuilder: (context, index) {
                                final city = filteredCities[index];
                                return ListTile(
                                  title: Text(city),
                                  onTap: () {
                                    setState(() {
                                      if (isPickup) {
                                        _selectedPickup = city;
                                      } else {
                                        _selectedDrop = city;
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// Label widget
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Dropdown field
  Widget _dropdownField({required String title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  void _showStatusPicker() {
    final List<String> statuses = ['Open', 'Assigned', 'Completed', 'Cancelled', 'Expired'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Booking Status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: statuses.map((status) => ListTile(
                    title: Text(status),
                    onTap: () {
                      setState(() {
                        _selectedStatus = status;
                      });
                      Navigator.pop(context);
                    },
                  )).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
