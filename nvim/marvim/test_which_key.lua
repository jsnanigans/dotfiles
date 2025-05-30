-- Test file to verify which-key configuration
local wk = require("which-key")

-- Test configuration
print("Which-key configuration test:")
print("✓ Which-key loaded successfully")

-- Test that deprecated options are gone
local config = wk.opts or {}
if config.popup_mappings then
  print("✗ Still using deprecated popup_mappings")
else
  print("✓ No deprecated popup_mappings found")
end

if config.window then
  print("✗ Still using deprecated window option")
else
  print("✓ No deprecated window option found")
end

-- Test that new options are present
if config.keys then
  print("✓ New keys option is configured")
else
  print("✗ Missing new keys option")
end

if config.win then
  print("✓ New win option is configured")
else
  print("✗ Missing new win option")
end

print("Configuration test complete!") 