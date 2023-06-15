#!/usr/bin/env python
import fileinput
import fnmatch
import os
import sys
import errno
from os.path import join as jp
import pdb


if len(sys.argv) != 2:
    print("Usage is " + sys.argv[0] + "<directory>")
    sys.exit(1)

sysroot_var = jp("/home/$ENV{USER}","X3399","ros1_aarch64_cross_compilation/aarch64_sysroot/")
sysroot_dir = os.path.abspath(sys.argv[1]) + "/"
aarch64_libs_dir = jp(sysroot_dir,"usr/lib/aarch64-linux-gnu")


def fix_broken_links():
    matches = []
    for root, dirnames, filenames in os.walk(aarch64_libs_dir):
        for filename in fnmatch.filter(filenames, '*.so'):
            matches.append(jp(root, filename))

    for lib in matches:
        if not os.path.exists(lib):
            realpath = os.path.realpath(lib) 
            print ("broken link: ", lib,"->",realpath)
            if realpath.startswith("/lib/"):
                fixed_path = jp(sysroot_dir,realpath.lstrip('/'))
                print ("fixed path:", fixed_path)
                os.remove(lib)
                os.symlink(fixed_path,lib)
                if os.path.realpath(lib) == os.path.realpath(fixed_path):
                    print ("great success :)")
            print ("skipping....")



def fix_cmake_config():
    matches = []
    for root, dirnames, filenames in os.walk(sysroot_dir):
        for filename in fnmatch.filter(filenames, '*.cmake'):
            matches.append(jp(root, filename))

    for cmake_file in matches:
        print ("editing file:" + cmake_file)
        for line in fileinput.FileInput(cmake_file, inplace=True, backup='.bak'):
            print(line.rstrip() \
                    .replace(r";/usr/",   ";" + sysroot_var + r"usr/") \
                    .replace(r";/opt/",   ";" + sysroot_var + r"opt/") \
                    .replace(r";/lib/",   ";" + sysroot_var + r"lib/") \
                    .replace(r"\"/usr/", "\"" + sysroot_var + r"usr/") \
                    .replace(r"\"/opt/", "\"" + sysroot_var + r"opt/") \
                    .replace(r"\"/lib/", "\"" + sysroot_var + r"lib/") \
                    .replace(r'"/usr/',  "\"" + sysroot_var + r"usr/") \
                    .replace(r" /usr/",   " " + sysroot_var + r"usr/") \
                    .replace(r" /opt/",   " " + sysroot_var + r"opt/") \
                    .replace(r" /lib/",   " " + sysroot_var + r"lib/") \
                    .replace(r"x86_64-linux-gnu","aarch64-linux-gnu"))


def main():
    #pdb.set_trace()
    fix_cmake_config()
    #fix_broken_links() #use sysroot-relativelinks.py instead


if __name__== "__main__":
    main()
