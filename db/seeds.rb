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
