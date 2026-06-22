import re

with open('lib/pages/beranda_page.dart', 'r') as f:
    content = f.read()

# Add imports
imports = """import 'package:application_hydrogami/pages/widgets/beranda/location_weather_widget.dart';
import 'package:application_hydrogami/pages/widgets/beranda/plant_progress_card.dart';
import 'package:application_hydrogami/pages/widgets/beranda/panduan_carousel_widget.dart';
import 'package:application_hydrogami/pages/widgets/beranda/plant_history_widget.dart';
"""
if "widgets/beranda/location_weather_widget.dart" not in content:
    content = content.replace("import 'package:flutter/material.dart';", imports + "import 'package:flutter/material.dart';")

# 1. LocationWeatherWidget
content = re.sub(r'_buildLocationWeatherWidget\(\)', r'''LocationWeatherWidget(
                  isLoadingLocation: _isLoadingLocation,
                  currentLocation: _currentLocation,
                  isLoadingWeather: _isLoadingWeather,
                  weatherIcon: _weatherIcon,
                  weatherColor: _weatherColor,
                  currentWeather: _currentWeather,
                  onRefresh: _getCurrentLocation,
                )''', content)

# 2. PlantProgressCard
content = re.sub(r'_buildProgressCard\((.*?)\)', r'PlantProgressCard(\1)', content)

# 3. PlantInfoCard
content = re.sub(r'_buildInfoCard\((.*?)\)', r'PlantInfoCard(\1)', content)

# 4. PanduanCarouselWidget
content = re.sub(r'_buildCarouselPanduan\(\)', r'''PanduanCarouselWidget(
            pageController: _pageController,
            currentSlide: _currentSlide,
            panduanData: _panduanData,
            onPageChanged: (index) {
              setState(() {
                _currentSlide = index;
              });
            },
          )''', content)

# 5. SummaryItemWidget
content = re.sub(r'_buildSummaryItem\(([^)]*?)\)', r'SummaryItemWidget(\1)', content)

# 6. TransactionItemWidget
content = re.sub(r'_buildTransactionItem\(([^)]*?)\)', r'TransactionItemWidget(activity: \1)', content)

# Remove the method definitions
# This uses regex to find the method signature and matches braces to remove the whole body
def remove_method(content, method_name):
    # Find the start of the method
    match = re.search(r'Widget\s+' + method_name + r'\s*\([^)]*\)\s*\{', content)
    if not match:
        return content
    
    start_idx = match.start()
    
    # We also want to remove any preceding comments for the method
    # Let's just find the start of the line or previous comment block
    lines = content[:start_idx].split('\n')
    lines_to_remove = 0
    for i in range(len(lines)-2, -1, -1):
        if lines[i].strip().startswith('//'):
            lines_to_remove += 1
        elif lines[i].strip() == '':
            lines_to_remove += 1
        else:
            break
            
    if lines_to_remove > 0:
        actual_start = content.rfind('\n', 0, start_idx - sum(len(l) + 1 for l in lines[-lines_to_remove-1:]))
        if actual_start != -1:
            start_idx = actual_start + 1

    # Find the matching closing brace
    brace_count = 0
    in_string = False
    string_char = ''
    i = match.end() - 1 # Position of the opening brace
    
    for idx in range(i, len(content)):
        char = content[idx]
        
        # Handle strings (skip braces inside them)
        if char in ['"', "'"]:
            if not in_string:
                in_string = True
                string_char = char
            elif string_char == char and content[idx-1] != '\\':
                in_string = False
                
        if not in_string:
            if char == '{':
                brace_count += 1
            elif char == '}':
                brace_count -= 1
                if brace_count == 0:
                    end_idx = idx + 1
                    return content[:start_idx] + content[end_idx:]
                    
    return content

methods_to_remove = [
    '_buildLocationWeatherWidget',
    '_buildProgressCard',
    '_buildInfoCard',
    '_buildCarouselPanduan',
    '_buildSummaryItem',
    '_buildTransactionItem'
]

for method in methods_to_remove:
    content = remove_method(content, method)

with open('lib/pages/beranda_page.dart', 'w') as f:
    f.write(content)

print("Done refactoring!")
