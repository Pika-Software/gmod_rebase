module( "matproxy", package.seeall )

if (ProxyList == nil) then
	ProxyList = {}
end

if (ActiveList == nil) then
	ActiveList = {}
end

function ShouldOverrideProxy( name )
	return ProxyList[ name ] ~= nil
end

do

	local Msg = Msg
	local pairs = pairs

	function Add( tbl )
		if (tbl.name == nil) then return end
		if (tbl.bind == nil) then return end

		local name = tbl.name
		local bReloading = ProxyList[ name ] == nil

		ProxyList[ name ] = tbl

		--
		-- If we're reloading then reload all the active entries that use this proxy
		--
		if (bReloading) then return end
		for k, v in pairs( ActiveList ) do
			if ( name == v.name ) then
				Msg( "Reloading: ", v.Material, "\n" )
				Init( name, k, v.Material, v.Values )
			end
		end
	end

end

--
-- Called by the engine from OnBind
--
function Call( name, mat, ent )
	local proxy = ActiveList[ name ]
	if (proxy == nil) then return end
	if (proxy.bind == nil) then return end
	proxy:bind( mat, ent )
end

--
-- Called by the engine from OnBind
--
function Init( name, uname, mat, values )
	local proxy = ProxyList[ name ]
	if (proxy == nil) then return end

	local new_proxy = table.Copy( proxy )
	ActiveList[ uname ] = new_proxy

	if (new_proxy.init == nil) then return end

	new_proxy:init( mat, values )

	-- Store these incase we reload
	new_proxy.Values = values
	new_proxy.Material = mat
end