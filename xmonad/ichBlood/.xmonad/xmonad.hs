---IchBlood by Annisa Ritsu Lina
--edited from .ge. and .di. config
import XMonad
import Control.Monad
import System.IO
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Script
import XMonad.Hooks.SetWMName
import XMonad.Util.Run	(spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.SpawnOnce
import XMonad.Util.Loggers
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS (prevWS, nextWS)
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified GHC.IO.Handle.Types as H
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.Grid

col1 = "#2d2d2d"
col2 = "#ffffff"
col3 = "#ab363f"
col4 = "#cccccc"
col5 = "#89362D"
bar1 = "dzen2 -p -ta l -e 'button3=' -fn 'bitocra-7' -fg '" ++ col2 ++ "' -bg '" ++ col1 ++ "' -h 20 -w 700"
bar2 = "sh /home/ritsu/.xmonad/scripts/dzeninfo.sh"
awp = " ^fg(" ++ col4 ++ ")^r(48x12)^fg()^p(-44)^ib(1)^fg(" ++ col1 ++ ") "
iwp = " ^fg(" ++ col3 ++ ")^r(48x12)^fg()^p(-44)^ib(1)^fg(" ++ col2 ++ ") "
clIc = "^ca(1,xdotool key alt+space)^i(/home/ritsu/.xmonad/icons/"


startup = do
		spawnOnce "xrdb ~/.Xresources &"
		spawnOnce "xsetroot -cursor_name left_ptr &"
		spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
		spawnOnce "nitrogen --restore &"
		spawnOnce "compton --config ~/.comptonrc &"
		spawnOnce "mpd &"
		spawnOnce "urxvtd &"
		spawnOnce "kampret &"
		spawnOnce "clipit &"

logHookKu h = do
		dynamicLogWithPP $ tryPP h

tryPP :: Handle -> PP
tryPP h = defaultPP
		{ ppOutput		= hPutStrLn h
		, ppCurrent		= wrap awp " ^fg() "
		, ppVisible		= wrap iwp " ^fg() "
		, ppHidden		= wrap iwp " ^fg() "
		, ppHiddenNoWindows	= wrap iwp " ^fg() "
		, ppWsSep		= ""
		, ppSep			= ""
		, ppLayout		= dzenColor col2 col1 . pad . 
			( \t -> case t of
			"Grid"						-> "" ++ clIc ++ "grid.xbm) GR^ca()"
			"Spacing 10 Tall"			-> "" ++ clIc ++ "sptall.xbm) ST^ca()"
			"Mirror Spacing 10 Tall"	-> "" ++ clIc ++ "mptall.xbm) MT^ca()"
			"Full"						-> "" ++ clIc ++ "full.xbm) FF^ca()"
			)					
		, ppOrder		= \(ws:l:_:_) -> [l,ws]
		}


desktopKu :: [String]
desktopKu = clickable $ [ "conn"
		, "term"
		, "inet"
		, "shit"
		, " etc"
		]
		where clickable l = [ "^ca(1,xdotool key alt+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
			(i,ws) <- zip [1..] l,
			let n = i ]

keybindingKu = [ ((mod1Mask, xK_p), spawn "dmenu_run -b") 
		, ((mod1Mask, xK_q), spawn "killall dzen2; xmonad --recompile; xmonad --restart")]

layoutKu = avoidStruts (  Grid ||| tiled ||| Mirror tiled ||| Full )
		where 
			tiled = spacing 10 $ Tall 1 (1/2) (1/2)
fuckHook = composeAll 
		[ className =? "Gimp" --> doFloat
		, className =? "mplayer2" --> doFloat ]

main = do
		barKiri <- spawnPipe bar1
		barKanan <- spawnPipe bar2
		xmonad $ defaultConfig
			{ manageHook = fuckHook <+> manageDocks <+> manageHook defaultConfig
			, layoutHook = layoutKu
			, modMask = mod1Mask
			, workspaces = desktopKu
			, terminal = "urxvtc"
			, focusedBorderColor = "" ++ col3 ++ ""
			, normalBorderColor = "" ++ col5 ++ ""
			, borderWidth = 3
			, startupHook = startup <+> setWMName "LG3D"
			, logHook = logHookKu barKiri
			} `additionalKeys` keybindingKu

