module TaskHelpers
  module Production
    def log(task, level, message)
      Rails.logger.send(level, "#{task.name} : #{message}")
    end
  end
end
