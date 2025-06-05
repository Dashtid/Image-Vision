# Image Vision Algorithms: Frequency Domain, Edge Detection, and Segmentation

This project demonstrates core image processing and computer vision algorithms in MATLAB, including frequency domain filtering, edge detection, Hough transform, and several image segmentation techniques. The code is organized as self-contained scripts for educational and experimental use.

## Contents

- **frequency_domain_image_processing/**
  - `frequency_domain_demo.m`: Demonstrates DFT properties, frequency filtering, convolution, smoothing, and subsampling in the frequency domain.
- **edge_detection_and_hough_transform/**
  - `edge_detection_demo.m`: Shows edge detection using Sobel operators, thresholding, differential geometry descriptors, and the Hough transform for line detection.
- **image_segmentation_algorithms/**
  - `segmentation_algorithms_demo.m`: Runs and visualizes k-means, mean-shift, normalized cuts, and graph cut segmentation algorithms.

## Features

- **Frequency Domain Analysis**: Visualizes DFT properties, linearity, convolution, and the effects of filtering and subsampling.
- **Edge Detection**: Applies Sobel filters, gradient magnitude thresholding, zero-crossing and curvature-based descriptors, and Hough transform for line detection.
- **Image Segmentation**: Includes k-means clustering, mean-shift, normalized cuts, and graph cut segmentation, with visualization of results and overlays.

## Usage

1. Open the desired `.m` script in MATLAB.
2. Run the script (e.g., `frequency_domain_demo.m`, `edge_detection_demo.m`, or `segmentation_algorithms_demo.m`).
3. The scripts will display figures illustrating the results of each algorithm.

### Example

To run the frequency domain demo:

```matlab
cd frequency_domain_image_processing
frequency_domain_demo
```
