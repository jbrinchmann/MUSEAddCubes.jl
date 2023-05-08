using MUSEAddCubes
using Test

@testset "MUSEAddCubes.jl" begin
    m, ma = MUSEAddCubes.median_stack([1.0,2,3])
    μ, σ = MUSEAddCubes.mean_stack([1.0,3.0,5.0])
    
    @test [m, ma] ≈ [2.0, 1.4826022185] atol=1
    @test [μ, σ] == [3.0, 2.0]
end
