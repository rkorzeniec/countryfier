# frozen_string_literal: true

class DeferredGarbageCollection
  DEFERRED_GC_THRESHOLD = ENV.fetch('DEFER_GC', 25.0).to_f

  @@last_gc_run = Time.zone.now

  def self.start
    GC.disable if DEFERRED_GC_THRESHOLD > 0
  end

  def self.reconsider
    if DEFERRED_GC_THRESHOLD > 0 && Time.zone.now - @@last_gc_run >= DEFERRED_GC_THRESHOLD
      GC.enable
      GC.start
      GC.disable
      @@last_gc_run = Time.zone.now
    end
  end
end
