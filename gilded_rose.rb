class GildedRose
  class InvalidInput < StandardError; end
  class InvalidItem < StandardError; end

  def initialize(items)
    raise InvalidInput unless items.is_a?(Array)
    raise InvalidItem unless items.all? { |item| item.instance_of?(Item) }

    @items = items # Do not modify.
  end

  def update_quality
    @items.each do |item|
      ItemTransformer.transform(item).update
    end
  end
end

module ItemTransformer
  def self.transform(item)
    name, conjured =
      if item.name.split[0] == 'Conjured'
        [item.name.split[1..].join(' '), true]
      else
        [item.name, false]
      end

    if name.start_with?('Aged')
      AgedItem.new(item, conjured:)
    elsif name.start_with?('Backstage passes')
      AdmissionItem.new(item, conjured:)
    elsif name.start_with?('Sulfuras')
      LegendaryItem.new(item, conjured:)
    else
      BaseItem.new(item, conjured:)
    end
  end
end

class BaseItem
  def initialize(item, conjured: false)
    @item = item
    @conjured = conjured
  end

  def update
    amount = @item.sell_in.positive? ? 1 : 2
    amount *= 2 if @conjured
    decrease_quality(amount)
    decrease_sell_in
  end

  private

  def decrease_sell_in
    @item.sell_in -= 1
  end

  def decrease_quality(amount = 1)
    @item.quality = [@item.quality - amount, 0].max
  end

  def increase_quality(amount = 1)
    @item.quality = [@item.quality + amount, 50].min
  end
end

class AgedItem < BaseItem
  def update
    increase_quality(@conjured ? 2 : 1)
    decrease_sell_in
    increase_quality(@conjured ? 2 : 1) if @item.sell_in.negative?
  end
end

class LegendaryItem < BaseItem
  class InvalidQuality < StandardError; end

  def initialize(item, conjured: false)
    raise InvalidQuality unless item.quality == 80

    super(item, conjured:)
  end

  def update
    # Quality and sell_in do not change, nothing to do here.
  end
end

class AdmissionItem < BaseItem
  def update
    amount =
      if @item.sell_in < 6
        3
      elsif @item.sell_in < 11
        2
      else
        1
      end

    amount *= 2 if @conjured
    increase_quality(amount)
    decrease_sell_in
    @item.quality = 0 if @item.sell_in.negative?
  end
end

# Do not modify this class.
class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
