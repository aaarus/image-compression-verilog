from PIL import Image
import numpy as np

input_image = "decoded.png"
output_mem = "decoded_image.mem"


img = Image.open(input_image).convert("L")  
pixels = np.array(img)

with open(output_mem, "w") as f:
    for row in pixels:
        for value in row:
            f.write(f"{value:02X}\n") 
