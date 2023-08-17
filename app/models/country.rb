class Country < ApplicationRecord

  def self.country_by_name(name)
    Country.where("data -> 'name' ->> 'common' = ?", "#{name}").last
  end

  def self.sorted_list_by_for_int(search, order)
    list = Country.select("data->'name'->>'common' as country_name").order(Arel.sql("(data->'#{search}')::integer #{order} NULLS LAST"))
    list.map {|data| data.country_name}
  end

  def self.sorted_list_by_for_text(search, order)
    list = Country.select("data->'name'->>'common' as country_name").order(Arel.sql("(data->'#{search}')::text #{order} NULLS LAST"))
    list.map {|data| data.country_name}
  end
end
