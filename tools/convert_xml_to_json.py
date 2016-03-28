#!/usr/bin/env python
# conversion CSV vers JSON
# export PYTHONIOENCODING=utf-8

import sys, os
import xml.parsers.expat
import json
import codecs





############## XML table extractor

class TableXMLHandler:

    
    def __init__(self):

        self.table = []
        self.tr = []
        self.td = []
        self.inTD = 0
        
    def start_element(self, name, attrs):
        #print 'Start element:', name, attrs
        
        if name == "Table":
            self.table = []
        elif name == "Row":
            self.tr = []
        elif name == "Cell":
            self.td = []
            self.inTD = 1
    
    def end_element(self, name):
        #print 'End element:', name
        
        if name == "Table":
            pass
        elif name == "Row":
            self.table.append( self.tr )
            self.tr = []
            
        elif name == "Cell":
            self.inTD = 0
            self.tr.append( "".join(self.td) )
    
    def char_data(self, data):
        #print 'Character data:', repr(data)
        
        if self.inTD:
            self.td.append( data )
    
      
#########   Unicode Character 'NO-BREAK SPACE' (U+00A0)



def _process( rootname ):
    
    print "processing", rootname

  
    ###########
    
    (root, ext) = os.path.splitext(rootname);
    
    if ext == '.xml':
        
        print "using XML parser"
        handler = TableXMLHandler()
        
    else:
        
        raise Exception('not an XML file')
    
    
    
    
    p = xml.parsers.expat.ParserCreate()

    p.StartElementHandler = handler.start_element
    p.EndElementHandler = handler.end_element
    p.CharacterDataHandler = handler.char_data

    p.ParseFile(open(rootname,'r'))
    
    ###
    content = {
        "table":handler.table,

    }

    return content

def process( rootname ):

    content = _process(rootname)

    content_json = json.dumps( content, indent=4);
    
    #print "json=", content_json

 
    outputname = root+".json";
    print "writing to",outputname
    
    f = open( outputname, 'w');
    f.write( content_json );
    f.close();
    
   
    

    
    
def main():
    
    if ( len(sys.argv) < 2 ):
    
        print "exemple: python conversion.py path"
        return
    

    for rootname in sys.argv[1:]:
        if (os.path.isfile(rootname)):
            process(rootname)
        




if __name__ == "__main__":
    main()



    


