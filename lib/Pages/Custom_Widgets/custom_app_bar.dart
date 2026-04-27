import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:flutter/material.dart';

class AppBAR extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;
  final bool showAction;
  final Widget? actionWidget;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onTitleTap;

  const AppBAR({
    super.key,
    required this.title,
    this.showLeading = true, // default true
    this.showAction = false, // default false
    this.actionWidget,
    this.onLeadingPressed,
    this.onTitleTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              /// 🔙 Leading Icon
              SizedBox(
                width: 50,
                child: showLeading
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onLeadingPressed ??
                            () {
                              Nav.pop(context);
                            },
                        child: const Icon(Icons.arrow_back_ios, size: 20),
                      )
                    : const SizedBox.shrink(),
              ),

              /// 📌 Title
              Expanded(
                child: GestureDetector(
                  onTap: onTitleTap,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              /// 🚗 Action Icon
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 50),
                child: actionWidget ??
                    (showAction
                        ? SizedBox(
                            width: 50,
                            child: Image.asset(
                              "assets/images/appbar_car.png",
                              width: 50,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : const SizedBox.shrink()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
