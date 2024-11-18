# frozen_string_literal: true

require "airrecord"
require "aasm"

module AASM
  module Persistence
    # mix this in to taste
    module AirrecordPersistence
      def self.included(base)
        base.extend AASM::Persistence::Base::ClassMethods
        base.extend ClassMethods

        base.class_eval do
          attr_accessor :_transition_changes
        end
      end

      def aasm_read_state(name = :default)
        state = self[self.class.aasm(name).attribute_name.to_s]
        state&.to_sym
      end

      def aasm_write_state_without_persistence(state, name = :default)
        self[self.class.aasm(name).attribute_name.to_s] = state.to_s
      end

      def aasm_fire_event(state_machine_name, name, options, *args, &block)
        return super unless options[:persist]

        transaction do
          super
        end
      end
    end
  end
end

# inherit from this as you would Airrecord::Table
class AirctsAsStateMachine < Airrecord::Table
  include AASM
  include AASM::Persistence::AirrecordPersistence
end
