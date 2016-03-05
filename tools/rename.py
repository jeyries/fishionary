#!/usr/bin/env python
# rename files

import sys, os



    
    
def main():
    
    if ( len(sys.argv) < 2 ):
    
        print "exemple: python rename.py path"
        return
    

    for rootname in sys.argv[1:]:
        if (os.path.isfile(rootname)):
            newname = rootname.lower().replace(' ','_');
            if newname!=rootname:
                print "renaming", newname
                os.rename(rootname, newname)
        




if __name__ == "__main__":
    main()



    


