#include "robot_simulator.h"

robot_status_t robot_create(robot_direction_t direction, int x, int y)
{
    robot_status_t *robot = (robot_status_t *)malloc(sizeof(robot_status_t));
    robot->direction = direction;
    robot->position.x = x;
    robot->position.y = y;
    return *robot;
}

void robot_move(robot_status_t *robot, const char *commands)
{
    if (commands == NULL || strlen(commands) == 0)
        return;
    
    if (robot == NULL)
        return;
    
    for (size_t i=0; i<strlen(commands); i++)
    {
        if (commands[i] == 'A')
        {
            switch(robot->direction)
            {
                case DIRECTION_NORTH :
                    robot->position.y++;
                    break;
                case DIRECTION_EAST :
                    robot->position.x++;
                    break;
                case DIRECTION_SOUTH : 
                    robot->position.y--;
                    break;
                case DIRECTION_WEST:
                    robot->position.x--;
                    break;
                default:
                    break;
            }
        }
        if (commands[i] == 'R')
        {
            switch(robot->direction)
            {
                case DIRECTION_NORTH :
                    robot->direction = DIRECTION_EAST;
                    break;
                case DIRECTION_EAST :
                    robot->direction = DIRECTION_SOUTH;
                    break;
                case DIRECTION_SOUTH : 
                    robot->direction = DIRECTION_WEST;
                    break;
                case DIRECTION_WEST:
                    robot->direction = DIRECTION_NORTH;
                    break;
                default:
                    break;
            }
        }
        if(commands[i] == 'L')
        {
            switch(robot->direction)
            {
                case DIRECTION_NORTH :
                    robot->direction = DIRECTION_WEST;
                    break;
                case DIRECTION_EAST :
                    robot->direction = DIRECTION_NORTH;
                    break;
                case DIRECTION_SOUTH : 
                    robot->direction = DIRECTION_EAST;
                    break;
                case DIRECTION_WEST:
                    robot->direction = DIRECTION_SOUTH;
                    break;
                default:
                    break;
            }
        }
    }
}