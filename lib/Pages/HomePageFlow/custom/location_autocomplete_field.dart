import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../cores/services/google_places_service.dart';

class LocationAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  const LocationAutocompleteField({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  State<LocationAutocompleteField> createState() =>
      _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  final GooglePlacesService _placesService = GooglePlacesService();
  List<String> _suggestions = [];
  Timer? _debounce;
  bool _isLoading = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _hideOverlay();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length > 1) {
        setState(() => _isLoading = true);
        final results = await _placesService.getSuggestions(query);
        if (mounted && _focusNode.hasFocus) {
          setState(() {
            _suggestions = results;
            _isLoading = false;
          });
          if (_suggestions.isNotEmpty || _isLoading) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        }
      } else {
        _hideOverlay();
      }
    });
  }

  void _showOverlay() {
    _hideOverlay();
    if (!mounted || !_focusNode.hasFocus) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _suggestions[index],
                            style: const TextStyle(fontSize: 13),
                          ),
                          onTap: () {
                            widget.controller.text = _suggestions[index];
                            _hideOverlay();
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffDBDBDB)),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
