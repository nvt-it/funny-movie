class BaseRepository
  def initialize(record = nil)
    @record = record
  end

  protected

  attr_reader :record

  def default_record_error
    [false, record&.errors.try(:full_messages).try(:first)]
  end
end