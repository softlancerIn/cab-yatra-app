import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'package:cab_taxi_app/Pages/Add%20New%20Booking/model/car_category_model.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/cityModel.dart';

class AlertFilterScreen extends StatefulWidget {
  const AlertFilterScreen({super.key});

  @override
  State<AlertFilterScreen> createState() => _AlertFilterScreenState();
}

class _AlertFilterScreenState extends State<AlertFilterScreen> {
  List<String> selectedVehicles = [];
  bool manualPickup = true;
  List<String> pickupCities = [];

  bool _isSynced = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<DashboardBloc>().state;
    context.read<DashboardBloc>().add(GetCitiesEvent(context: context));
    context.read<DashboardBloc>().add(GetCarCategoryEvent(context: context));
    context.read<DashboardBloc>().add(GetAlertsEvent(context: context));
    
    // Initial sync from existing state if available
    selectedVehicles = List.from(state.savedVehicleTypes ?? []);
    pickupCities = List.from(state.savedPickupLocations ?? []);
    manualPickup = state.manuallyPickup?.toLowerCase() == "yes" || 
                   (state.manuallyPickup == null && pickupCities.isNotEmpty);
    if (state.alertResponseModel != null) _isSynced = true;
  }

  List<String> get _cities {
    final state = context.read<DashboardBloc>().state;
    return state.citiesResponseModel?.data?.map((e) => e.name ?? "").toList() ?? [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toggleCity(String city) {
    setState(() {
      if (pickupCities.contains(city)) {
        pickupCities.remove(city);
      } else {
        pickupCities.add(city);
      }
    });
  }

  void toggleVehicle(String type) {
    setState(() {
      if (selectedVehicles.contains(type)) {
        selectedVehicles.remove(type);
      } else {
        selectedVehicles.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Alert',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
      ),
      body: BlocListener<DashboardBloc, DashboardState>(
        listenWhen: (previous, current) => 
            previous.alertResponseModel != current.alertResponseModel,
        listener: (context, state) {
          // Only sync from server when a new model arrives
          if (state.alertResponseModel != null) {
            setState(() {
              selectedVehicles = List.from(state.savedVehicleTypes ?? []);
              pickupCities = List.from(state.savedPickupLocations ?? []);
              manualPickup = state.manuallyPickup?.toLowerCase() == "yes";
              _isSynced = true;
            });
          }
        },
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'select vehicle type you require',
                style: TextStyle(color: Color(0xff787878), fontSize: 14),
              ),
              const SizedBox(height: 16),

              /// VEHICLE GRID
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  final carModels = state.carCategoryModel?.data ?? [];
                  if (carModels.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: carModels.map((car) {
                      return vehicleCard(car.name ?? "");
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),

              /// SWITCH CARD
              Container(
                padding: const EdgeInsets.all(14),
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
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Your Pickup City Manually',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff3E4959)),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'this will help you to get one way and round trip Notifications',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      activeTrackColor: Colors.orange.withOpacity(0.5),
                      activeColor: Colors.orange,
                      value: manualPickup,
                      onChanged: (val) {
                        setState(() {
                          manualPickup = val;
                        });
                      },
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// CONDITIONAL UI
              if (manualPickup) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: -4,
                  children: pickupCities.map((city) {
                    return Chip(
                      backgroundColor: Colors.orange,
                      label: Text(
                        city,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onDeleted: () {
                        setState(() {
                          pickupCities.remove(city);
                        });
                      },
                      deleteIcon: const Icon(Icons.close,
                          size: 16, color: Colors.white),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => _showCityPicker(),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pickupCities.isEmpty
                              ? 'Select Your Pickup City'
                              : '${pickupCities.length} Cities Selected',
                          style: TextStyle(
                              color: pickupCities.isEmpty
                                  ? Colors.black54
                                  : Colors.black87),
                        ),
                        const Icon(Icons.keyboard_arrow_down,
                            color: Colors.orange),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff3E4959)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    selectedVehicles.clear();
                    pickupCities.clear();
                  });
                  context.read<DashboardBloc>().add(const ClearFilterEvent());
                  context.read<DashboardBloc>().add(ClearAlertsEventApi(context: context));
                },
                child: const Text(
                  'Clear Filter',
                  style: TextStyle(color: Color(0xff3E4959)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final state = context.read<DashboardBloc>().state;
                  // Map selected vehicle names to IDs
                  final carModels = state.carCategoryModel?.data ?? [];
                  List<int> carIds = [];
                  for (var vehicle in selectedVehicles) {
                    final match = carModels.firstWhere(
                      (c) => c.name?.toLowerCase().trim() == vehicle.toLowerCase().trim(),
                      orElse: () => Data(id: -1),
                    );
                    if (match.id != -1) {
                      carIds.add(match.id!);
                    }
                  }

                  // Map selected city names to IDs (List<int> as required by API)
                  final cityModels = state.citiesResponseModel?.data ?? [];
                  List<int> cityIds = [];
                  for (var city in pickupCities) {
                    final match = cityModels.firstWhere(
                      (c) => c.name?.toLowerCase().trim() == city.toLowerCase().trim(),
                      orElse: () => CityData(id: -1),
                    );
                    if (match.id != null && match.id != -1) {
                      cityIds.add(match.id!);
                    }
                  }

                  context.read<DashboardBloc>().add(UpdateAlertsEvent(
                        context: context,
                        alertType: "location_based",
                        carIds: carIds,
                        locations: cityIds,
                        manualPickup: manualPickup ? "yes" : "no",
                        status: "1", // Saving settings always activates the alert
                      ));

                  Navigator.pop(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCityPicker() {
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Select Pickup Cities",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.black),
                          ),
                        ],
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
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.orange),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            final allCities = state.citiesResponseModel?.data
                                    ?.map((e) => e.name ?? "")
                                    .toList() ??
                                [];
                            final filteredCities = allCities
                                .where((city) =>
                                    city.toLowerCase().contains(searchQuery))
                                .toList();

                            if (state.isLoading && allCities.isEmpty) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (filteredCities.isEmpty) {
                              return const Center(child: Text("No cities found"));
                            }

                            return ListView.builder(
                              controller: scrollController,
                              itemCount: filteredCities.length,
                              itemBuilder: (context, index) {
                                final city = filteredCities[index];
                                final isSelected = pickupCities.contains(city);
                                return ListTile(
                                  title: Text(city),
                                  trailing: Icon(
                                    isSelected
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.grey,
                                  ),
                                  onTap: () {
                                    setModalState(() {
                                      if (isSelected) {
                                        pickupCities.remove(city);
                                      } else {
                                        pickupCities.add(city);
                                      }
                                    });
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

  /// VEHICLE CARD WIDGET
  Widget vehicleCard(String title) {
    final isSelected = selectedVehicles.contains(title);

    return GestureDetector(
      onTap: () => toggleVehicle(title),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3.6,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/carMO.png', // replace with your image
                  height: 40,
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          if (isSelected)
            const Positioned(
              right: 8,
              top: 6,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.white,
                child: Icon(Icons.check, size: 12, color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }
}
