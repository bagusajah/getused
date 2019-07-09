#!/usr/bin/env python
import sys,hashlib

filename1 = sys.argv[1]
filename2 = sys.argv[2]

def file_as_bytes(file):
    with file:
        return file.read()

print filename1,"-",hashlib.md5(file_as_bytes(open(filename1, 'rb'))).hexdigest()
print filename2,"-",hashlib.md5(file_as_bytes(open(filename2, 'rb'))).hexdigest()
