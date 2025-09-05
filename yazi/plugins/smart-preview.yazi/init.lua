-- Smart preview plugin for non-blocking image loading
-- Prevents main thread blocking on large files

local M = {}

function M:setup()
	ps.sub("preview", function(file)
		-- Skip preview for very large images
		local size = ya.fs_stat(file.url)
		if size and size.size > 50 * 1024 * 1024 then  -- 50MB
			ya.preview_skip("File too large for preview")
			return
		end
		
		-- Continue with normal preview
		ya.preview_default(file)
	end)
end

return M