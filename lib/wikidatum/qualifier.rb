# frozen_string_literal: true

require 'wikidatum/snak'

# TODO: Turn this into its own thing, separate from Snaks.

# Wikidatum::Qualifier is actually just an alias for snak, because qualifiers
# are effectively just snaks.
Wikidatum::Qualifier = Wikidatum::Snak
