from PIL import Image, ImageSequence
import numpy as np
import json

img = Image.open("input.gif")
threshold = 1

data = []

for i, frame in enumerate(ImageSequence.Iterator(img)):
    arr = np.array(frame.convert("RGB"))
    count = int(np.sum(np.all(arr < threshold, axis=-1)))
    data.append({"frame": i, "black_pixel_count": count})

with open("black_pixel_counts.json", "w") as f:
    json.dump(data, f)
