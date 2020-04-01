admin = User.create!( email: 'vvintpann@gmail.com',
              name: 'admin',
              password: 'asdfasdf',
              password_confirmation: 'asdfasdf',
              admin: true )

taras = User.create!( email: 'taras@gmail.com',
              name: 'taras',
              password: 'asdfasdf',
              password_confirmation: 'asdfasdf' )

orange=taras.products.create!( name: 'orange',
                        price_in: 70,
                        price_out: 130 )

apple=taras.products.create!( name: 'apple',
                        price_in: 60,
                        price_out: 140 )

strawberry=taras.products.create!( name: 'strawberry',
                        price_in: 90,
                        price_out: 160 )

bread=taras.products.create!( name: 'bread',
                        price_in: 20,
                        price_out: 50 )

corn=taras.products.create!( name: 'corn',
                        price_in: 200,
                        price_out: 340 )

peanut=taras.products.create!( name: 'peanut',
                        price_in: 60,
                        price_out: 86 )

sunflower=taras.products.create!( name: 'sunflower',
                        price_in: 160,
                        price_out: 210 )

misha=taras.employees.create!(name: 'Misha',
                        fixed_rate: 500,
                        interest_rate: 10 )

dima=taras.employees.create!(name: 'Dima',
                        fixed_rate: 800,
                        interest_rate: 2 )

lera=taras.employees.create!(name: 'Lera',
                        fixed_rate: 600,
                        interest_rate: 8 )

sasha=taras.employees.create!(name: 'Sasha',
                        fixed_rate: 500,
                        interest_rate: 15 )

maxim=taras.employees.create!(name: 'Maxim',
                        fixed_rate: 400,
                        interest_rate: 18,
                        active: false )

danil=taras.employees.create!(name: 'Danil',
                        fixed_rate: 300,
                        interest_rate: 26,
                        active: false )

first_event=taras.all_events.create(event_type: 'shopping')
first_event.update_attribute(:created_at, '2020-03-28 22:38:39')

first_event.shopping_events.create_event(product: orange,
                                        amount: 50 )

first_event.shopping_events.create_event(product: bread,
                                        amount: 180 )

first_event.shopping_events.create_event(product: sunflower,
                                        amount: 70 )

second_event=taras.all_events.create(event_type: 'throwing')
second_event.update_attribute(:created_at, '2020-03-28 22:38:39')

second_event.throwing_events.create_event(product: orange,
                                        amount: 20 )

second_event.throwing_events.create_event(product: bread,
                                        amount: 10 )

third_event=taras.all_events.create(event_type: 'start_work_session')
third_event.update_attribute(:created_at, '2020-03-29 22:38:39')

third_event.create_start_work_session_event(employee: misha)

fourth_event=taras.all_events.create(event_type: 'giving')
fourth_event.update_attribute(:created_at, '2020-03-29 22:38:39')

fourth_event.giving_events.create_event(product: orange, amount: 4, employee: misha)

fourth_event.giving_events.create_event(product: bread, amount: 9, employee: misha)
