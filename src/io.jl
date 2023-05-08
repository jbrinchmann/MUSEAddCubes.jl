#
# FITS reading routine to read a slice of a FITS file.
#

using FITSIO
using CFITSIO


function fits_create_empty_hdu(f::FITSFile)

    status = Ref{Cint}(0)
    naxesr = C_NULL
    N = 0
    bitpix = bitpix_from_type(Int16)

    ccall(
         (:ffcrimll, CFITSIO.libcfitsio),
         Cint,
         (Ptr{Cvoid}, Cint, Cint, Ptr{Int64}, Ref{Cint}),
         f.ptr,
         bitpix,
         N,
         naxesr,
         status,
     )

    CFITSIO.fits_assert_ok(status[])
end


function fits_create_img(f::FITSFile, a::Nothing)
    status = fits_create_empty_hdu(f)
end


function read_slice(fname::String, extname::Union{String,Integer}, iz::Int)

    f = FITS(fname)

    hdu = f[extname]
    x = read(hdu, :, :, iz)

    close(f)
    
    return x
end

"""Read a stack of slices from a set of FITS files"""
function read_stack(fnames::Vector{String}, extension::Union{String,Integer},
                    iz::Int, nx::Int, ny::Int)

    N_files = length(fnames)
    stack = zeros(nx, ny, N_files)
    for i=1:N_files
        x = read_slice(fnames[i], extension, iz)
        stack[:, :, i] = x
    end

    return stack
end



"""Read in headers as from a set of MUSE files

We get a header from the primary HDU and then one from the DATA and STAT
extensions. 
"""
function read_MUSE_headers(fname; verbose=false)

    f = FITS(fname)

    if verbose
        println("The fits file $fname has ", length(f), " HDUs")
    end
    
    data_header = nothing
    stat_header = nothing
    primary_header = nothing
    if length(f) >= 3
        primary_header = read_header(f[1])
        data_header = read_header(f["DATA"])
        stat_header = read_header(f["STAT"])
    else
        primary_header = read_header(f[1])
    end
    close(f)
    
    return Dict("Primary" => primary_header, "Data" => data_header,
                "Stat" => stat_header)

end




function save_file(outfile::String, cube::Array{Float64,3},
                   dcube::Array{Float64,3}, headers::Dict)

    println(headers["Primary"])
    
    FITS(outfile, "w") do f
        fits_create_empty_hdu(f.fitsfile)
        FITSIO.fits_write_header(f.fitsfile, headers["Primary"], true)
#        write(f, nothing; header=headers["Primary"])
        write(f, cube; header=headers["Data"], name="DATA")
        write(f, dcube; header=headers["Stat"], name="STAT")

    end
    


end
