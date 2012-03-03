
module Pomo
  class Task
    
    #--
    # Mixins
    #++
    
    include Growl
    
    ##
    # Task name.
    
    attr_accessor :id
    
    ##
    # Task name.
    
    attr_accessor :name
    
    ##
    # Length in minutes.
    
    attr_accessor :length
    
    ##
    # Verbose task description.
    
    attr_accessor :description
    
    ##
    # Task completion bool.
    
    attr_accessor :complete
    
    ##
    # Task completion time.
    
    attr_accessor :completed_at
    
    ##
    # Initialize with _name_ and _options_.
    
    def initialize name = nil, options = {}
      @id = self.object_id
      @name = name or raise '<task> required'
      @description = options.delete :description
      @tags = options.delete :tags
      @length = options.fetch :length, 25
      @complete = false
      @completed_at = false
    end
    
    ##
    # Quoted task name.
    
    def to_s
      name.inspect
    end
    
    ##
    # Check if the task has been completed.
    
    def complete?
      complete
    end

    ##
    # Mark a task as completed.
    
    def mark_complete
      @complete = true
      @completed_at = Time.now
    end
    
    ##
    # Start timing the task.
    
    def start
      complete_message = "time is up! hope you are finished #{self}"
      format_message = "(:progress_bar) :remaining minutes remaining"
      progress (0..length).to_a.reverse, :format => format_message, :tokens => { :remaining => length }, :complete_message => complete_message do |remaining|
        if remaining == length / 2
          notify_info "#{remaining} minutes remaining, half way there!"
        elsif remaining == 5
          notify_info "5 minutes remaining"
        end
        sleep 60
        { :remaining => remaining }
      end
      mark_complete
      notify_warning complete_message
    end
    
  end
end