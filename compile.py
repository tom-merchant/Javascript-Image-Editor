import os

files = []

with open("compile.lst") as flist:
    files = flist.read().split("\n")
	
for file in files:
    file = file.replace("/", os.sep)
    ifile = file.replace(".coffee", ".out.coffee")
    os.system("cpp -I\"headers\" -P -undef -Wundef -std=c99 -nostdinc -Wtrigraphs -fdollars-in-identifiers -C -E " + file + " -o " + ifile)
    os.system("coffee --compile " + ifile)
    
os.system("codo -x out.coffee")

for file in files:
    ifile = file.replace(".coffee", ".out.coffee")
    os.remove(ifile.replace("out.coffee", "js"))
    os.rename(ifile.replace(".coffee", ".js"),ifile.replace(".coffee", ".js").replace("out.js", "js"))

