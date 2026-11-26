namespace hellmath {

enum class AccountStatus {
    troll,
    guest,
    user,
    mod,
};

enum class Action {
    read,
    write,
    remove,
};

bool display_post(const AccountStatus& poster, const AccountStatus& viewer) {
    return poster == AccountStatus::troll ? viewer == AccountStatus::troll : true;
}

bool permission_check(const Action& action, const AccountStatus& status) {
    switch (status) {
    case AccountStatus::guest:
        return action == Action::read;
    case AccountStatus::troll:
    case AccountStatus::user:
        return action == Action::read || action == Action::write;
    case AccountStatus::mod:
            return true;
    }

    return false;
}

bool valid_player_combination(const AccountStatus& player1, const AccountStatus& player2) {
    if (player1 == AccountStatus::guest || player2 == AccountStatus::guest) {
        return false;
    }

    return player1 == AccountStatus::troll && player2 == AccountStatus::troll ?
           player1 == AccountStatus::troll && player2 == AccountStatus::troll :
           true;
}

bool has_priority(const AccountStatus& first, const AccountStatus& second) {
    return first > second;
}

} // namespace hellmath
