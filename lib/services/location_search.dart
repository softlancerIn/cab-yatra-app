import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CustomLocationSearchField extends StatefulWidget {
  final double width;
  final double? height;
  final TextEditingController controller;
  final String hintText;
  final IconButton? iconButton;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final String? locationType;

  const CustomLocationSearchField({
    Key? key,
    required this.width,
    this.height,
    required this.controller,
    required this.hintText,
    this.iconButton,
    this.readOnly,
    this.validator,
    this.locationType,
  }) : super(key: key);

  @override
  _CustomLocationSearchFieldState createState() =>
      _CustomLocationSearchFieldState();
}

class _CustomLocationSearchFieldState extends State<CustomLocationSearchField> {
  List<String> _suggestions = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiKey = 'AIzaSyAsQryHkf5N7-bx_ZBMJ-X7yFMa9WTqwt0';
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&components=country:in';

    // Added location type filter if specified
    if (widget.locationType != null && widget.locationType == 'airport') {
      url += '&types=establishment&keyword=airport';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _suggestions = (data['predictions'] as List)
            .map((prediction) => prediction['description'] as String)
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: widget.readOnly ?? false,
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onChanged: (value) {
                    _onSearchChanged(value);
                    if (widget.validator != null) {
                      final errorMessage = widget.validator!(value);
                      if (errorMessage != null) {
                        print(errorMessage);
                      }
                    }
                  },
                ),
              ),
              if (widget.iconButton != null) widget.iconButton!,
            ],
          ),
          if (_isLoading) CircularProgressIndicator(),
          if (_suggestions.isNotEmpty)
            Container(
              height: 200,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      widget.controller.text = _suggestions[index];
                      setState(() {
                        _suggestions = [];
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
