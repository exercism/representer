module ColossalCoaster
  def self.add_to_queue(express_queue, normal_queue, express, person_name)
    case express
    when 0 then normal_queue
    when 1 then express_queue
    else raise ArgumentError.new
    end << person_name
  end

  def self.find_my_friend(queue, friend_name)
    queue.index(friend_name)
  end

  def self.add_with_friends(queue, friend_name, person_name)
    pos = find_my_friend(queue, friend_name) || raise ArgumentError.new
    queue.insert(pos, person_name)
  end

  def self.remove_from_queue(queue, person_name)
    queue.delete(person_name)
    queue
  end

  def self.sorted_queue(queue)
    queue.sort
  end
end
