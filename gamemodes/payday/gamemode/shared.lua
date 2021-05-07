-- -------------------------------------------------
-- Other thanks for Delta, [FG] Shark_vil, Jaff.
-- -------------------------------------------------

GM.Name = 'PAYDAY 2'
GM.Author = 'HarionPlayZ & Soloveu Empty'

pd2_helpers = pd2_helpers or {}

--* Is called simultaneously on both the client and the server.
--? Recommended only for generic elements

-- Initializing helpers
include('helpers/sh_player_helper.lua')

-- Initializing working code
include('shared/bleedout_init.lua')
include('shared/pd2_sound.lua')