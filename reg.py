import os
from astropy.io import fits

def generate_region_content(center_ra, center_dec):

    header = """# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
physical
"""
    circle = f"annulus({center_ra},{center_dec},{radius},30.034208)"
    content = header + circle
    return content

def write_to_txt(filename, content):
    with open(filename, 'w') as file:
        file.write(content)

if __name__ == "__main__":
    #修改你的中心
    center_ra = input("Please enter ra: ")
    center_dec = input("Please enter dec: ")

    for radius in range(0,21):
        region_content = generate_region_content(center_ra, center_dec)
        filename=f"c{radius}.reg"
        write_to_txt(filename,region_content)
        print(f"Region file {filename} has been created.")