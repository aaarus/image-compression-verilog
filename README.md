# Predictive Image Compression using Huffman Encoding

A Verilog-based predictive image compression system that computes pixel prediction errors, applies Huffman encoding with a precomputed LUT, and packs variable-length codes into a byte-aligned bitstream. Simulated end-to-end in ModelSim.

---

## Project Overview

- **Input**: 512×512 8‑bit grayscale image (loaded via `$readmemh`).
- **Prediction**: Error computed as `error = actual_pixel - ((left_pixel + top_pixel) / 2)` with edge‑case handling.
- **Huffman Encoding**: Generated LUT of Huffman codes offline in Python from error histogram.
- **Bit-Packing**: Variable-length bitpacker module with FIFO‑style buffer.
- **Output**: Compressed byte stream stored in memeory.


![Block Diagram](<docs/block_diagram.png>)
## Architecture

```

[Image Mem] → [Predictor] → [Compute error] → [Huffman LUT] → [Bitpacker] → [Output Mem]
```

- **Image Mem**: ROM initialized from image mem file.
- **Predictor**: FSM loads left and top pixels, computes average, subtracts to yield signed 9‑bit error.
- **Huffman LUT**: 8‑bit code and length ROMs indexed by `error + 256`.
- **Bitpacker**: 24‑bit buffer, bit counter, shifts in codes and emits full bytes.
- **Output Mem**: Writes compressed bytes.

---

## Modules

**datapath.v:** Computes pixel prediction by averaging top and left pixel with edge conditions and calculates error by comparing with actual pixel value.

**bitpacker.v:** Uses Huffman code LUT to compute huffman codes from errors, pack codes into a buffer, tracks count, and emits packed bytes.

**controller.v:** 7‑state FSM controller.

**tb_top.v:** Top‑level testbench for simulation in ModelSim.      

---



## Tools & Languages

- **Verilog**
- **ModelSim** for simulation
- **Python** (with `dahuffman`) 


---

## Results

- **Original size**: 262 144 bytes
- **Compressed size**: \~145 897 bytes (\~44% reduction)

