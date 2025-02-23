require 'data-anonymization'

database 'central_development' do
  strategy DataAnon::Strategy::Blacklist

  source_db({
    "username"=>"tylerrhodes",
    "adapter"=>"postgresql",
    "encoding"=>"unicode",
    "pool"=>5,
    "database"=>"central_development"
  })

  table 'profiles' do
    primary_key('id')
    anonymize('first_name').using FieldStrategy::RandomFirstName.new
    anonymize('last_name').using FieldStrategy::RandomLastName.new
    # anonymize('email').using FieldStrategy::StringTemplate.new('example_#{row_number}@gmail.com')
  end
end

