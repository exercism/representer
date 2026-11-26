public class GameMaster {

    public String describe(Character character) {
        return String.format("You're a level %s %s with %s hit points.", character.getLevel(),
                character.getCharacterClass(), character.getHitPoints());
    }

    public String describe(Destination destination) {
        return String.format("You've arrived at %s, which has %s inhabitants.", destination.getName(),
                destination.getInhabitants());
    }

    public String describe(TravelMethod travelMethod) {
        if (travelMethod == TravelMethod.HORSEBACK)
            return "You're traveling to your destination on horseback.";
        return "You're traveling to your destination by walking.";
    }

    public String describe(Character character, Destination destination, TravelMethod travelMethod) {
        return String.format("%s %s %s", describe(character), describe(travelMethod), describe(destination));
    }

    public String describe(Character character, Destination destination) {
        return describe(character, destination, TravelMethod.WALKING);
    }
}
