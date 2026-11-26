Item = Struct.new(:name, :sell_in, :quality)

class GildedRose
  LEGENDARY_ITEMS = ["Sulfuras, Hand of Ragnaros"].freeze
  OLDER_IS_BETTER_ITEMS = [
    "Aged Brie",
    "Backstage passes to a TAFKAL80ETC concert",
    "Conjured Aged Brie"
  ].freeze

  def initialize(items)
    @items = items
  end

  def update!
    @items.each do |item|
      update_quality(item)

      item.quality = 0 if item.quality < 0
      item.sell_in -= 1 unless legendary?(item)

      check_expired_date(item)
    end
  end

  private

  def update_quality(item)
    return if item.quality >= 50 || item.quality < 0

    if older_is_better?(item)
      item.quality += 1
      increase_quality_if_backstage(item)
    elsif not backstage?(item)
      item.quality -= 1 unless legendary?(item)
      item.quality -= 1 if conjured?(item)
    else
      increase_quality_if_backstage(item)
    end
  end

  def check_expired_date(item)
    return unless item.sell_in < 0

    if item.name == "Aged Brie"
      item.quality = [item.quality + 1, 50].min
    elsif backstage?(item) || conjured?(item)
      item.quality = 0
    elsif not legendary?(item)
      item.quality = [item.quality - 1, 0].max
    end
  end

  def increase_quality_if_backstage(item)
    return unless backstage?(item) && item.quality < 50

    item.quality += 1 if item.sell_in < 6
    item.quality += 1 if item.sell_in < 11 && item.quality < 50
  end

  def conjured?(item)
    item.name.start_with?("Conjured")
  end

  def backstage?(item)
    item.name.start_with?("Backstage") ||
      item.name.start_with?("Conjured backstage")
  end

  def legendary?(item)
    LEGENDARY_ITEMS.include?(item.name)
  end

  def older_is_better?(item)
    OLDER_IS_BETTER_ITEMS.include?(item.name)
  end
end