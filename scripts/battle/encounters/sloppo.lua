local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* The [style:GONER][color:red][speed:0.5][font:main_mono,48]Tutoriel[font:reset][speed:1][style:reset][color:reset] begins"

    -- Battle music ("battle" is rude buster)
    self.music = "booty_boss.loop"
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("sloppo")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

return Dummy