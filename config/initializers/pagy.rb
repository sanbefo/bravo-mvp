require 'pagy/extras/headers'
require 'pagy/extras/overflow'
require 'pagy/extras/metadata'

Pagy::DEFAULT[:items]    = 20
Pagy::DEFAULT[:overflow] = :last_page
