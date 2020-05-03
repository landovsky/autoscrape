# typed: strict
# frozen_string_literal: true

User.create(full_name: 'Tomáš Landovský', email: 'tomas.landovsky@applifting.cz',
            auth0_user_id: 'google-oauth2|102988244414843511650', admin_user: true,
            phone_country_code: '+420', phone_number: '723456789')

SeedHelper.seed(:document) do |name|
  [
    ['doložení příjmů'],
    ['doložení bezdlužnosti']
  ]
end

SeedHelper.seed(:condition) do |name|
  [
    ['podání žádosti do 31.12.2019'],
    ['zkolaudovaná nemovitost']
  ]
end

SeedHelper.seed(:feature) do |name|
  [
    ['odložení splátek'],
    ['mimořádná splátka zdarma']
  ]
end

SeedHelper.seed(:fee) do |name|
  [
    ['vedení účtu'],
    ['odhad nemovitosti']
  ]
end

SeedHelper.seed(:filter) do |name, group|
  [
    ['jsem OSVČ', nil],
    ['chci družstevní byt', 1],
    ['mimořádná splátka zdarma', nil],
    ['elektronické výpisy', nil]
  ]
end

SeedHelper.seed(:postcode) do |code, municipality|
  [
    ['13000', 'Test City']
  ]
end

SeedHelper.seed(:purpose) do |name, code|
  [
    ['koupě nemovitosti', 'purchase'],
    ['refinancování', 'refinance'],
    ['bez účelu', 'other'],
    ['budoucí koupě', 'future_purchase']
  ]
end

SeedHelper.seed(:filter_purpose) do |filter_id, purpose_id|
  [
    [1, 1],
    [1, 2],
    [1, 3],
    [2, 1],
    [2, 2],
    [3, 1],
    [4, 4]
  ]
end
