#!/usr/bin/python3
import os
import json

def main():

	home = os.path.expanduser('~')
	xmobarrc_filepath = (home + "/.config/xmobar/xmobarrc")
	kitty_filepath = (home + "/.config/kitty/kitty.conf")
	xmonad_filepath = (home + "/.xmonad/xmonad.hs")
	json_filepath = (home + "/.cache/wal/schemes/_colors.json")
	savefile_path = (home + "/.scripts/files/")
	
	if not os.path.exists(savefile_path):
		os.makedirs(savefile_path)

	replace_kitty_colors(kitty_filepath, json_filepath, savefile_path)
	replace_xmobar_colors(xmobarrc_filepath, json_filepath, savefile_path)
	replace_xmonad_colors(xmonad_filepath, json_filepath, savefile_path)
	print("Files saved to: " + savefile_path)

def replace_kitty_colors(file1, file2, new_filepath):
	kitty_file = open(new_filepath + "_.conf", 'w+')
	open_conf = open(file1, 'r').read()
	json_file = json.loads(open(file2, 'r').read())
	lines = open_conf.splitlines()
	counter = 0
	for line in lines:
		text = line.split() 
		for i in range(0, len(text)):
			if (counter > 370 and counter < 378) and (text[i] == "foreground" or text[i] == "background"):
				color = json_file['special'][text[i]]
				text[i+1] = color
			else:
				for j in range (0,16):
					color = "color" + str(j)
					if text[i] == color:
						text[i+1] = json_file['colors'][color]
					else:
						pass
		new_line = (" ".join(text) + "\n")
		kitty_file.write(new_line)
		counter += 1

def replace_xmobar_colors(file1, file2, new_filepath):
	xmobar_file = open(new_filepath + "_xrc", 'w+')
	open_conf = open(file1, 'r').read()
	json_foreground = json.loads(open(file2, 'r').read())['colors']['color1']
	json_background = json.loads(open(file2, 'r').read())['special']['background']
	for i in range(0, len(open_conf.split())):
		if open_conf.split()[i] == "fgColor":
			reference = open_conf.split()[i+2]
		elif open_conf.split()[i] == "bgColor":
			reference2 = open_conf.split()[i+2]
	for line in open_conf.splitlines():
		text = line.split(" ")
		for i in range(0, len(text)):
			if text[i] == reference:
				text[i] = '"' + json_foreground + '"'
			elif text[i] == reference2:
				text[i] = '"' + json_background + '"'
			elif text[i][:4] == ("<fc="):
				text[i] = text[i][:4] + json_foreground + text[i][11:]
			elif text[i][:5] == '"<fc=':
				text[i] = text[i][:5] + json_foreground + text[i][12:]
			elif text[i][:7] == "</fn>|<":
				text[i] = text[i][:10] + json_foreground + text[i][17:]
			else:
				pass
		new_line = (" ".join(text) + "\n")
		xmobar_file.write(new_line)

def replace_xmonad_colors(file1, file2, new_filepath):
	monad_file = open(new_filepath + "_testmonad.hs", 'w+')
	lines = (open(file1, 'r').read()).split("\n")
	json_foreground = json.loads(open(file2, 'r').read())['colors']['color1']
	for line in lines:
		text = line.split(" ")
		for i in range(0, len(text)):
			if text[i] == "ppTitle":
				text[i+5] = '"' + json_foreground + '"'
			elif text[i] == "ppHidden":
				text[i+4] = '"' + json_foreground + '"'
			else:
				pass
		new_line = (" ".join(text) + "\n")
		monad_file.write(new_line)

if __name__ == "__main__":
	main()
