from xml.dom import minidom
import sys

if len(sys.argv) != 2:
    print 'Usage: python parse_gpx_to_plain.py <activity.gpx>'
    sys.exit(0)

xmldoc = minidom.parse(sys.argv[1])
itemlist = xmldoc.getElementsByTagName('trkpt')
print 'time lat lon ele'
for s in itemlist:
    lat, lon = s.attributes['lat'].value, s.attributes['lon'].value
    ele = s.getElementsByTagName('ele')[0].firstChild.nodeValue
    time = s.getElementsByTagName('time')[0].firstChild.nodeValue
    print time, lat, lon, ele
