# MUSEAddCubes

[![Build Status](https://github.com/jbrinchmann/MUSEAddCubes.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jbrinchmann/MUSEAddCubes.jl/actions/workflows/CI.yml?query=branch%3Amain)

This is a simple package to combine spatially aligned reduced
datacubes from the [Multi-Unit Spectroscopic Explorer (MUSE)](https://www.eso.org/sci/facilities/develop/instruments/muse.html)


## Rationale

The MUSE data reduction pipeline provides a way for combining data
cubes, but sometimes you have very many cubes or you want to use the
difference between cubes as an estimate of the pixel-to-pixel
variation. In that case, the recommended approach is to reduce the
data with the same World Coordinate System and then combine the cubes
in some way. 

This is handled smoothly by the
[MPDAF](https://mpdaf.readthedocs.io/en/latest/) python package
through their `CubeList` interface. 

This is a minimalist implementation of this combination of cubes using
Julia. This is _not_ a fast implementation - it does not use memory
mapping of files, but rather opens and closes each file for each
wavelength layer. Thus a _lot_ of IO operations - but on the other
hand the code appears more robust than the memory mapped versions
which is a decent trade-off in some situations. 


