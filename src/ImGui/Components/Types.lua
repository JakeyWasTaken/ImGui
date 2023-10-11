local Components = script.Parent
local Stack = require(Components.Stack)

export type PossibleImGuiWindowFlags = "NoTitleBar" | "NoBackground" | "NoCollapse" | "NoClose" | "NoMove" | "NoScrollbar" | "NoResize" | "NoNav" | "NoMenu"
export type ImGuiWindowFlags = {[number]: PossibleImGuiWindowFlags}

export type ImGuiId = string

export type DOM = {[string]: GenericWidget | ImGuiWindow}

export type Style = {[string]: any}

export type Internal = {
    IdStack: Stack.Stack<ImGuiId>,
    RenderTarget: BasePlayerGui,
    Context: {
        DOM: DOM,
        LastDOM: DOM,
        ActiveWindow: ImGuiWindow | nil,
        ActiveStyle: Style,
    }
}

export type GenericWidget = {
    Id: ImGuiId,
    Instance: Instance,
    State: {}
}
export type ImGuiWindow = GenericWidget & {
    State: {
        CreationCycle: number,
        Size: Vector2,
    }
}

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
