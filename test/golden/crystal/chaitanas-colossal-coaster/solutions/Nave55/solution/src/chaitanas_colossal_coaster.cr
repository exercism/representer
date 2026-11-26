module ColossalCoaster
  def self.add_to_queue(express_queue, normal_queue, express, person_name)
    queue = express == 0 ? normal_queue : express_queue
    queue << person_name
    queue
  end

  def self.find_my_friend(queue, friend_name)
    queue.index(friend_name)
  end

  def self.add_with_friends(queue, friend_name, person_name)
    index = find_my_friend(queue, friend_name)
    queue.insert(index, person_name) if !index.nil?
    queue
  end

  def self.remove_from_queue(queue, person_name)
    queue.delete(person_name)
    queue
  end

  def self.sorted_queue(queue)
    queue.sort
  end
end
