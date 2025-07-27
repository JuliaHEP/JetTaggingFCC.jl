module JetTaggingFCC

using JetReconstruction
using EDM4hep
using JSON
using ONNXRunTime
using StructArrays: StructVector
using LorentzVectorHEP

const JetConstituents = StructVector{ReconstructedParticle,<:Any}
const JetConstituentsData = Vector{Float32}

# Include constituent utilities (as a module for now)
include("JetConstituentUtils.jl")
using .JetConstituentUtils

# Include jet constituent builder functions
include("JetConstituentBuilder.jl")

# Include flavour helper functions
include("JetFlavourHelper.jl")

# Export all public functions
export build_constituents_cluster
export extract_features
export setup_onnx_runtime
export prepare_input_tensor
export get_weights
export get_weight

# Export types
export JetConstituents, JetConstituentsData

end # module JetTaggingFCC
