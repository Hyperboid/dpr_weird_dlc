local Sloppo, super = Class(EnemyBattler)

function Sloppo:init()
    super.init(self)

    -- Enemy name
    self.name = "Sloppo the slopster"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("sloppo")

    -- Enemy health
    self.max_health = 4000
    self.health = self.max_health
    -- Enemy attack (determines bullet damage)
    self.attack = 4
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 20

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "it needs to be more interesting",
        "happy new year 1969",
        "you've got a\n"*4,
    }
    if Game.save_name:upper() == "SHAYY" then
        local hour = os.date("*t").hour
        if hour < 8 or hour >= 21 then
            table.insert(self.dialogue, "streemurr it's late\ngo to bed")
        end
        table.insert(self.dialogue, "quests to release\nof chjatper 3")
    end

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 4 DF 0\n* Cotton heart and button eye\n* Looks just like a fluffy guy."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The dummy gives you a soft\nsmile.",
        "* The power of fluffy boys is\nin the air.",
        "* Smells like cardboard.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The dummy looks like it's\nabout to fall over."

    -- Register act called "Smile"
    self:registerAct("Act")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("Fake Joke", "", {"ralsei"})
    self.name_rng = love.math.newRandomGenerator(RUNTIME)
    self.name_timer = 0
end

function Sloppo:hurt(amount, battler, on_defeat)
    -- Effectively take 4x damage from Spare Smack
    if battler.chara.id == "noel" then
        amount = amount + 3
    end
    super.hurt(self, amount, battler, on_defeat)
end

function Sloppo:update()
    super.update(self)
    self.name_timer = self.name_timer + (DT/0.1)
    if self.name_timer < 1 then return end
    self.name_timer = self.name_timer - 1
    local name = "SLOPPO THE SLOPTSTER"
    self.name = ""
    for i=1,#name do
        if self.name_rng:random() > 0.6 then
            self.name = self.name .. (name[i]:lower())
        else
            self.name = self.name .. name[i]
        end
    end
end

function Sloppo:onAct(battler, name)
    if name == "Smile" then
        -- Give the enemy 100% mercy
        self:addMercy(100)
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "... ^^"
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You smile.[wait:5]\n* The dummy smiles back.",
            "* It seems the dummy just wanted\nto see you happy."
        }

    elseif name == "Tell Story" then
        -- Loop through all enemies
        for _, enemy in ipairs(Game.battle.enemies) do
            -- Make the enemy tired
            enemy:setTired(true)
        end
        return "* You and Ralsei told the dummy\na bedtime story.\n* The enemies became [color:blue]TIRED[color:reset]..."

    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(50)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The dummy spiritually bowed\nin return."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Sloppo