# using .Test:assert
# Part 1
# Read in puzzle input
list1 = Int64[]
list2 = Int64[]
puzzle_in = [rstrip(lstrip(x)) for x in readlines("input1.dat")]
for line in puzzle_in
    line = split(line, " ")
    filter!(x->x!="", line)
    push!(list1, parse(Int64, line[1]))
    push!(list2, parse(Int64, line[2]))
end
sort!(list1)
sort!(list2)

result = sum(abs.(list1 .- list2))
@show result

# Part 2, calculate similarity score
using DataStructures
c = counter(list2)
result = sum([x * c[x] for x in list1])
@show result