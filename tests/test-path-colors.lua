-- Test script to check path segment color distribution
local test_paths = {
  "apps/user-app/components/TaskList.tsx",
  "apps/pmp/components/TaskList.tsx",
  "apps/admin/components/Dashboard.tsx",
  "packages/ui/components/Button.tsx",
  "packages/shared/utils/helpers.ts",
  "packages/auth/services/login.ts",
}

-- Extract segments
local segments = {}
for _, path in ipairs(test_paths) do
  local app = path:match("apps/([^/]+)")
  local pkg = path:match("packages/([^/]+)")
  local segment = app or pkg
  if segment and not vim.tbl_contains(segments, segment) then
    table.insert(segments, segment)
  end
end

-- Calculate hashes and colors
print("Testing path segment color distribution:")
print(string.rep("-", 50))

for _, segment in ipairs(segments) do
  -- New position-weighted hash
  local hash = 0
  for i = 1, #segment do
    local byte = segment:byte(i)
    hash = hash + (byte * (i * 37)) + (byte * byte * 17)
  end
  hash = hash + (#segment * 13)

  local colors = {
    "DiagnosticError",
    "DiagnosticWarn",
    "DiagnosticInfo",
    "DiagnosticHint",
    "DiagnosticOk",
    "@function",
    "@keyword",
    "@type",
    "@string",
    "@constant",
    "Special",
    "Title",
    "Comment",
  }
  local num_colors = #colors
  local color_idx = (hash % num_colors) + 1

  print(string.format("%-15s -> Hash: %10d -> Color[%2d]: %s",
    segment, hash, color_idx, colors[color_idx]))
end

print(string.rep("-", 50))
print("\nIf multiple segments have the same color index, they'll look the same!")