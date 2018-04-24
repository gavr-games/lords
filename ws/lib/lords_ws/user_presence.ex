defmodule LordsWs.UserPresence do  
  use Phoenix.Presence, otp_app: :lords_ws,
                        pubsub_server: LordsWs.PubSub
end 