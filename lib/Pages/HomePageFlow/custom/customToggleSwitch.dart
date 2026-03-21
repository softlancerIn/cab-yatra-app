import 'dart:convert';
import 'package:cab_taxi_app/app/router/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../../../app/router/navigation/nav.dart';

class CustomToggleSwitch extends StatefulWidget {
  const CustomToggleSwitch({super.key});

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  bool? _isOn;

  @override
  void initState() {
    super.initState();
    _loadPersistentState();
  }

  /// Load the switch position from SharedPreferences
  Future<void> _loadPersistentState() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? savedState = prefs.getBool('alert_switch_position');
    if (savedState != null) {
      if (mounted) {
        setState(() {
          _isOn = savedState;
        });
      }
    }
  }

  /// Save the switch position to SharedPreferences
  Future<void> _savePersistentState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alert_switch_position', value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        // Sync local state with server: Whenever a successful server update matching 
        // our chosen state arrives, we reset the local override to trust the server again.
        final alertData = state.homeDataResponseModel?.alertData ?? state.alertResponseModel?.data;
        final bool isServerAlertActive = alertData?.status == "1";
        
        if (_isOn != null && _isOn == isServerAlertActive) {
          setState(() => _isOn = null); 
        }
      },
      builder: (context, state) {
        final alertDataFromAlertsApi = state.alertResponseModel?.data;
        final alertDataFromHomeApi = state.homeDataResponseModel?.alertData;
        final alertData = alertDataFromHomeApi ?? alertDataFromAlertsApi;
        
        final bool isServerAlertActive = alertData?.status == "1";
        final bool hasExistingFilters = (alertData?.parsedCarsId.isNotEmpty ?? false) || 
                                        (alertData?.parsedLocations.isNotEmpty ?? false);

        // Effective switch position: use local override if present, else server state
        final bool displayValue = _isOn ?? isServerAlertActive;

        return GestureDetector(
          onTap: () {
            if (displayValue == true) {
              // TURNING OFF
              setState(() => _isOn = false);
              _savePersistentState(false);
              context.read<DashboardBloc>().add(UpdateAlertsEvent(
                    context: context,
                    alertType: alertData?.aleartType ?? "location_based",
                    carIds: alertData?.parsedCarsId ?? [],
                    locations: alertData?.parsedLocations ?? [],
                    manualPickup: alertData?.manuallyPickup ?? "no",
                    status: "0",
                  ));
            } else {
              // TURNING ON
              setState(() => _isOn = true); // Optimistic ON before navigating
              _savePersistentState(true);
              
              Nav.push(context, Routes.alertFilter).then((_) {
                // IMPORTANT: When returning, re-fetch from server
                context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
                context.read<DashboardBloc>().add(GetAlertsEvent(context: context));
                if (mounted) {
                   setState(() => _isOn = null); // Reset to re-sync
                }
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 44,
            height: 22,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: displayValue ? const Color(0xFFFFC107) : const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: displayValue ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
