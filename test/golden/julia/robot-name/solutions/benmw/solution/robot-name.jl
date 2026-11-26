const name_history = Set{String}()

mutable struct Robot
    name::String
end
Robot() = Robot(getname())

function reset!(instance::Robot)
    instance.name = getname()
end

function name(instance::Robot)
    instance.name
end

getnewname() = join([rand('A':'Z', 2); rand('0':'9', 3)])
function getname()
    name = getnewname()
    while name in name_history
        name = getnewname()
    end
    push!(name_history, name)
    name
end
