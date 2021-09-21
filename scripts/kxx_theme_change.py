#!/usr/bin/python3
import os
import json

def main():

	home = os.path.expanduser('~')
	xmobarrc_filepath = (home + "/.config/xmobar/xmobarrc")
	kitty_filepath = (home + "/.config/kitty/kitty.conf")
	xmonad_filepath = (home + "/.xmonad/xmonad.hs")
	json_filepath = (home + "/.scripts/files/_colors.json")
	savefile_path = (home + "/.scripts/files/")
	
	if os.path.exists(savefile_path + "_xrc"):
		os.remove(savefile_path + "_xrc")
	
	if os.path.exists(savefile_path + "_testmonad"):
		os.remove(savefile_path + "_testmonad")

	if os.path.exists(savefile_path + "_.conf"):
		os.remove(savefile_path + "_.conf")
	
	if not os.path.exists(savefile_path):
		os.makedirs(savefile_path)

	replace_kitty_colors(kitty_filepath, json_filepath, savefile_path)
	replace_xmobar_colors(xmobarrc_filepath, json_filepath, savefile_path)
	replace_xmonad_colors(xmonad_filepath, json_filepath, savefile_path)
	replace_config_files(savefile_path, kitty_filepath, xmobarrc_filepath, xmonad_filepath)

	print("Files saved to: " + savefile_path)
	

def replace_config_files(newfile_path, kitty_path, xmobar_path, xmonad_path):
	
	with open(newfile_path + "_.conf", 'r') as kitty:
		kitty_data = kitty.read()
	with open(kitty_path, 'w') as old_kitty:
		old_kitty.write(kitty_data)
	
	with open(newfile_path + "_xrc", 'r') as xmobar:
		xmobar_data = xmobar.read()
	with open(xmobar_path, 'w') as old_xmobar:
		old_xmobar.write(xmobar_data)
	
	with open(newfile_path + "_testmonad.hs", 'r') as xmonad:
		xmonad_data = xmonad.read()
	with open(xmonad_path, 'w') as old_xmonad:
		old_xmonad.write(xmonad_data)
	



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
