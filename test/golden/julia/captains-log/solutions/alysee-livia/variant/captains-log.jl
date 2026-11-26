function random_planet()
    rand(('D','H','J','K','L','M','N','R','T','Y'))
end

function random_ship_registry_number()
    numb = rand(1000:9999, 1)
    return "NCC-" / join(numb)
end

function random_stardate()
    41000 + rand() * 1000
end

function random_stardate_v2()
    rand(41000.0:0.1:42000.0)
end

using Random
function pick_starships(starships, number_needed)
    sr = Random.shuffle(starships)
    return sr[1:number_needed]
end
