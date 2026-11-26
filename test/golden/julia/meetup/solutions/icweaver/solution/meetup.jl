### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ d6b63fbe-57af-42c5-9328-282c093e4001
using Dates

# ╔═╡ 88c31eda-cd74-11ef-2f33-6382e3607617
function meetup(year, month, week, day)
	x = if week == "first"
		1:7
	elseif week == "second"
		8:14
	elseif week == "third"
		15:21
	elseif week == "teenth"
		13:19
	elseif week == "fourth"
		22:28
	elseif week == "last"
		22:daysinmonth(year, month)
	else
		throw("todo")
	end
	days = map(dayname, (Date(year, month, i) for i in x))
	x_day = x[findlast(==(day), days)]
	return Date(year, month, x_day)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "d7cd76e304b32b583eb96a7ac19153dc0f2d1730"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"
"""

# ╔═╡ Cell order:
# ╠═88c31eda-cd74-11ef-2f33-6382e3607617
# ╠═d6b63fbe-57af-42c5-9328-282c093e4001
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
