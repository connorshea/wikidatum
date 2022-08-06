# frozen_string_literal: true
require 'wikidatum/snak'

# Wikidatum::Qualifier is actually just an alias for snak, because qualifiers
# are effectively just snaks.
Wikidatum::Qualifier = Wikidatum::Snak
