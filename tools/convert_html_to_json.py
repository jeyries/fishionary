#!/usr/bin/env python
# conversion CSV vers JSON
# export PYTHONIOENCODING=utf-8

import sys, os
import xml.parsers.expat
import json
import codecs





############## HTML table extractor

class TableHTMLHandler:

    
    def __init__(self):

        self.table = []
        self.tr = []
        self.td = []
        self.inTD = 0
        
    def start_element(self, name, attrs):
        #print 'Start element:', name, attrs
        
        if name == "table":
            self.table = []
        elif name == "tr":
            self.tr = []
        elif name == "td":
            self.td = []
            self.inTD = 1
    
    def end_element(self, name):
        #print 'End element:', name
        
        if name == "table":
            pass
        elif name == "tr":
            self.table.append( self.tr )
            self.tr = []
            
        elif name == "td":
            self.inTD = 0
            self.tr.append( "".join(self.td) )
    
    def char_data(self, data):
        #print 'Character data:', repr(data)
        
        if self.inTD:
            self.td.append( data )
    
      
#########   Unicode Character 'NO-BREAK SPACE' (U+00A0)



def process( rootname ):
    
    print "processing", rootname

  
    ###########
    
    (root, ext) = os.path.splitext(rootname);
    
    if ext == '.html':
        
        print "using HTML parser"
        handler = TableHTMLHandler()
        
    else:
        
        raise Exception('not an HTML file')
    
    
    
    
    p = xml.parsers.expat.ParserCreate()

    p.StartElementHandler = handler.start_element
    p.EndElementHandler = handler.end_element
    p.CharacterDataHandler = handler.char_data

    p.ParseFile(open(rootname,'r'))
    
    ###
    content = {
        "table":handler.table,

    }


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



    


