# JetFlavourTagging Extension Progress

## Overview

The JetFlavourTagging extension provides jet flavour tagging capabilities for the JetReconstruction.jl package. It integrates machine learning models (via ONNX) to classify jets based on their quark flavour content (b-jets, c-jets, light jets, etc.), which is crucial for many high-energy physics analyses.

## Architecture

### Core Components

1. **JetFlavourTagging.jl** - Main extension module that exports the public API
2. **JetConstituentBuilder.jl** - Handles building jet constituent collections from reconstructed particles
3. **JetConstituentUtils.jl** - Utility functions for extracting features from jet constituents
4. **JetFlavourHelper.jl** - Helper functions for ONNX model integration and feature preprocessing
5. **JetPhysicalConstants.jl** - Physical constants and special values used throughout

### Type Definitions

```julia
const JetConstituents = StructVector{ReconstructedParticle, <:Any}
const JetConstituentsData = Vector{Float32}
```

Currently defined redundantly in multiple files - consider centralizing.

## Dependencies

- **EDM4hep.jl** - Event data model for HEP
- **ONNXRunTime.jl** - For running neural network models
- **StructArrays.jl** - Efficient storage of constituent data
- **LorentzVectorHEP.jl** - 4-vector operations
- **PhysicalConstants.jl** - Physical constants (speed of light, particle masses)

## Key Functions

### Public API (exported via JetReconstruction)

- `build_constituents_cluster(reco_particles, indices)` - Build jet constituents from particle indices
- `extract_features(jets, jets_constituents, tracks, ...)` - Extract all features for tagging
- `setup_onnx_runtime(onnx_path, json_path)` - Initialize ONNX model
- `prepare_input_tensor(jets_constituents, jets, config, feature_data)` - Prepare NN inputs
- `get_weights(slot, vars, jets, jets_constituents, config, model)` - Get flavour probabilities

### Feature Extraction Categories

1. **Basic Kinematics** (11 features) - pt, p, E, mass, charge, theta, phi, y, eta, Bz
2. **Track Parameters** (5 features) - dxy, dz, phi0, C, ct
3. **Covariance Matrix** (15 elements) - Track parameter uncertainties
4. **Particle ID** (5 features) - is_mu, is_el, is_charged_had, is_gamma, is_neutral_had
5. **Relative Kinematics** (5 features) - Erel, theta_rel, phi_rel relative to jet axis
6. **Special Measurements** (2 features) - dE/dx, time-of-flight mass
7. **Impact Parameters** (12 features) - 2D/3D impact parameters and jet distances

## Recent Changes (This Session)

### 1. **Spelling Standardization**
   - Changed all occurrences of "flavor" to "flavour" for consistency
   - Updated in code, comments, and notebooks

### 2. **Function Naming Convention**
   - Renamed functions to lowercase with underscores:
     - `get_isMu` → `get_is_mu`
     - `get_isEl` → `get_is_el`
     - `get_isChargedHad` → `get_is_charged_had`
     - `get_isGamma` → `get_is_gamma`
     - `get_isNeutralHad` → `get_is_neutral_had`

### 3. **Type Flexibility**
   - Changed `setup_onnx_runtime` parameters from `String` to `AbstractString`
   - Updated `inference` function similarly

### 4. **Physical Constants Module**
   - Created `JetPhysicalConstants.jl` to centralize all constants
   - Integrated with PhysicalConstants.jl library for standard values
   - Replaced all hardcoded constants throughout the codebase

### 5. **Variable Naming Improvements**
   - `rps` → `reco_particles` (Reconstructed Particles)
   - `jcs` → `jets_constituents` (collection of all jets' constituents)
   - `csts` → `constituents_collection` (jet constituents collection)
   - `jc` → `single_jet_constituents` (single jet's constituents)

### 6. **Code Modernization**
   - Rewrote `get_constituents` function using `map` and `filter`
   - Fixed logic bug in constituent selection

## Known Issues

1. **Extension Loading**: The extension must be triggered by loading its dependencies (EDM4hep, ONNXRunTime) before use
2. **Type Alias Redundancy**: `JetConstituents` and `JetConstituentsData` are defined in multiple files
3. **Missing Functions**: Some functions mentioned in TODOs need to be restored

## Next Steps

1. **Centralize Type Definitions**: Create a shared module for common type aliases
2. **Complete Missing Functions**: Implement functions mentioned in TODO comments
3. **Add Tests**: Create comprehensive test suite for all feature extraction functions
4. **Documentation**: Add more detailed documentation for each feature category
5. **Performance Optimization**: Profile and optimize critical paths, especially in feature extraction
6. **Error Handling**: Add better error messages and validation for input data

## Usage Example

```julia
using EDM4hep  # Triggers extension loading
using JetReconstruction

# Load particles and reconstruct jets
recps = # ... load reconstructed particles
cs = jet_reconstruct(recps; p = 1.0, R = 2.0, algorithm = JetAlgorithm.EEKt)
jets = exclusive_jets(cs; njets=2, T=EEJet)

# Build constituents for each jet
constituent_indices = [constituent_indexes(jet, cs) for jet in jets]
jet_constituents = build_constituents_cluster(recps, constituent_indices)

# Setup ONNX model
model, config = setup_onnx_runtime("model.onnx", "config.json")

# Extract features and get predictions
features = extract_features(jets, jet_constituents, tracks, bz, track_L)
# ... continue with prediction
```

## References

- Original implementation: FCCAnalyses (C++)
- Physics basis: Jet flavour tagging at collider experiments
- Model format: ONNX for cross-platform ML deployment