class FakeData < ApplicationRecord
  def self.generate
    columns = ["timestamp", "title", "temperature", "pressure", "dimensionx", "dimensiony", "weight"]
    titles  = %w(red blue green orange yellow magenta purple black white brown pink)

    100.times do
      items = []
      10000.times do
        item = [
          rand(10.days.ago..Time.now),
          titles.sample + '-' + rand(10000).to_s,
          rand(44..88),
          rand(588..1220),
          rand(588..1220),
          rand(588..1220),
          rand(800..1500),
        ]
        items << item
      end

      transaction do
        FakeData.import columns, items, validate: false
      end
    end
  end
end


# select
#   title,
#   temperature,
#   case
#     when temperature <= 48 then 'green'
#     when temperature > 48 AND temperature <= 58 then 'orange'
#     when temperature > 58 AND temperature < 68 then 'red'
#   else 'boiling'
#   end "temperature style",
#   pressure,
#   case
#     when pressure <= 650 then 'green'
#     when pressure > 650 AND pressure <= 780 then 'orange'
#     when pressure > 780 AND pressure < 990 then 'red'
#   else 'exploding'
#   end "pressure style",
#   dimensionx,
#   case
#     when dimensionx <= 650 then 'tiny'
#     when dimensionx > 650 AND dimensionx <= 780 then 'small'
#     when dimensionx > 780 AND dimensionx < 990 then 'big'
#   else 'massive'
#   end "dimensionx style",
#   dimensiony,
#   case
#     when dimensiony <= 650 then 'tiny'
#     when dimensiony > 650 AND dimensiony <= 780 then 'small'
#     when dimensiony > 780 AND dimensiony < 990 then 'big'
#   else 'massive'
#   end "dimensiony style",
#   weight,
#   case
#     when weight <= 900 then 'tiny'
#     when weight > 900 AND weight <= 1005 then 'small'
#     when weight > 1005 AND weight < 1300 then 'big'
#   else 'unbearable'
#   end "weight style"
# from fake_data limit 100000

# select
#   title,
#   temperature,
#   pressure,
#   dimensionx,
#   dimensiony,
#   weight
# from fake_data limit 100000

# select * from fake_data limit 10