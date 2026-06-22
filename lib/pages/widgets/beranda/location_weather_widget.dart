import 'package:flutter/material.dart';

class LocationWeatherWidget extends StatelessWidget {
  final bool isLoadingLocation;
  final String currentLocation;
  final bool isLoadingWeather;
  final IconData weatherIcon;
  final Color weatherColor;
  final String currentWeather;
  final VoidCallback onRefresh;

  const LocationWeatherWidget({
    super.key,
    required this.isLoadingLocation,
    required this.currentLocation,
    required this.isLoadingWeather,
    required this.weatherIcon,
    required this.weatherColor,
    required this.currentWeather,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lokasi Anda',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      isLoadingLocation
                          ? Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '...',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              currentLocation,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: 1,
            color: Colors.white.withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  weatherIcon,
                  color: weatherColor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cuaca',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      isLoadingWeather
                          ? Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '...',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              currentWeather,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onRefresh,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
