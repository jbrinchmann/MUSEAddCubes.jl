#
# The code that drives the co-addition.
#


using ProgressMeter

"""Given a list of FITS file names, combine these

The routine does not at the moment do any error checking - all sizes 
assumed to be identical. This is easy to add however.
"""
function combine_cubes(cubefiles::Vector{String}, method::String, outdir::String;
                       verbose=false)

    #
    # Initial steps - get the number of files and the
    # header of the first. This is where we can add in som
    # sanity checks later.
    #
    
    n_files = length(cubefiles)
    headers = read_MUSE_headers(cubefiles[1])

    n_l = headers["Data"]["NAXIS3"]
    n_x = headers["Data"]["NAXIS1"]
    n_y = headers["Data"]["NAXIS2"]


    cube = zeros(n_x, n_y, n_l)
    dcube = zeros(n_x, n_y, n_l)
    Ncube = zeros(n_x, n_y, n_l)
    
    @showprogress 1 for iz=1:n_l

        if verbose
            println("Doing slice I=$iz")
        end
        # First load this slice level
        stack = read_stack(cubefiles, "DATA", iz, n_x, n_y)

        # Then flatten this.
        im, σ, N_exp = flatten_stack(stack, method)

        # Then insert this into the cube
        cube[:, :, iz] = im
        dcube[:, :, iz] = σ
        Ncube[:, :, iz] = N_exp

    end

    save_files(outdir, cube, dcube, Ncube, headers)

end
