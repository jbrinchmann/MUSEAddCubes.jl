using MUSEAddCubes
using Test

@testset "MUSEAddCubes.jl" begin
    m, ma, N1 = MUSEAddCubes.median_stack([1.0,2,3])
    μ, σ, N2 = MUSEAddCubes.mean_stack([1.0,3.0,5.0])
    
    @test [m, ma] ≈ [2.0, 1.4826022185] atol=1
    @test [μ, σ] == [3.0, 2.0]
    @test N1 == 3
    
    # Test the impact of NaNs
    m, ma, N = MUSEAddCubes.stack([1.0,2,3, NaN, 10.0, 1.0], "median")
    @test m == 2.0
    @test N == 5
    
    m, ma, N = MUSEAddCubes.stack([NaN, NaN], "mean")
    @test isnan(m)
    @test N == 0


    #
    # Test the flattening of the cube
    # Since median and mean have both been tested separately above,
    # I only test the flattening using median
    #
    c = ones(3,3,4)
    m, MAD = MUSEAddCubes.flatten_stack(c, "median")
    @test m == ones(3,3)
    @test MAD == zeros(3, 3)

    # Slight change to the cube
    c[2, 2, 1:2] .= 2
    m, MAD = MUSEAddCubes.flatten_stack(c, "median")
    @test m[2,2] == 1.5
    @test MAD[2,2] ≈ 0.7413011092528009 atol=1e-3
    
    
    
end
