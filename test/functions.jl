using NamedDims
using NamedDims: names
using Test
using Statistics

@testset "Base" begin
a = [10 20; 31 40]
nda = NamedDimsArray(a, (:x, :y))

@testset "$f" for f in (sum, prod, maximum, minimum, extrema)
    @test f(nda) == f(a)
    @test f(nda; dims=:x) == f(nda; dims=1) == f(a; dims=1)

    @test names(f(nda; dims=:x)) == (:x, :y) == names(f(nda; dims=1))
end

@testset "mapslices" begin
    @test mapslices(join, nda; dims=:x) == ["1031" "2040"] == mapslices(join, nda; dims=1)
    @test mapslices(join, nda; dims=:y) == reshape(["1020", "3140"], Val(2)) == mapslices(join, nda; dims=2)
    @test_throws UndefKeywordError mapslices(join, nda)
    @test_throws UndefKeywordError mapslices(join, a)

    @test names(mapslices(join, nda; dims=:y)) == (:x, :y) == names(mapslices(join, nda; dims=2))
end

@testset "mapreduce" begin
    @test mapreduce(isodd, |, nda; dims=:x) == [true false] == mapreduce(isodd, |, nda; dims=1)
    @test mapreduce(isodd, |, nda; dims=:y) == [false true]' == mapreduce(isodd, |, nda; dims=2)
    @test mapreduce(isodd, |, nda) == true == mapreduce(isodd, |, a)

    @test names(mapreduce(isodd, |, nda; dims=:y)) == (:x, :y) == names(mapreduce(isodd, |, nda; dims=2))
end

@testset "zero" begin
    @test zero(nda) == [0 0; 0 0] == zero(a)
    @test names(zero(nda)) == (:x, :y)
end
