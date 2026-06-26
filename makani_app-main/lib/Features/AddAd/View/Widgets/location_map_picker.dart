import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_constants.dart';

class LocationMapPicker extends StatefulWidget {
  const LocationMapPicker({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onTapMap,
    this.loading = false,
  });

  final double? latitude;
  final double? longitude;
  final void Function(double lat, double lng) onTapMap;
  final bool loading;

  @override
  State<LocationMapPicker> createState() => _LocationMapPickerState();
}

class _LocationMapPickerState extends State<LocationMapPicker> {
  late final MapController _controller = MapController();

  LatLng get _center {
    final lat = widget.latitude ?? AddAdConstants.defaultLat;
    final lng = widget.longitude ?? AddAdConstants.defaultLng;
    return LatLng(lat, lng);
  }

  @override
  void didUpdateWidget(covariant LocationMapPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.latitude != oldWidget.latitude ||
        widget.longitude != oldWidget.longitude) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.move(
            LatLng(
              widget.latitude ?? AddAdConstants.defaultLat,
              widget.longitude ?? AddAdConstants.defaultLng,
            ),
            _controller.camera.zoom,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: SizedBox(
        height: 220.h,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 14,
                onTap: (tapPosition, point) {
                  widget.onTapMap(point.latitude, point.longitude);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.makani_app',
                ),
                if (widget.latitude != null && widget.longitude != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(widget.latitude!, widget.longitude!),
                        width: 44,
                        height: 44,
                        alignment: Alignment.bottomCenter,
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.primary700,
                          size: 44.r,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (widget.loading)
              Container(
                color: Colors.white54,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
