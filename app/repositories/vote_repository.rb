class VoteRepository < BaseRepository
  def vote_up(attributes)
    record.assign_attributes(attributes)
    
    return [true, 'Voted successful'] if record.save

    default_record_error
  end

  def vote_down
    return [true, 'Unvoted successful'] if record.destroy

    default_record_error
  end
end