#define GUI_GRID_WAbs            ((safeZoneW / safeZoneH) min 1.2)
#define GUI_GRID_HAbs            (GUI_GRID_WAbs / 1.2)
#define GUI_GRID_W            (GUI_GRID_WAbs / 40)
#define GUI_GRID_H            (GUI_GRID_HAbs / 25)

class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    WMT_Hint[] = {
                        {
                            (safeZoneX + safeZoneW - GUI_GRID_W),
                            (safeZoneY + 6 * GUI_GRID_H),
                            (3 * GUI_GRID_W),
                            (3 * GUI_GRID_H)
                        },
                        GUI_GRID_W,
                        GUI_GRID_H
                    };
                };
            };
        };

        class Variables {
            class WMT_Hint {
                displayName = "WMT Hint";
                description = "WMT Hint";
                preview = "#(argb,8,8,3)color(0,0,0,0.25)";
                saveToProfile[] = {0,1};
            };
        };
    };
};
