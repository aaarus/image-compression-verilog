
with open("lena.raw", "rb") as f:
    raw_data = f.read()

with open("lena.mem", "w") as f:
    for byte in raw_data:
        f.write(f"{byte:02X}\n")  # write one byte per line in uppercase hex
