#generate_pure_freq_image.py
#Tom Merchant 2018
#Creates a 92x92 92dpi bitmap image of a specified number of cycles per inch

import math
import struct

image = [[0 for x in range(92)] for y in range(92)] 

freq = int(input("enter frequency [0-46]: "))

freq /= 92


for x in range(92):
    for y in range(92):
        image[x][y] = math.sin(2 * math.pi * freq * x) + math.cos(2 * math.pi * freq * y)

with open("output2.bmp", "wb") as bitmap:
    #ty to http://blog.paphus.com/blog/2012/08/14/write-your-own-bitmaps/
    body = bytes("", "ASCII")
    for x in range(92):
        for y in range(92):
            #92 divides by for, we don't need to worry about padding
            for i in [0, 1, 2]:
                body += struct.pack("B", math.floor((image[x][y] + 2) * 255 / 4))
    #File size isn't known yet so 0xFFFFFF is just a placeholder
    header = bytes("BM", "ASCII")
    header += struct.pack("<i", len(body) + 54)
    header += struct.pack("<i", 0)
    header += struct.pack("<i", 54)
    header += struct.pack("<i", 40)
    header += struct.pack("<i", 92)
    header += struct.pack("<i", 92)
    header += struct.pack("<H", 1)
    header += struct.pack("<H", 24)
    header += struct.pack("<i", 0)
    header += struct.pack("<i", len(body))
    header += struct.pack("<i", 3622)
    header += struct.pack("<i", 3622)
    header += struct.pack("<i", 0)
    header += struct.pack("<i", 0)
    #This is going to be upside down but it makes no difference whatsoever
    bitmap.write(header + body)
    
