import os
from astropy.io import fits

def generate_region_content(center_ra, center_dec):

    header = """# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
fk5
"""
    outer_box = f"box({center_ra},{center_dec},94\",47\",2)"
    inner_box = f"-box({center_ra},{center_dec},35\",47\",2)"
    
    content = header + outer_box + "\n" + inner_box
    return content

def generate_bkg_content(center_ra, center_dec):

    header = """# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
fk5
"""
    box = f"box({center_ra},{center_dec},94\",47\",2)"
    
    content = header + box
    return content

def write_to_txt(filename, content):
    with open(filename, 'w') as file:
        file.write(content)
        
def search_content(filename):
    ra=[]
    dec=[]
    b_ra=[]
    b_dec=[]
    filename = f"./{filename}"
    # 打开FITS文件
    with fits.open(filename) as hdul:
        dec_str = f"{hdul[1].header.cards[245]}"
        ra_str = f"{hdul[1].header.cards[244]}"
        ra.append(float(ra_str[10:19]) * 100)
        dec.append(float(dec_str[10:19]) * 10)
        b_ra.append(float(ra_str[10:19]) * 100 - 0.055)
        b_dec.append(float(dec_str[10:19]) * 10 + 0.0039)
    return dec, ra, b_dec, b_ra

if __name__ == "__main__":
    # Traverse through all subdirectories in the current directory
    for ob in os.listdir('.'):
        if os.path.isdir(ob) and ob.startswith('0'):
            # Build the path to the relevant files
            out = f"out{ob}"
            stem = ob[:11]
            evt_filename = f"sw{stem}xwtw2po_cl.evt"
            # Enter the subdirectory
            os.chdir(out)
            if os.path.exists(evt_filename):
                dec, ra, b_dec, b_ra = search_content(evt_filename)
                if dec and ra:  # Check if ra and dec are not empty (file exists)
                    #content = generate_region_content(ra[0], dec[0])  # Assuming there is only one coordinate
                    bkg_content = generate_bkg_content(b_ra[0], b_dec[0])
                    #reg_filename = f"src_{stem}.reg"  # Generate the filename dynamically
                    bkg_filename = f"bkg_{stem}.reg"
                    write_to_txt(bkg_filename, bkg_content)
            # Return to the parent directory
            os.chdir('..')

