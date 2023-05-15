
using Statistics
using StatsBase


"""A weighted MAD estimator"""
wmad(x::Array{<:Real,1}, center::Real, w::Array{<:Real,1}) = median(abs.(x.-center), weights(w))*1.4826


"""Internal stack function

This is factored out from the median and mean functions because
really they are doing the same every time
"""
function stack(x::Array{<:Real,1}, type::String, weight::Array{<:Real,1})


    # Do the statistics - filter out NaNs
    keep = findall(!isnan, x)
    sx = x[keep]

    N_ok = length(sx)
    sweight = weight[keep]

    center, spread, N = NaN, NaN, 0.0

    if (N_ok > 0)
        if type == "median"
            center, spread, N = median_stack(sx, sweight)
        elseif type == "mean"
            center, spread, N = mean_stack(sx, sweight)
        else
            println("Unsupported satcking function $type.")
        end
    end
    
    return center, spread, N
end

"""Unweighted version"""
function stack(x::Array{<:Real,1}, type::String)


    # Do the statistics - filter out NaNs
    keep = findall(!isnan, x)
    sx = x[keep]

    N_ok = length(sx)

    center, spread, N = NaN, NaN, 0.0

    if (N_ok > 0)
        if type == "median"
            center, spread, N = median_stack(sx)
        elseif type == "mean"
            center, spread, N = mean_stack(sx)
        else
            println("Unsupported satcking function $type.")
        end
    end
    
    return center, spread, N
end



"""Calculate the median stack for a vector

This calculates both the median and median absolute deviation
 as a spread indicator. We skip NaNs or missing data. 
"""
function median_stack(x::Array{<:Real,1}, weight::Array{<:Real,1})

    med = median(x, weights(weight))
    # Since MAD does not support weights, we do it explicitly here
    MAD = wmad(x, med, weight)
    used = sum(weight)
    
    return med, MAD, used
end


"""Unweighted version"""
function median_stack(x::Array{<:Real,1})

    med = median(x)
    MAD = mad(x; center=med, normalize=true)
    used = float(length(x))
    
    return med, MAD, used
end



"""Calculate the mean stack for a vector

This calculates both the mean and standard deviation
 as a spread indicator. We skip NaNs or missing data. 
"""
function mean_stack(x::Array{<:Real,1}, weight::Array{<:Real,1})

    μ = mean(x, weights(weigth))
    σ = std(x, weights(weight), mean=μ)
    used = sum(weight)
    return μ, σ, used
end

function mean_stack(x::Array{<:Real,1})

    μ = mean(x)
    σ = std(x, mean=μ)
    used = float(length(x))
    return μ, σ, used
end






"""Stack an array of data along the third axis"""
function flatten_stack(c::Array{<:Real,3}, method::String)

    nx, ny, nz = size(c)

    # Create the result arrays.
    m = zeros(nx, ny)
    σm = zeros(nx, ny)
    N_exp = zeros(nx, ny)

    for i=1:nx
        for j=1:ny
            
            v, dv, N = stack(c[i,j,:], method)

            m[i, j] = v
            σm[i, j] = dv
            N_exp[i, j] = N
        end
    end

    return m, σm, N_exp
    
end



"""Stack an array of data along the third axis"""
function flatten_stack(c::Array{<:Real,3}, method::String, weight::Array{<:Real,1})

    nx, ny, nz = size(c)

    # Create the result arrays.
    m = zeros(nx, ny)
    σm = zeros(nx, ny)
    N_exp = zeros(nx, ny)

    for i=1:nx
        for j=1:ny
            
            v, dv, N = stack(c[i,j,:], method, weight)

            m[i, j] = v
            σm[i, j] = dv
            N_exp[i, j] = N
        end
    end

    return m, σm, N_exp
    
end

