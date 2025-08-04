# JetTaggingFCC.jl

[![Build Status](https://github.com/JuliaHEP/JetTaggingFCC.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaHEP/JetTaggingFCC.jl/actions/workflows/CI.yml?query=branch%3Amain)

Julia package for jet flavour tagging at Future Circular Collider (FCC)
experiments using machine learning.

## Overview

JetTaggingFCC.jl provides tools for identifying the quark flavor content of jets
in high-energy physics experiments. It uses ONNX neural network models to
classify jets based on their constituent particles.

## Features

- Load and process EDM4hep event data to extract physics features from jet constituents
- Run ONNX neural network inference for flavour classification

See the `examples/` directory for detailed usage examples.

**Important** This package need the pre-release version of `JetReconstruction`,
so currently `Pkg.develop("JetReconstruction")` is required.
