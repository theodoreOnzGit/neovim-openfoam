-- test print
-- print("hello from ccls")

-- first i get the openfoam directory
-- and check if it's set
local openfoam_dir = vim.fn.expand('$WM_PROJECT_DIR')
local openfoam_env_set = false

-- this part checks if the openfoam evnironment variable 
-- has been set
if openfoam_dir == '$WM_PROJECT_DIR' then
	openfoam_env_set = false
else
	openfoam_env_set = true
end
-- define important functions first
local function cacheDirName()
	-- note, the .. Concatenates strings
	local cache_dir = vim.fn.expand('$WM_PROJECT_DIR') .. '/build/' .. vim.fn.expand('$WM_OPTIONS')
	.. '/ccls-cache'
	print("cache dir: ", cache_dir)
	return cache_dir;
end

local function compilationDatabaseDirectory()
	local compile_dir = vim.fn.expand('$WM_PROJECT_DIR') .. '/build/' .. vim.fn.expand('$WM_OPTIONS')
	print("compile dir: ", compile_dir)
	return compile_dir;
end

if openfoam_env_set then
	print("openfoam environment set, setting up ccls openfoam server")
	local cache_dir_name = cacheDirName()
	local compile_dir_name = compilationDatabaseDirectory()
	require("ccls").setup {
		lsp = {
			-- check :help vim.lsp.start for config options
			server = {
				name = "ccls", --String name
				cmd = {"/usr/bin/ccls"}, -- point to your binary, has to be a table
				args = {--[[Any args table]] },
				offset_encoding = "utf-32", -- default value set by plugin
				root_dir = vim.fs.dirname(vim.fs.find({ "compile_commands.json", ".git" }, { upward = true })[1]), -- or some other function that returns a string
				--on_attach = your_func,
				--capabilites = your_table/func
			},
		},
	}
else
	error("openfoam environment not set, please source your openfoam etc/bashrc file")
end

