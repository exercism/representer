const StringOrMissing = Union{String, Missing}
const IntOrNothing = Union{Int64, Nothing}
using Base: @kwdef
@kwdef mutable struct Player
    name::StringOrMissing = missing
    level::Int64 = 0
    health::Int64 = 100
    mana::IntOrNothing = nothing
end
function introduce(player::Player)
    ismissing(player.name) ? "Mighty Magician" : player.name
end
function increment(name::Missing)
    "The Great"
end
function increment(name::String)
    name * " the Great"
end
function increment(mana::Nothing)
    50
end
function increment(mana::Int64)
    mana + 100
end
function title(player::Player)
    if player.level == 42
        player.name = increment(player.name)
    end
    return player.name
end
function revive(player::Player)
    if player.health == 0
        player.health = 100
        player.mana = increment(player.mana)
    end
    return player
end