import os
import cv2
import argparse
import numpy as np
import openslide
from distutils.util import strtobool
from tqdm.autonotebook import tqdm
import pandas as pd
from jupyfuncs.glob import makedirs


wsi_name = './data/BCL2A1.qptiff'
txt_name = './data/BCL2A1.txt'
tmaspotsize = 8500
outdir = './data/dearray_out/BCL2A1/'
level = 0
wsi_filename = wsi_name
txt_filename = txt_name
tmaspot_size = tmaspotsize
makedirs(outdir)


print(f"Extracting patches for {wsi_filename} into {outdir}")
# -

# if not os.path.isdir(f"{outdir}"):
#     os.mkdir(f"{outdir}")

slide = openslide.OpenSlide(wsi_filename)

# Print the slide's downsample info
level_dims = slide.level_dimensions[level]
level_downsample = slide.level_downsamples[level]
print(f'Downsample at level {level} is: {level_downsample}')
print(f'WSI dimensions at level {level} are: {level_dims}.')

bounds_x = float(slide.properties['openslide.bounds-x']) \
    if ("openslide.bounds-x") in slide.properties.keys() \
    else 410
bounds_y = float(slide.properties['openslide.bounds-y']) \
    if ("openslide.bounds-y") in slide.properties.keys() \
    else 180
ratio_x = 3.98
ratio_y = 3.98
# ratio_x = 1.0/float(slide.properties['openslide.mpp-x'])
# ratio_y = 1.0/float(slide.properties['openslide.mpp-y'])

# dataset = np.loadtxt(txt_filename, dtype=str, delimiter='\t', skiprows=1)
dataset = np.array(pd.read_csv(txt_filename, sep='\t'))
print(f"Number of rows in txt file ：{len(dataset)}") 

for row in tqdm(dataset):
    fname, label, missing, x, y = row
    if(not missing):
        x = (float(x) * ratio_x) + bounds_x
        y = (float(y) * ratio_y) + bounds_y
        print(f"Extracting spot {label} at location", (x, y))
        scaled_spot_size = (
            int(tmaspot_size / level_downsample),
            int(tmaspot_size / level_downsample)
        )
        tmaspot = np.asarray(
            slide.read_region(
                (int(x - tmaspot_size*0.5), int(y-tmaspot_size*0.5)),
                level,
                (8500, 8500)
            )
        )[:, :, 0:3]
        tmaspot = cv2.cvtColor(tmaspot,cv2.COLOR_RGB2BGR)
        cv2.imwrite(f"{outdir}/{label}.png", tmaspot)
    else:
        print(f'The spot {label} is missing, skipping!')

print('Extracted all the spots!')
