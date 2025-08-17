import numpy as np
from PIL import Image

WIDTH = 512
HEIGHT = 512
OUTPUT_MEM_FILE = "compressed.mem"
HUFF_CODE_FILE = "huff_code.mem"
HUFF_LEN_FILE = "huff_len.mem"
SAVE_NAME = "decoded_image.png"


bitstream = ""
with open(OUTPUT_MEM_FILE, "r") as f:
    for line in f:
        byte_str = line.strip()
        if len(byte_str) == 8:
            bitstream += byte_str


code_to_value = {}

with open(HUFF_CODE_FILE) as f_code, open(HUFF_LEN_FILE) as f_len:
    for i in range(512):
        code_line = f_code.readline().strip()     
        length_line = f_len.readline().strip()    

        if not code_line or not length_line:
            continue  

        length = int(length_line, 2)              

        if length == 0:
            continue  

  
        actual_code = code_line[-length:]
        code_to_value[actual_code] = i - 256      


errors = []
pointer = 0
max_code_len = 18

while pointer < len(bitstream):
    for L in range(1, max_code_len + 1):
        sub = bitstream[pointer:pointer + L]
        if sub in code_to_value:
            errors.append(code_to_value[sub])
            pointer += L
            break
    else:

        break

# === 4. RECONSTRUCT IMAGE ===
image = np.zeros((HEIGHT, WIDTH), dtype=np.uint8)

expected_pixels = WIDTH * HEIGHT
if len(errors) < expected_pixels:
    exit(1)
elif len(errors) > expected_pixels:
    errors = errors[:expected_pixels]

idx = 0
for y in range(HEIGHT):
    for x in range(WIDTH):
        if x > 0 and y > 0:
            left = image[y, x - 1]
            top = image[y - 1, x]
            pred = (int(left) + int(top)) // 2
        elif x > 0:
            pred = int(image[y, x - 1])
        elif y > 0:
            pred = int(image[y - 1, x])
        else:
            pred = 0  # Top-left corner

        pixel = pred + errors[idx]
        image[y, x] = np.clip(pixel, 0, 255)
        idx += 1


#SAVE IMAGE
Image.fromarray(image, mode='L').save(SAVE_NAME)
print("image saved")
