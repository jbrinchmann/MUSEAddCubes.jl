module MUSEAddCubes

#
# This is a package to be able to add many aligned MUSE cubes
# together. The relevant situation here is when there are many cubes
# and they do not fit in memory at the same time.
#
# Thus this does the combination wavelength-layer by wavelength-layer
#
# The
#


include("io.jl")
include("combine.jl")
include("driver.jl")



end
