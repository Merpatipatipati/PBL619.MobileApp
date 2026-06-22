import re

with open('lib/pages/beranda_page.dart', 'r') as f:
    lines = f.readlines()

new_lines = []
skip_ranges = [
    (1574, 1850), # InfoCard, ProgressCard, LocationWeather
    (2130, 2174), # SummaryItem
    (2203, 2396), # Carousel, TransactionItem
]

# Note: 1-indexed for easy matching
for i, line in enumerate(lines, 1):
    skip = False
    for r in skip_ranges:
        if r[0] <= i <= r[1]:
            skip = True
            break
            
    if skip:
        continue
        
    # Replace usages
    line = re.sub(r'_buildProgressCard\((.*?)\)', r'PlantProgressCard(\1)', line)
    line = re.sub(r'_buildInfoCard\((.*?)\)', r'PlantInfoCard(\1)', line)
    line = re.sub(r'_buildSummaryItem\(([^)]*?)\)', r'SummaryItemWidget(\1)', line)
    line = re.sub(r'_buildTransactionItem\(([^)]*?)\)', r'TransactionItemWidget(activity: \1)', line)
    
    # Handle LocationWeatherWidget
    if "_buildLocationWeatherWidget()" in line:
        line = line.replace("_buildLocationWeatherWidget()", """LocationWeatherWidget(
                  isLoadingLocation: _isLoadingLocation,
                  currentLocation: _currentLocation,
                  isLoadingWeather: _isLoadingWeather,
                  weatherIcon: _weatherIcon,
                  weatherColor: _weatherColor,
                  currentWeather: _currentWeather,
                  onRefresh: _getCurrentLocation,
                )""")
                
    # Handle Carousel
    if "_buildCarouselPanduan()" in line:
        line = line.replace("_buildCarouselPanduan()", """PanduanCarouselWidget(
            pageController: _pageController,
            currentSlide: _currentSlide,
            panduanData: _panduanData,
            onPageChanged: (index) {
              setState(() {
                _currentSlide = index;
              });
            },
          )""")
          
    # Add imports after the last import
    if i == 27: # Right before class BerandaPage
        new_lines.append("import 'package:application_hydrogami/pages/widgets/beranda/location_weather_widget.dart';\n")
        new_lines.append("import 'package:application_hydrogami/pages/widgets/beranda/plant_progress_card.dart';\n")
        new_lines.append("import 'package:application_hydrogami/pages/widgets/beranda/panduan_carousel_widget.dart';\n")
        new_lines.append("import 'package:application_hydrogami/pages/widgets/beranda/plant_history_widget.dart';\n")
        
    new_lines.append(line)

with open('lib/pages/beranda_page.dart', 'w') as f:
    f.writelines(new_lines)
