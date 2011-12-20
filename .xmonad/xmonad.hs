import Data.Monoid
import Data.Bits
import System.Exit

import XMonad
import XMonad.ManageHook

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed

import XMonad.Actions.CycleWS
import XMonad.Actions.DwmPromote

import XMonad.Prompt
import XMonad.Prompt.XMonad

import XMonad.Util.Run
import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


myTerminal      = "urxvtc"

myWorkspaces    = ["1:main", "2:code", "3:web", "4:chat", "5:mail" ] ++ map show [6..9]

myBorderWidth   = 1
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#00ff00"

myModMask       = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
 
    , ((modm,                     xK_p), spawn "exe=`dmenu_run` && eval \"exec $exe\"")
    , ((controlMask .|. mod1Mask, xK_l),     spawn "exe=`slock` && eval \"exec $exe\"")  

    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,               xK_n     ), refresh)
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp)
    , ((modm,               xK_m     ), windows W.focusMaster)
    , ((modm,               xK_Return), dwmpromote) -- use dwm promotion style
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown)
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp)
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm .|. shiftMask, xK_comma ), sendMessage (IncMasterN 1))
    , ((modm .|. shiftMask, xK_period), sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    , ((0,    xK_Print), spawn "scrot '%Y-%m-%d_$wx$h.png'")

    -- bindings for CycleWS
    , ((mod1Mask,               xK_j  ), nextWS)
    , ((mod1Mask,               xK_k  ), prevWS)
    , ((mod1Mask .|. shiftMask, xK_j  ), shiftToNext >> nextWS)
    , ((mod1Mask .|. shiftMask, xK_k  ), shiftToPrev >> prevWS)
    , ((mod1Mask,               xK_u  ), nextScreen)
    , ((mod1Mask,               xK_n  ), prevScreen)
    , ((mod1Mask .|. shiftMask, xK_u  ), shiftNextScreen >> nextScreen)
    , ((mod1Mask .|. shiftMask, xK_n  ), shiftPrevScreen >> prevScreen)
    , ((mod1Mask,               xK_Tab), toggleWS)
 
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
 
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
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

myLayout = tiled ||| Mirror tiled ||| full ||| myTabbed
  where
    full   = noBorders Full
    tiled  = smartBorders $ Tall 1 (3/100) (1/2)
    myTabbed = noBorders $ simpleTabbed
 
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Xfce4-notifyd"  --> doIgnore
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]
 
myEventHook = mempty

statusBarCmd= "dzen2 -e '' -w 840 -ta l -fn '-*-terminus-*-*-*-*-12-*-*-*-*-*-*-*' -bg black -fg #d3d7cf ^i(/home/ivan/.dzen/arch_10x10.xbm)  "
myPP h = defaultPP
                 {  ppCurrent = wrap "^fg(#000000)^bg(#a0a0a0) " " ^fg()^bg()"
                  , ppHidden  = wrap "^i(/home/ivan/.dzen/has_win_nv.xbm)" " "
                  , ppHiddenNoWindows  = wrap " " " "
                  , ppSep     = " ^fg(grey60)^r(3x3)^fg() "
                  , ppWsSep   = ""
                  , ppLayout  = dzenColor "#878787" "" .
                                (\x -> case x of
                                         "Tall"  -> "^i(/home/ivan/.dzen/tall.xbm)"
                                         "Mirror Tall" -> "^i(/home/ivan/.dzen/mtall.xbm)"
                                         "Full" -> "^i(/home/ivan/.dzen/full.xbm)"
                                )
                  , ppTitle   = dzenColor "white" "" . wrap "< " " >"
                  , ppOutput  = hPutStrLn h
                  , ppUrgent = dzenColor "green" "#878787" . dzenStrip
                  }

main = do
    dzen <- spawnPipe statusBarCmd
    xmonad $ withUrgencyHook dzenUrgencyHook { args = ["-fn", "-*-terminus-*-*-*-*-12-*-*-*-*-*-*-*","-bg", "green", "-fg", "#878787"] }
        $ defaultConfig {
            terminal           = myTerminal,
            focusFollowsMouse  = False,
            borderWidth        = myBorderWidth,
            modMask            = myModMask,
            workspaces         = myWorkspaces,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,
            keys               = myKeys,
            mouseBindings      = myMouseBindings,
            layoutHook         = avoidStruts $ myLayout,
            manageHook         = myManageHook,
            handleEventHook    = myEventHook,
            logHook            = dynamicLogWithPP $ myPP dzen
        }
