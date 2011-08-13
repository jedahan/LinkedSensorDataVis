import datetime
import copy
import json


TEMPLATE = \
{
  "title" : "Pachube Office environment",
  "description" : "test of manual feed snapshotting",
  "feed" : "http://api.pachube.com/v2/feeds/504.json",
  "id" : 504,
  "status" : "frozen",
  "website" : "http://www.haque.co.uk/",
  "updated" : "2010-06-25T11:54:17.463771Z",
  "version" : "1.0.0",
  "private" : "false",
  "creator" : "http://www.pachube.com/users/hdr",
  "location":
    {
      "disposition":"fixed",
      "ele":"23.0",
      "name":"office",
      "lat":51.5235375648154,
      "exposure":"indoor",
      "lon":-0.0807666778564453,
      "domain":"physical"
    },
  "tags" : [
    "Tag1",
    "Tag2"
  ],
  "datastreams": []
}



def main():
    
    streams = [{"interval" : 5.0,      # interval in secounds
               "expression": "sin(x)", # expression x is the datapoint
               "count": 300,           # interval*count until the current time
               "id": "3",
               "unit": {
                    "type": "conversionBasedUnits",
                    "label": "label",
                    "symbol": "symbol"
      },}]          
    
    output = copy.copy(TEMPLATE)
    
    
    for stream in streams:
        begin_timestamp = datetime.datetime.now() - datetime.timedelta(
            seconds=stream["interval"] * stream["count"])
        datapoints = []
        for data_point in xrange(stream["count"]):
            current_timestamp = begin_timestamp + datetime.timedelta(
            seconds=stream["interval"] * data_point)
            current_value = eval(stream["expression"],
                 __import__('math').__dict__, {'x':data_point})
            
            datapoints.append({'at':current_timestamp.isoformat(), 'value': current_value})
        
        output["datastreams"].append({"id": stream['id'],
                                      "max_value":max(datapoints, key=lambda x: x['value'])['value'],
                                      "min_value":min(datapoints, key=lambda x: x['value'])['value'],
                                      "current_value":current_value,
                                      "at":current_timestamp.isoformat(),
                                      "datapoints":datapoints})
        
        
        print json.dumps(output)
            
        
    
    
    
if __name__ == '__main__':
    main()
    
