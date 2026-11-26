module TicketPlease exposing (..)

import TicketPleaseSupport exposing (Status(..), Ticket(..), User(..))


emptyComment : ( User, String ) -> Bool
emptyComment (_, comment) =
    comment == ""

numberOfCreatorComments : Ticket -> Int
numberOfCreatorComments (Ticket {comments, createdBy}) =
    let
        (user, _) = createdBy
    in
    List.filter (\(commentCreator, _) -> commentCreator == user) comments
    |> List.length


assignedToDevTeam : Ticket -> Bool
assignedToDevTeam (Ticket {assignedTo}) =
    case assignedTo of
        Just (User "Alice") -> True
        Just (User "Bob") -> True
        Just (User "Charlie") -> True
        _ -> False

assignTicketTo : User -> Ticket -> Ticket
assignTicketTo user (Ticket ({status} as ticket)) =
    case status of
        New -> Ticket {ticket | assignedTo = Just user, status = InProgress}
        Archived -> Ticket ticket
        _ -> Ticket {ticket | assignedTo = Just user}
