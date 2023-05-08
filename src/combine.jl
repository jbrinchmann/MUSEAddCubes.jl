
using Statistics
using StatsBase


"""Calculate the median stack for a vector

This calculates both the median and median absolute deviation
 as a spread indicator. We skip NaNs or missing data. 
"""
function median_stack(x::Array{Float64,1})

    # Do the statistics
    sx = skipmissing(x)
    med = median(sx)
    MAD = mad(sx; center=med, normalize=true)

    return med, MAD
end


"""Calculate the mean stack for a vector

This calculates both the mean and standard deviation
 as a spread indicator. We skip NaNs or missing data. 
"""
function mean_stack(x::Array{Float64,1})

    # Do the statistics
    sx = skipmissing(x)
    μ = mean(sx)
    σ = std(sx, mean=μ)

    return μ, σ
end



"""Stack an array of data along the third axis"""
function flatten_stack(c::Array{Float64,3}, method::String)

    if (method == "mean")
        stack_func = mean_stack
    elseif (method == "median")
        stack_func = median_stack
    else
        println("Unknown method $method")
        return nothing
    end

    nx, ny, nz = size(c)

    # Create the result arrays.
    m = zeros(nx, ny)
    σm = zeros(nx, ny)

    for i=1:nx
        for j=1:ny
            
            v, dv = stack_func(c[i,j,:])

            m[i, j] = v
            σm[i, j] = dv
        end
    end

    return m, σm
    
end
