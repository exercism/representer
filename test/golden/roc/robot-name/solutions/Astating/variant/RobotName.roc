import random.Random

RobotName :: {}.{
	Factory :: {
		seed: Random.State,
        robot_names : Set(Str)
	}.{
		create : { seed : U32 } -> Factory
		create = |{ seed }|
			{ seed: Random.seed(seed), robot_names : Set.empty() }

		build_robot : Factory -> Robot
		build_robot = |factory|
			{ name: NoName, factory }
	}

	Robot :: {
		name : [Name(Str), NoName],
        factory : Factory
	}.{
		boot : Robot -> Robot
		boot = |robot| match robot.name {
            Name(_) => robot
            NoName => {
                { value: { letters, numbers }, state } = Random.step(robot.factory.seed,
                    {
                        letters: Random.list(Random.bounded_u8('A', 'Z'), 2),
                        numbers: Random.list(
                            Random.bounded_u8(0, 9)|> Random.map(|n| n + '0'),
                            4
                        )
                    }.Random
                )
    
                name = letters.concat(numbers) |> Str.from_utf8_lossy()
    
                match robot.factory.robot_names.contains(name) {
                    True => boot({..robot, factory: {..robot.factory, seed: state}})
                    False => {
                        name: Name(name),
                        factory: {
                            seed: state,
                            robot_names: robot.factory.robot_names.insert(name)
                        }
                    }
                }
            }
        }

		factory_reset : Robot -> Robot
		factory_reset = |robot| match robot.name {
            NoName => robot
            Name(name) =>
                {
			        name: NoName,
                    factory: {
                        ..robot.factory,
                        robot_names: robot.factory.robot_names.remove(name)
                    }
		        }    
        }  

		get_name : Robot -> [Name(Str), NoName]
		get_name = |robot| robot.name
		
		get_factory : Robot -> Factory
		get_factory = |robot| robot.factory
	}
}
