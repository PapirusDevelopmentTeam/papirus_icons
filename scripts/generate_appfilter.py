import json
from os import path, remove

ABS_PATH = path.dirname(path.abspath(__file__))
DB_FILE = path.join(ABS_PATH, 'data.json')

APPFILTER_FILE = path.join(ABS_PATH, 'xml/appfilter.xml')

# Remove the existing appfilter.xml file
if path.exists(APPFILTER_FILE):
    remove(APPFILTER_FILE)

# Read the database
with open(DB_FILE, 'r') as db_obj:
    try:
        data = json.load(db_obj)
    except ValueError:
        print("Invalid JSON database file")
        exit(0)

app_filter_content = '<?xml version="1.0" encoding="utf-8"?>\n'
app_filter_content += '<resources>\n'

for icon_src, components in data.items():
    drawable_name = path.basename(icon_src)
    for component_info in components:
        app_filter_content += '\t<item component="ComponentInfo{' + \
            component_info + '}" drawable="' + drawable_name + '"/>\n'

app_filter_content += '</resources>'
with open(APPFILTER_FILE, 'w') as app_filter_obj:
    app_filter_obj.write(app_filter_content)
