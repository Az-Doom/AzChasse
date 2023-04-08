ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Item = {
    ArmeBlanche = {
    {Label = "Couteau", Name = "knife", Price = 5},
    },

    ArmeFeu = {
    {Label = "Mousquet", Name = "musket", Price = 15000},
    {Label = "Munition de Mousquet", Name = "shotgun_ammo", Price = 5},
    },

    
}

ppa = false

function OpenShopChasse()
  local Chasse = RageUI.CreateMenu("Hunt Shop", "Voici nos produits")
  local ShopBlanche = RageUI.CreateSubMenu(Chasse, "Hunt Shop", "Arme Blanche")
  local ShopFeu = RageUI.CreateSubMenu(Chasse, "Hunt Shop", "Arme à feu")
  local ShopNul = RageUI.CreateSubMenu(Chasse, "Hunt Shop", "Veuillez voir la LSPD")
  Chasse:SetRectangleBanner(0,0, 0)
  ShopBlanche:SetRectangleBanner(0,0, 0)
  ShopFeu:SetRectangleBanner(0,0, 0)
  ShopNul:SetRectangleBanner(0,0, 0)


  RageUI.Visible(Chasse, not RageUI.Visible(Chasse))
  
  CreateThread(function()
	while true do
		Wait(500)
        ESX.TriggerServerCallback('e_weaponshop:checkLicense', function(cb)
            if cb then
                ppa = true
                else
                 ppa = false
            end
          end)
          Wait(500)
        end
    end)
    


  
  while Chasse do
      Citizen.Wait(0)
      RageUI.IsVisible(Chasse, true, true, true, function()

        if ppa then
            RageUI.ButtonWithStyle("Arme Blanche", nil,  {}, true, function(Hovered, Active, Selected)
            end, ShopBlanche)

            RageUI.ButtonWithStyle("Arme à feu", nil,  {}, true, function(Hovered, Active, Selected)
            end, ShopFeu)
        else
            RageUI.ButtonWithStyle("Armes à feu", "Pour accéder aux armes à feu veuillez passer votre permis de chasse avec la LSPD.", { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)
                if (Selected) then
                end
            end)
        end    

    end)

    RageUI.IsVisible(ShopBlanche, true, true, true, function()
        for k,v in pairs(Item.ArmeBlanche) do
            RageUI.ButtonWithStyle(v.Label, nil, {RightLabel = "~g~"..(v.Price).."$"}, true, function(Hovered, Active, Selected)
              if (Selected) then
                  TriggerServerEvent('doom:shop', v.Name, v.Price)
                end
            end)
        end
    end)

    RageUI.IsVisible(ShopFeu, true, true, true, function()
        for k,v in pairs(Item.ArmeFeu) do
            RageUI.ButtonWithStyle(v.Label, nil, {RightLabel = "~g~"..(v.Price).."$"}, true, function(Hovered, Active, Selected)
              if (Selected) then
                  TriggerServerEvent('doom:shop', v.Name, v.Price)
                end
            end)
        end
    end)

      if not RageUI.Visible(Chasse) and not RageUI.Visible(ShopBlanche) and not RageUI.Visible(ShopFeu) and not RageUI.Visible(ShopNul) then
          Chasse = RMenu:DeleteType("Chasse", true)
        end
    end
end


local position = {
       {x = -675.24, y = 5836.65, z = 17.34}
    }    

Citizen.CreateThread(function()
    for k, v in pairs(position) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 52)
        SetBlipScale (blip, 0.65)
        SetBlipColour(blip, 18)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Armurerie de Chasse')
        EndTextCommandSetBlipName(blip)
    end
end)    
    
 Citizen.CreateThread(function()
    while true do
        local sleep = 500
            for k in pairs(position) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
                    if dist <= 1.0 then
                    sleep = 0
                    RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour acheter des ~r~équipements de chasse", time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        OpenShopChasse()
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)
