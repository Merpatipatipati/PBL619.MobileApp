import re

with open('lib/pages/beranda_page.dart', 'r') as f:
    content = f.read()

content = re.sub(r'_buildInfoCard\(', r'PlantInfoCard(', content)
content = re.sub(r'_buildProgressCard\(', r'PlantProgressCard(', content)
content = re.sub(r'_buildSummaryItem\(', r'SummaryItemWidget(', content)

with open('lib/pages/beranda_page.dart', 'w') as f:
    f.write(content)
