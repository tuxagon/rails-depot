class ShipOrderJob < ApplicationJob
  queue_as :default

  def perform(order)
    order.ship!
  end
end
