local SomeKingOfFrozenHeart, super = Class(Soul)

function SomeKingOfFrozenHeart:init(x,y,color)
    super.init(self,x,y,color)
    self.speed = 0
    self.sprite.visible = false
    self.icebreak = -5
end

function SomeKingOfFrozenHeart:update()
    super.update(self)
    if self.transitioning then return end
    local keys = {"confirm", "cancel", "menu", "up", "left", "down", "right"}
    for _, key in ipairs(keys) do
        if Input.pressed(key, false) then
           self.icebreak =  self.icebreak + 1
            if self.icebreak >= 0 then
                Assets.playSound("bigcut")
                Game.battle:swapSoul(Soul())
            else
                Assets.playSound("break1")
                if key == "up" or key == "down" then
                    self:shake(0,2,1, 1/30)
                else
                    self:shake(2,0,1, 1/30)
                    
                end
            end
        end
    end
end

function SomeKingOfFrozenHeart:draw()
    super.draw(self)
    self.freeze_progress = 1
    if self.freeze_progress < 1 then
        Draw.pushScissor()
        Draw.scissorPoints(nil, self.sprite.texture:getHeight() * (1 - self.freeze_progress), nil, nil)
    end

    love.graphics.translate(-10,-10)
    local last_shader = love.graphics.getShader()
    local shader = Kristal.Shaders["AddColor"]
    love.graphics.setShader(shader)
    shader:send("inputcolor", {0.8, 0.8, 0.9})
    shader:send("amount", 1)

    local r,g,b,a = self:getDrawColor()

    Draw.setColor(0, 0, 1, a * 0.8)
    Draw.draw(self.sprite.texture, -1, -1)
    Draw.setColor(0, 0, 1, a * 0.4)
    Draw.draw(self.sprite.texture, 1, -1)
    Draw.draw(self.sprite.texture, -1, 1)
    Draw.setColor(0, 0, 1, a * 0.8)
    Draw.draw(self.sprite.texture, 1, 1)

    love.graphics.setShader(last_shader)

    love.graphics.setBlendMode("add")
    Draw.setColor(0.8, 0.8, 0.9, a * 0.4)
    Draw.draw(self.sprite.texture)
    love.graphics.setBlendMode("alpha")

    if self.freeze_progress < 1 then
        Draw.popScissor()
    end
end

return SomeKingOfFrozenHeart
