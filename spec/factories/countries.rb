# frozen_string_literal: true

FactoryBot.define do
  factory :country do
    name_common { 'Switzerland' }
    name_official { 'Swiss Confederation' }
    cca2 { 'CH' }
    ccn3 { '756' }
    cca3 { 'CHE' }
    cioc { 'SUI' }
    capital { 'Bern' }
    region { 'Europe' }
    subregion { 'Western Europe' }
    landlocked { true }
    area { 41_284 }
    latitude { 47 }
    longitude { 8 }
    un_member { true }
    independent { true }
  end

  trait :african do
    name_common { 'Madagascar' }
    name_official { 'Republic of Madagascar' }
    cca2 { 'MG' }
    ccn3 { '450' }
    cca3 { 'MDG' }
    cioc { 'MAD' }
    capital { 'Antananarivo' }
    region { 'Africa' }
    subregion { 'Eastern Africa' }
    landlocked { false }
    area { 587_041 }
    latitude { -20 }
    longitude { 47 }
    un_member { false }
    independent { true }
  end

  trait :antarctican do
    name_common { 'Antarctica' }
    name_official { 'Antarctica' }
    cca2 { 'AQ' }
    ccn3 { '101' }
    cca3 { 'ATA' }
    cioc { '' }
    capital { '' }
    region { 'Antarctic' }
    subregion { 'Antarctic' }
    landlocked { false }
    area { 14_000_000 }
    latitude { -90 }
    longitude { 0 }
    un_member { false }
    independent { false }
  end

  trait :asian do
    name_common { 'China' }
    name_official { "People's Republic of China" }
    cca2 { 'CN' }
    ccn3 { '156' }
    cca3 { 'CHN' }
    cioc { 'CHN' }
    capital { 'Beijing' }
    region { 'Asia' }
    subregion { 'Eastern Asia' }
    landlocked { false }
    area { 9_706_960 }
    latitude { 35 }
    longitude { 105 }
  end

  trait :oceanian do
    name_common { 'Australia' }
    name_official { 'Commonwealth of Australia' }
    cca2 { 'AU' }
    ccn3 { '036' }
    cca3 { 'AUS' }
    cioc { 'AUS' }
    capital { 'Canberra' }
    region { 'Oceania' }
    subregion { 'Australia and New Zealand' }
    landlocked { false }
    area { 7_692_020 }
    latitude { -27 }
    longitude { 133 }
  end

  trait :north_american do
    name_common { 'Canada' }
    name_official { 'Canada' }
    cca2 { 'CA' }
    ccn3 { '124' }
    cca3 { 'CAN' }
    cioc { 'CAN' }
    capital { 'Ottawa' }
    region { 'Americas' }
    subregion { 'North America' }
    landlocked { false }
    area { 9_984_670 }
    latitude { 60 }
    longitude { -95 }
  end

  trait :central_american do
    name_common { 'Mexico' }
    name_official { 'Mexico' }
    cca2 { 'MX' }
    ccn3 { '484' }
    cca3 { 'MEX' }
    cioc { 'MEX' }
    capital { 'Mexico City' }
    region { 'Americas' }
    subregion { 'Central America' }
    landlocked { false }
    area { 1_964_380 }
    latitude { 23 }
    longitude { -102 }
  end

  trait :caribbean do
    name_common { 'Cuba' }
    name_official { 'Republic of Cuba' }
    cca2 { 'CU' }
    ccn3 { '192' }
    cca3 { 'CUB' }
    cioc { 'CUB' }
    capital { 'Havana' }
    region { 'Americas' }
    subregion { 'Caribbean' }
    landlocked { false }
    area { 109_884 }
    latitude { 21 }
    longitude { -80 }
  end

  trait :south_american do
    name_common { 'Peru' }
    name_official { 'Republic of Peru' }
    cca2 { 'PE' }
    ccn3 { '604' }
    cca3 { 'PER' }
    cioc { 'PER' }
    capital { 'Lima' }
    region { 'Americas' }
    subregion { 'South America' }
    landlocked { false }
    area { 1_285_220 }
    latitude { -10 }
    longitude { -76 }
  end
end
