local Gravit = BaseHuman:New {
    name                = "Gravit",
    activateWhenBuilt   = true,
    customParams = {
        player = true,
        radius = 20,
    },

    idletime = 120, --in simframes
    idleautoheal = 50,
    autoheal = 1,

    weapons = {
        { name = "GRAVITY_POS"},
        { name = "GRAVITY_NEG"},
    },

    maxDamage           = 1600,
    maxVelocity         = 5,
    onoffable           = true,
    fireState           = 0,
    moveState           = 0,
    script              = "gravit.lua",

    buildPic = "",
}


return lowerkeys({
    Gravit = Gravit,
})
