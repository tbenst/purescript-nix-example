module Example.Main where

import Prelude

import Effect (Effect)
import Example.Button as Button
import Halogen (liftEffect)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Effect.Console (log)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  liftEffect $ log "in halogen"
  runUI Button.component unit body