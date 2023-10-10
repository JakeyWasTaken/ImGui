export type PossibleImGuiWindowFlags = "NoTitleBar" | "NoBackground" | "NoCollapse" | "NoClose" | "NoMove" | "NoScrollbar" | "NoResize" | "NoNav" | "NoMenu"
export type ImGuiWindowFlags = {[number]: PossibleImGuiWindowFlags}

export type ImGuiId = string

local Types = {}

Types.ImGuiWindowFlags = {
    NoTitleBar = "NoTitleBar",
    NoBackground = "NoBackground",
    NoCollapse = "NoCollapse",
    NoClose = "NoClose",
    NoMove = "NoMove",
    NoScrollbar = "NoScrollbar",
    NoResize = "NoResize",
    NoNav = "NoNav",
    NoMenu = "NoMenu",
}

return Types
