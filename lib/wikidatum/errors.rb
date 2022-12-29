# frozen_string_literal: true

require 'wikidatum/error'

module Wikidatum::Errors
  # If the Wikidatum::Client is set to disallow IP Edits (the default) and no
  # authentication has been provided, this error will be raised when performing
  # any non-GET requests.
  class DisallowedIpEditError < Wikidatum::Error
    def message
      'No authentication provided. If you want to perform unauthenticated edits and are comfortable exposing your IP address publicly, set `allow_ip_edits: true` when instantiating your client with `Wikidatum::Client.new`.'
    end
  end

  # If the Wikidatum::Client is set to mark their edits as belonging to a bot,
  # they must be authenticated as a bot user. We will disallow these edits
  # as long as they're not authenticated as a specific user.
  class DisallowedBotEditError < Wikidatum::Error
    def message
      'No authentication provided, but attempted to edit as a bot. You cannot make edits as a bot unless you have authenticated as a user with the Bot flag.'
    end
  end
end
