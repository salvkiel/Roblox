local me = game.Players.LocalPlayer.Character
for _,p in pairs(game.Players:GetPlayers()) do
    if p ~= game.Players.LocalPlayer and p.Character then
        p.Character:MoveTo(me.HumanoidRootPart.Position + Vector3.new(0,5,0))
    end
end
