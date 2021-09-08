# frozen_string_literal: true

module Fet
  # This class defines a queue that processes items one at a time and lets you know if there are still items processing/to be processed
  class ProcessingQueue
    attr_reader :processing_item

    def initialize
      self.queue = Queue.new
      self.mutex = Mutex.new
      self.condition_variable = ConditionVariable.new
      self.processing_item = nil
    end

    def push(item)
      queue.push(item)
      condition_variable.broadcast
    end

    def set_processing_item
      mutex.synchronize do
        condition_variable.wait(mutex) until processing_item.nil? && !queue.empty?
        self.processing_item = queue.pop
      end
    end

    def reset_processing_item
      mutex.synchronize do
        self.processing_item = nil
        condition_variable.broadcast
      end
    end

    def wait_until_all_items_processed
      mutex.synchronize do
        condition_variable.wait(mutex) while items_processing_unsafe?
      end
    end

    private

    attr_accessor :queue, :mutex, :condition_variable
    attr_writer :processing_item

    # WARNING: should be checked inside the mutex
    def items_processing_unsafe?
      return !queue.empty? || !processing_item.nil?
    end
  end
end
