#!/bin/bash
# Define the domain of your defaults.
domain="com.siacgltiyg.SiaData\\MFTimes"
# Write new values
echo "Writing new values to $domain..."
defaults write "$domain" simplepoint "Az+foJSad0P/kFw1nTAWPA==" || echo "Failed to write simplepoint"
defaults write "$domain" position "Az+foJSad0P/kFw1nTAWPA==" || echo "Failed to write position"
defaults write "$domain" manypoint "Az+foJSad0P/kFw1nTAWPA==" || echo "Failed to write manypoint"
# Delete a key
echo "Deleting JoystickMovementTrialTime from $domain..."
defaults delete "$domain" JoystickMovementTrialTime || echo "Failed to delete JoystickMovementTrialTime"
# Add an echo statement at the end to confirm completion
echo "Script completed."
