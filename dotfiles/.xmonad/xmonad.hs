--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad

--Data

import Data.Ratio
import Data.Monoid
import Data.Maybe (fromJust, isJust)

--

import System.Exit
import XMonad.Util.Scratchpad
import XMonad.Util.SpawnOnce
import XMonad.Util.Run

--Hooks

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (doCenterFloat, isFullscreen, doFullFloat)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))

--Actions 
import XMonad.Actions.CycleWS
import XMonad.Actions.FloatSnap
import XMonad.Actions.FloatKeys


--Layouts
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.Grid (Grid(..))
import XMonad.Layout.Spiral
import XMonad.Layout.Magnifier
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 0

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..]

      --scratchpad workspace
        where nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))
              nonEmptyNonNSP = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

clickable :: String -> String
clickable s = "<action=xdotool key super+" ++ show i ++ ">" ++ s ++ "</action>"
                where i = fromJust $ M.lookup s myWorkspaceIndices

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#555555"
myFocusedBorderColor = "#555555"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch libreoffice
    , ((modm,               xK_z     ), spawn "libreoffice")

    --launch secondary terminal "st"
    , ((modm .|. shiftMask, xK_Return), spawn "st bash")
    
    --launch amfora gemini browser
    , ((modm,               xK_g     ), spawn "kitty amfora")

    -- launch librewolf browser
    , ((modm .|. shiftMask, xK_l     ), spawn "librewolf")
  
    --launch newsboat
    , ((modm,               xK_r     ), spawn "kitty newsboat")

    , ((modm .|. shiftMask, xK_r     ), spawn "kitty ranger") 

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch ncmpcpp
    , ((modm,               xK_y     ), spawn "st ncmpcpp")

    --launch signal
    , ((modm,               xK_s     ), spawn "signal-desktop")

    --launch steam
    , ((modm .|. shiftMask, xK_g     ), spawn "steam")
    
    --take screenshot
    , ((modm .|. shiftMask, xK_s     ), spawn "scrot /home/zalazalaza/Pictures/new_scrot.png")

    --take screenshot with selection
    ,((modm .|. shiftMask,  xK_z     ), spawn "scrot -s") 
    
    --launch telegram
    , ((modm,               xK_d     ), spawn "telegram-desktop")

    --launch thunar file manager
    , ((modm,               xK_t     ), spawn "thunar")

    -- close focused window
    , ((modm,               xK_n     ), spawn "nitrogen")

    --spawn firefox
    , ((modm,               xK_space ), spawn "firefox-esr")

    --spawn 
    ,((modm,                xK_q     ), kill)

    -- Rotate through the available layout algorithms
    , ((modm .|. shiftMask, xK_period), sendMessage NextLayout)
    
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm .|. shiftMask, xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)


    -- Move focus to the previous window
    , ((modm .|. shiftMask, xK_Tab     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_w), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_b     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- keybindings for window snapping
    , ((modm              , xK_Left),   withFocused $ snapMove L Nothing)
    , ((modm              , xK_Right),  withFocused $ snapMove R Nothing)
    , ((modm              , xK_Up),     withFocused $ snapMove U Nothing)
    , ((modm              , xK_Down),   withFocused $ snapMove D Nothing)
    , ((modm .|. shiftMask, xK_Left),   withFocused $ snapShrink R Nothing)
    , ((modm .|. shiftMask, xK_Right),  withFocused $ snapGrow R Nothing)
    , ((modm .|. shiftMask, xK_Up),     withFocused $ snapShrink D Nothing)
    , ((modm .|. shiftMask, xK_Down),   withFocused $ snapGrow D Nothing)

    -- toggle float and resize with keys
    , ((modm .|. shiftMask, xK_a),      withFocused $ keysResizeWindow (-50,-20) (1/2,1/2))

    , ((modm .|. shiftMask, xK_x),      withFocused $ keysResizeWindow (50, 20) (1/2,1/2))
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm .|. shiftMask, xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_a     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_f] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm .|. shiftMask, button1), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.


--old Layout with lots of options

myLayout = spacing 6 (avoidStruts(tiled ||| Full ||| magnifier (Tall 1 (3/100) (1/2)) ))

--OLD LAYOUT

--myLayout = spacing 6 (avoidStruts(tiled ||| Full ||| magnifier (Tall 1 (3/100) (1/2)) ||| spiral (6/7) ||| Mirror tiled ||| simpletabbed ||| grid ||| floats))
--
--END OF OLD LAYOUT

  where
    -- default tiling algorithm partitions the screen into two panes
    --  floats = simplestFloat
    
     tiled   = Tall nmaster delta ratio
    
     -- grid = Grid

     -- simpletabbed = simpleTabbed

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "st-256color"    --> doCenterFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook h = dynamicLogWithPP $ xmobarPP
                  { ppTitle   = xmobarColor "#5f9ef3" "" . shorten 12
                  , ppCurrent = xmobarColor "#de1fda" "" . wrap "[" "]" 
                  , ppHidden  = xmobarColor "#5f9ef3" "" 
                  , ppHiddenNoWindows = xmobarColor "#555555"  ""
                  , ppOutput  = hPutStrLn h 
                  --, ppLayout = id
                  , ppLayout  = (\l -> case l of
                      "Spacing Tall"                  -> "[|]"
                      "Spacing Mirror Tall"           -> "[=]"
                      "Spacing Full"                  -> "[ ]"
                      "Spacing Tabbed Simplest"       -> "[_]"
                      "Spacing Grid"                  -> "[#]"
                      "Spacing SimplestFloat"         -> "[^]"
                      "Spacing Magnifier Tall"        -> "[0]"
                      "Spacing Spiral"                -> "[@]"
                      )   
                  }


------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
        spawnOnce "picom --experimental-backend &"
        --spawnOnce "wal -i /home/zalazalaza/Pictures/wallpaper/wallpaper.jpg &"
        spawnOnce "nitrogen --restore"
        --spawnOnce "picom &"
        spawnOnce "stalonetray &"
        spawnOnce "pasystray &"
        spawnOnce "nm-applet &"
        spawnOnce "blueman-applet &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmproc <- spawnPipe "xmobar -x 0 /home/zalazalaza/.config/xmobar/xmobarrc"
  xmonad $ docks $ defaults xmproc

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults h = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook h <+> dynamicLogWithPP xmobarPP,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
