#!/usr/bin/env python
# conversion CSV vers JSON

import sys, os
#import csv
import json
import codecs
#fileObj = codecs.open( "someFile", "r", "utf-8" )



#f = open('template_meta.json', 'r');
#template_meta = f.read();
#f.close();

def csvreader( f ):
    
    delimiter=u';'
    quotechar=u'"'
    
    txt = f.read();
    
    state = 0  
    row =  []
    item = []
    
    for c in txt:
        
        #print  "state=",state,"c=",json.dumps(c);
        
        if state == 0:
         
            if c == quotechar:
                item = []
                state = 1
                
        elif state == 1:
            
            if c == quotechar:
                state = 2
                item = u''.join(item);
                #print "item=",json.dumps(item)
                row.append(item)
                item = []
            else:
                item.append(c)
            
        elif state == 2:
            
            if c == delimiter:
                state = 0;
            elif c == u"\n":
                state = 0;
                #print "row=",json.dumps(row)
                yield row;
                row =  []    
 
      


#########   
def process( rootname ):
    
    print "processing", rootname
    
    
    ###########
    
    (root, ext) = os.path.splitext(rootname);
    
    if ext == '.csv':
        
        print "using CVS parser"
        
    else:
        
        raise Exception('not a CVS file')

    #f = codecs.open(rootname, 'r', "utf-8");
    #reader = csv.reader(f, delimiter=';', quotechar='"')
    
    f = codecs.open(rootname, encoding='utf-8', mode='r' );
 
    table = []
    


        
    for row in csvreader( f ):
        
        #print "row=",json.dumps(row)

        table.append(row)
        
   
    
    
            
    
    
    ##############
    
    content = {
        "table":table,

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



    


