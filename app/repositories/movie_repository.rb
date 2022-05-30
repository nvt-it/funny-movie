class MovieRepository < BaseRepository
  def create(params)
    video = VideoInfo.new(params[:url])

    record.assign_attributes({
      title: video&.title,
      description: video&.description,
      thumb_url: video&.thumbnail_medium,
      video_id: video&.video_id
    })

    return [true, 'Share movie successful'] if record.save
    
    default_record_error

  rescue StandardError => e
    [false, 'Shared movie failed']
  end
end