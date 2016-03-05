#!/usr/bin/env python
# conversion CSV vers JSON
# export PYTHONIOENCODING=utf-8

import sys, os
import json
import codecs
import re
import convert_xml_to_json
import shutil

######### regex stuff


pattern = r'link\("([^"]+)"="([^"]+)"\)';

repl = r'<a href="\2">\1</a>';


def linkrepl(matchobj):
    #if matchobj.group(0) == '-': return ' '
    #else: return '-'
    text = matchobj.group(1);
    href = matchobj.group(2);
    if (not href.startswith('http')):
        href = 'http://'+href;
    
    return  '<a href="%s" target="_blank">%s</a>' % (href, text);

def linksub(item):
    
    return re.sub(pattern, 
            linkrepl, 
            item);




      
#########   Unicode Character 'NO-BREAK SPACE' (U+00A0)



def process():
    
    print "building fishionary"
    
    
    ####
    
    # mode = 0 => single item
    # mode = 1 => multiple item separated by comma
    # mode = 2 => single item with links
    # mode = 3 => image
    
    props = [
    {"name":"english", "mode":0},
    {"name":"scientific", "mode":1},
    {"name":"image", "mode":3},
    {"name":"synonyms", "mode":1},
    {"name":"concern", "mode":2},
    {"name":"japanese", "mode":1},
    {"name":"hawaii", "mode":1},
    {"name":"korean", "mode":1},
    {"name":"france", "mode":1},
    {"name":"dutch", "mode":1},
    {"name":"deutsch", "mode":1},
    {"name":"catalan", "mode":1},
    {"name":"espana", "mode":1},
    {"name":"portugal", "mode":1},
    {"name":"italia", "mode":1},
    {"name":"swedish", "mode":1},
    {"name":"danish", "mode":1},
    {"name":"norway", "mode":1},
    {"name":"croatian", "mode":1},
    {"name":"greek", "mode":1},
    {"name":"russian", "mode":1},
    {"name":"turkey", "mode":1},
    {"name":"vietnamese", "mode":1},
    {"name":"mandarin", "mode":1},
    ]
    
    workaround = {
    "ASPITRIGLA CUCULUS":"aspitriglacuculus.jpg",
    "SERRANUS CABRILLA":"serranuscabrilla.jpg",
    "MUGIL SPP.":"mugillspp.jpg",
    "BOLINUS BRANDARIS":"bolinusbrandaris.jpg",
    "HELICOLENUS DACTYLOPTERUS":"heliocolenusdactylopterus.jpg",
    "ONCORBYNCHUS NERKA":"oncorhynchusnerka.jpg",
    "KATSUWONUS PELAMIS":"katsuwonuspelamis.jpg",
    
    }
        
    ###########
    
    convert_xml_to_json.process("database.xml")
    
    with open("database.json") as f:

        database_json = json.load(f);
        
    
    

        

    
    ######
    #print "database_json", database_json['table'][0]
        
    
    header = database_json['table'][0]
    for k in range(len(props)):
        item = None
        if k < len(header):
            item = header[k]
            
        props[k]['header']= item
            
    
            
    database = []
    
    image_not_found = 0
    
    # mode = 0 => single item
    # mode = 1 => multiple item separated by comma
    # mode = 2 => single item with links
    
    id_ = 0;
     
    for row in database_json['table'][1:]:
    
        #print "row=",row ;
    
        obj = {'id':id_};
        
        for k in range(len(props)):
            
            item = "";
            if k < len(row):
                item = row[k]
                
            item = item.strip()
            
            prop = props[k] 
            
            
            
            # single item
            if prop['mode']==0: 
            
                pass
            
            # multiple item separated by comma    
            elif prop['mode']==1:
                
                items = item.split(',')
                item = []
                for txt in items:
                    txt = txt.strip()
                    if len(txt)>1:
                        item.append(txt)
            
            #  single item with links           
            elif prop['mode']==2:
                
                item = linksub(item);
                
                
            #  image           
            elif prop['mode']==3:

                item = item.lower().replace(' ','_');
                
                
            # store item
            obj[prop['name']] = item
            
        #####
        
        english = obj['english']
        if (len(english)==0):
            continue
        
        scientific = obj['scientific'][0]
        if (len(scientific)==0):
            continue
            
        database.append(obj)
            
        print "item %d : %s / %s " % (id_,english,scientific)

        
        # check if image exists  
        if (scientific in workaround):
                print "using workaround : ", workaround[scientific]
                obj['image'] = workaround[scientific]
        
        ##        
        if not os.path.exists(os.path.join("../iOS/Fishionary/data/database",obj['image'])):
            
            print "image not found : ", obj['image'] 
            image_not_found += 1
        
        ####
        id_ += 1;
        
        
    ##############
    
    print "total= %d items" % len(database)
    print "image not found = %d files" % image_not_found
    if image_not_found :
        print "*** Stopping. Please correct this problem !"
        return
    
    ########
    
    convert_xml_to_json.process("localization.xml")
        
    with open("localization.json") as f:    

        localization_json = json.load(f);
        
    #######
    
    languages = [
    {"name":"english", "mode":0},
    {"name":"japanese", "mode":1},
    {"name":"hawaii", "mode":1},
    {"name":"korean", "mode":1},
    {"name":"france", "mode":1},
    {"name":"dutch", "mode":1},
    {"name":"deutsch", "mode":1},
    {"name":"catalan", "mode":1},
    {"name":"espana", "mode":1},
    {"name":"portugal", "mode":1},
    {"name":"italia", "mode":1},
    {"name":"swedish", "mode":1},
    {"name":"danish", "mode":1},
    {"name":"norway", "mode":1},
    {"name":"croatian", "mode":1},
    {"name":"greek", "mode":1},
    {"name":"russian", "mode":1},
    {"name":"turkey", "mode":1},
    {"name":"vietnamese", "mode":1},
    {"name":"mandarin", "mode":1},
    ]
    
    localization = {}
    
    for language in languages:
        
        localization[language['name']] = []
    
    for row in localization_json['table'][1:]:
        
        for k in range(len(languages)):
            
            item = "";
            if k < len(row):
                item = row[k]
                
            language = languages[k]
                
            localization[language['name']].append(item)
            
    ##############
    
    content = {
        "props":props,
        "database":database,
        "localization":localization,
    }


    content_json = json.dumps( content, indent=4);

    #print "json=", content_json

    print "writing to","fishionary.json"
    
    f = open("fishionary.json", 'w');
    f.write( content_json );
    f.close();

    shutil.copyfile("fishionary.json", "../iOS/Fishionary/data/fishionary.json")
    
   
    

    
    
def main():
    
    


    process()
        




if __name__ == "__main__":
    main()



    


