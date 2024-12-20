local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* The tutorial begins...?"

    -- Battle music ("battle" is rude buster)
    self.music = "booty_boss.loop"
    -- Enables the purple grid battle background
    self.background = false

    -- Add the dummy enemy to the encounter
    self:addEnemy("sloppo")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

function Dummy:drawBackground(fade)
    local scale_fac = 16
    local canvas = Draw.pushCanvas(SCREEN_WIDTH/scale_fac, SCREEN_HEIGHT/scale_fac)
    Draw.setColor({.8,.8,.8}, fade)
    Draw.rectangle("fill", 0,0,SCREEN_WIDTH/scale_fac, SCREEN_HEIGHT/scale_fac)
    love.graphics.setShader()
    Draw.popCanvas()
    Draw.setColor(COLORS.white, fade)
    Draw.draw(canvas,0,0,0,scale_fac,scale_fac)
    return false
end

return Dummy