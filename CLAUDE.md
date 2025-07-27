# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Build and Package Management
- `julia --project` - Start Julia with the project environment
- `] instantiate` - Install all dependencies from Project.toml
- `] update` - Update dependencies
- `] build` - Build the package

### Testing
- `julia --project -e 'using Pkg; Pkg.test()'` - Run all tests
- `julia --project test/runtests.jl` - Run tests directly

### Running Examples
- `cd examples/flavour-tagging && julia --project simple-flavour-tagging.jl` - Run the flavour tagging example
- First run `julia --project -e 'using Pkg; Pkg.resolve(); Pkg.instantiate()'` in the example directory

### Formatting
The repository uses automatic formatting via GitHub Actions. JuliaFormatter is used with default settings in pull requests.

## High-Level Architecture

JetTaggingFCC.jl is a Julia package for jet flavour tagging in high-energy physics, designed to integrate with the JetReconstruction.jl ecosystem. It uses ONNX neural network models to classify jets based on their quark flavour content (b-jets, c-jets, light jets).

### Core Architecture Pattern

1. **Main Module** (`JetTaggingFCC.jl`): Entry point that includes and exports the JetFlavourTagging submodule
2. **Feature Extraction Pipeline**: Extracts 59 physics features from jet constituents:
   - Basic kinematics (pt, energy, mass, etc.)
   - Track parameters and covariance matrices
   - Particle identification flags
   - Impact parameters and relative measurements
3. **ONNX Integration**: Uses ONNXRunTime.jl to run pre-trained neural networks for classification

### Key Dependencies Integration

- **EDM4hep.jl**: Provides the `ReconstructedParticle` type and event data model
- **JetReconstruction.jl**: Core jet reconstruction algorithms (this package extends it)
- **LorentzVectorHEP.jl**: 4-vector operations for particle physics
- **StructArrays.jl**: Efficient storage of constituent collections

### Data Flow

1. Reconstructed particles → Jet reconstruction → Jet constituents
2. Feature extraction from constituents (59 features per constituent)
3. ONNX model inference → Flavour probabilities

### Important Type Aliases

```julia
const JetConstituents = StructVector{ReconstructedParticle, <:Any}
const JetConstituentsData = Vector{Float32}
```

Currently defined redundantly across modules - consider this when adding new types.

## Development Notes

- The package uses Julia's package extension mechanism - EDM4hep must be loaded to trigger the extension
- Physical constants are centralized in `JetPhysicalConstants.jl` using PhysicalConstants.jl
- Feature extraction functions follow the naming pattern `get_<feature_name>`
- All "flavor" spellings have been standardized to "flavour" throughout the codebase