admin = User.create!( email: 'vvintpann@gmail.com',
              name: 'admin',
              password: 'asdfasdf',
              password_confirmation: 'asdfasdf',
              admin: true )

taras = User.create!( email: 'taras@gmail.com',
              name: 'taras',
              password: 'asdfasdf',
              password_confirmation: 'asdfasdf' )

taras.products.create!( name: 'orange',
                        price_in: 70,
                        price_out: 130 )

taras.products.create!( name: 'apple',
                        price_in: 60,
                        price_out: 140 )

taras.products.create!( name: 'strawberry',
                        price_in: 90,
                        price_out: 160 )

taras.products.create!( name: 'bread',
                        price_in: 20,
                        price_out: 50 )

taras.products.create!( name: 'peanut',
                        price_in: 60,
                        price_out: 86,
                        active: false )

taras.products.create!( name: 'sunflower',
                        price_in: 160,
                        price_out: 210,
                        active: false )
